# Copyright University of Southern California 2019
#
# DISCLAIMER. USC MAKES NO EXPRESS OR IMPLIED WARRANTIES, EITHER IN FACT OR BY
# OPERATION OF LAW, BY STATUTE OR OTHERWISE, AND USC SPECIFICALLY AND EXPRESSLY
# DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE, VALIDITY OF THE SOFTWARE OR ANY OTHER INTELLECTUAL PROPERTY
# RIGHTS OR NON-INFRINGEMENT OF THE INTELLECTUAL PROPERTY OR OTHER RIGHTS OF ANY
# THIRD PARTY. SOFTWARE IS MADE AVAILABLE AS-IS.
# LIMITATION OF LIABILITY. TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT WILL
# USC BE LIABLE TO ANY USER OF THIS CODE FOR ANY INCIDENTAL, CONSEQUENTIAL, EXEMPLARY
# OR PUNITIVE DAMAGES OF ANY KIND, LOST GOODWILL, LOST PROFITS, LOST BUSINESS AND/OR
# ANY INDIRECT ECONOMIC DAMAGES WHATSOEVER, REGARDLESS OF WHETHER SUCH DAMAGES
# ARISE FROM CLAIMS BASED UPON CONTRACT, NEGLIGENCE, TORT (INCLUDING STRICT LIABILITY
# OR OTHER LEGAL THEORY), A BREACH OF ANY WARRANTY OR TERM OF THIS AGREEMENT, AND
# REGARDLESS OF WHETHER USC WAS ADVISED OR HAD REASON TO KNOW OF THE POSSIBILITY OF
# INCURRING SUCH DAMAGES IN ADVANCE.
#
# Author: Travis Haroldsen
#

"""Code for generating the PLB test cases."""

from __future__ import annotations

import argparse
import hashlib
import logging
import os
import shutil
from abc import abstractmethod, ABC
import dataclasses as dc
from functools import partial
from math import ceil
from pathlib import Path
from typing import List, Collection, Sequence, Tuple, Optional

from ..common import ConstraintsGenerator, guess_hdl_file_type
from ..simulate import Simulator
from ift.application.build import Builder, BuildOutput, BuilderParameter, TestSpecification, SimulationError
from ift.device_info import Resource
from ift.utils.helpers import str_bool, VarLockWrapper
from ift.utils.version import Version
from ift.utils import HdlFile

_script_dir = Path(__file__).absolute().parent
_hdl_dir = _script_dir/'hdl'
_debug_dir = _script_dir/'..'/'debug'

LOG = logging.getLogger('ift.build.plbs')

@dc.dataclass(frozen=True)
class _SimulationArguments:
    hdl_files: Sequence[HdlFile]
    expected_result: str


@dc.dataclass(frozen=True)
class _Arguments:
    """Arguments for a test component provided to builder."""

    sites: List[Resource]
    """List of sites to test."""

    index: int
    """Index of the component in the test."""

    part: str
    """Device identifier of the part to test."""

    specification: PLBTestSpecification
    """Test specification to build."""

    io_files: List[HdlFile]
    """User provided IO wrapper for test."""

    capture_file: HdlFile
    """Module to use for capturing and reporting results."""

    simulate: bool
    """`True` to perform RTL simulation and verification of the test design."""

    clock_period: float
    """Clock period to use for calculating run time duration of the tests."""


@dc.dataclass(frozen=True)
class VhdlConstant:
    """VHDL constant to be added to the VHDL package."""
    name: str
    type: str
    value: str


@dc.dataclass
class IntWrapper:
    val: int


class _PLBBuilder(Builder):
    """Builder used for generating the PLB tests."""

    VERSION = Version(1, 1)

    @classmethod
    def arguments(cls):
        return [BuilderParameter('io', 'files:vhd:v:ucf', 'IO Files', True, ''),
            BuilderParameter('region', 'string', 'Regions', False, ''),
            BuilderParameter('capture', 'choice:small:full', 'Capture Type', True, 'small'),
            BuilderParameter('clk_period', 'string', 'Clock Period (ns)', False, '50.0'),
            BuilderParameter('spacing', 'string', 'Spacing', False, ''), ]

    """A test configuration describing how a test should be built."""
    def __init__(self, specification, device_info, *, io, region=None, simulate=False,
            verify=False, test_mode=False, capture='small', clk_period="50.0", spacing=None):
        super(_PLBBuilder, self).__init__()
        self.specification = specification
        self.device_info = device_info
        self.user_regions = region
        self.verify = str_bool(verify) or str_bool(simulate)
        self.test_mode = str_bool(test_mode)
        if type(spacing) is str:
            spacing = eval(spacing)
        self.spacing = spacing
        self.build_count = VarLockWrapper(IntWrapper(0))
        self.num_tests = None  # set later

        try:
            self.clock_period = float(clk_period)
        except ValueError as e:
            raise argparse.ArgumentError(None, 'argument clk_period: expected integer') from e

        if capture.lower() == 'small':
            capture_file = 'capture_small.vhd'
        elif capture.lower() == 'full':
            capture_file = 'capture_full.vhd'
        else:
            raise argparse.ArgumentError(None, 'argument --capture: expected one of (small, full): --capture')
        self.capture_file = HdlFile(_hdl_dir/capture_file, 'vhdl', 'work')

        # Retrieve and interpret the IO files
        self.io_files = []
        for io_file in io.split(','):
            self.io_files.append(guess_hdl_file_type(io_file))

    def name(self) -> str:
        """Name of the test"""
        return self.specification.name

    def hash(self) -> str:
        m = hashlib.md5()
        m.update(self.__module__.encode('utf-8'))
        m.update(self.__class__.__qualname__.encode('utf-8'))
        m.update(self.name().encode('utf-8'))
        m.update(str(self.VERSION).encode('utf-8'))
        m.update(str(self.specification.version()).encode('utf-8'))
        m.update(self.device_info.device.encode('utf-8'))
        for io_file in sorted(self.io_files, key=dc.astuple):
            with open(io_file.path, 'rb') as f:
                m.update(f.read())

        if self.user_regions is not None:
            m.update(self.user_regions.encode('utf-8'))
        return m.hexdigest()[-12:]

    def parameter_sets(self):
        regions = list(self.specification.get_regions(self.user_regions, self.device_info, self.spacing))
        spec = self.specification()
        part = self.device_info.device
        args = [_Arguments(list(r), i, part, spec, self.io_files, self.capture_file, self.verify, self.clock_period)
            for i, r in enumerate(regions)]
        args = [arg for arg in args if len(arg.sites) > 0]
        if self.test_mode:
            self.num_tests = 1
            return args[:1]
        self.num_tests = len(args)
        return args

    @property
    def build(self):
        return _build

    def finish_build(self, success, arguments, tool_outputs=None, *args):
        with self.build_count as count:
            count.val += 1

    @property
    def build_progress(self):
        with self.build_count as count:
            return count.val / self.num_tests


def _build(test_name, args: _Arguments, build_dir, results_dir):
    bitstream = build_test(test_name, args, build_dir, results_dir)

    # Write coverage file
    coverage_file = results_dir/f'coverage-{args.index}'
    with open(coverage_file, 'w') as f:
        for plb in args.sites:
            print(plb, file=f)

    # Write the runner file
    kwd = {}
    kwd['bitstream'] = str(bitstream.name)
    kwd['test_name'] = args.specification.name
    kwd['region'] = str(args.sites)
    kwd['description'] = args.specification.description
    kwd['run_time'] = args.specification.test_time(uuts=args.sites, period_in_ns=args.clock_period)

    runner_file = results_dir/f'runner-{args.index}'
    with open(runner_file, 'w') as o, open(_script_dir / 'test.py.template', 'r') as i:
        for line in i:
            o.write(line.format(**kwd))

    return (BuildOutput(bitstream, coverage_file, runner_file), )


class PLBVendor(ABC):
    """Provides an interface between the IFT tools and the vendor CAD tools."""

    @abstractmethod
    def place_and_route(self, part, plb_entities, harness_files, work_dir):
        """Called by the test builder to place and route (and possibly generate the bitstream of)
        the test design.

        The plb entity files are passed separately so that they can be synthesized separately from
        the rest of the design. (ISE had problems instantiating all of the PLB modules in the whole
        design. The method should return the placed and routed netlist file.
        """
        ...

    @abstractmethod
    def make_bitstream(self, ncd_file, work_dir) -> Path:
        """Creates a bitstream from the placed and routed netlist.

        When separating the placement and routing from the bitstream generation is not supported, the
        netlist_file will be the bitstream file and this method should simply return the file."""
        ...


@dc.dataclass(frozen=True)
class PLBEntity:
    """Defines the VHDL entity for a PLB.

    Tests may have different implementations for different PLBs.  For example, a test on the carry
    chains may have three different implemenations of the PLBs depending on whether the PLB is at
    the start, middle or end of the chain.

    Instances of this class define the files used to instantiate each type of PLB.
    """
    type: str
    """The name of the PLB module."""

    files: List[HdlFile]
    """Design files for generating the PLB module."""

    def __iter__(self):
        yield self.type
        yield self.files


@dc.dataclass(frozen=True)
class PLBFiles:
    """Files for implementing and simulating PLBs in a design."""

    compilation: List[PLBEntity]
    """List of PLBEntity's that will be used for compiling the design."""

    gold: List[HdlFile]
    """Gold files used to provide the expected results for each tested PLB."""

    simulation: List[HdlFile]
    """List of simulation files for the PLBs used in verification."""


class PLBConfiguration(ABC):
    """Defines the hardware interface of the PLB UUTs and the files for generating the UUTs.

    The test generator uses objects of this class to determine how to implement the different
    possible PLBs and the module each PLB in the design should implement.
    """

    @abstractmethod
    def files(self, build_dir) -> PLBFiles:
        """The design files for simulating and building the UUT."""
        ...

    @property
    @abstractmethod
    def uut_types(self) -> List[str]:
        """The supported types of PLB for the test."""
        ...

    def entity_type(self, plb: Tuple[Resource, int], plbs: List[Resource]) -> str:
        """The type (or entity) of plb to implement.

        This method is provided to allow designs to use different plbs for different sites
        (e.g. carry chain begin middle and end blocks).

        The default implementation always returns `'plb'`.

        Args:
            `plb`: The PLB the current query is for.  The first item in the `Tuple` is
                the site location of the PLB, the second item is the index in the list `plbs`.  
            `plbs`: List of all resources to test in the design.  Made available so that the method may
                may look at the entire design to choose which module to implement for the current PLB.

        Returns:
            A string name of the module to implement.
        """
        return 'plb'

    @property
    @abstractmethod
    def num_outputs(self) -> int:
        """Number of outputs from the test plb.

        Will be written in the constants package."""
        ...

    @property
    def num_carries(self) -> int:
        """Number of carries to the next test plb.

        Will be written in the constants package.  Defaults to 0."""
        return 0


class TPG(ABC):
    """Specification of the test pattern generator.

    The test pattern generator (TPG) is responsible for creating the test inputs to exercise the
    resources in the design.  Subclasses of this class specify the design files to use to implement
    an instance of a TPG.
    """
    @property
    @abstractmethod
    def num_inputs(self) -> int:
        """The number of inputs to the test region coming from the TPG (outputs of the TPG)."""
        ...

    @property
    @abstractmethod
    def files(self) -> List[HdlFile]:
        """The HDL files for building the TPG."""
        ...

    @property
    @abstractmethod
    def cycles(self) -> int:
        """The number of cycles for the TPG to complete."""
        ...

    @property
    def package_constants(self) -> List[VhdlConstant]:
        """Any VHDL constants to be added to the global constants package."""
        return []


class SimpleTPG(TPG):
    """A TPG in which all parameters are specified at object creation."""
    def __init__(self, num_inputs: int, files: List[HdlFile], cycles: int):
        self._num_inputs = num_inputs
        self._files = files
        self._cycles = cycles

    @property
    def num_inputs(self) -> int:
        return self._num_inputs

    @property
    def files(self) -> List[HdlFile]:
        return self._files

    @property
    def cycles(self) -> int:
        return self._cycles


class Patcher(ABC):
    """Worker class for performing post-place and route circuit modifications."""
    def patch(self, par_file: Path, plbs: List, cfg_name: str, work_dir: Path) -> Path:
        """Implementation method for the class.

        Args:
            `par_file`: Path to the placed-and-routed circuit file.\
            `plbs`: List of locations of the UUT PLBs in the circuit.\
            `cfg_name`: Name of the test configuration.\
            `work_dir`: Working directory to place any work files."""
        ...


class PLBTestSpecification(TestSpecification):
    """Specification for a PLB test configuration."""
    builder = _PLBBuilder

    @classmethod
    def version(cls) -> Version:
        """Version of the specification."""
        return Version(2, 0)

    @classmethod
    @abstractmethod
    def get_regions(cls, region, device_info, spacing) -> Sequence[Collection[Resource]]:
        """Partitions the device and returns the resources in the device to test
        in each partition."""
        ...

    @property
    @abstractmethod
    def vendor(self) -> PLBVendor:
        """The interface to the vendor CAD tools."""

    @property
    @abstractmethod
    def constraints_generator(self) -> ConstraintsGenerator:
        """Object which generates the placement constraints for the resources in the test."""
        ...

    @property
    @abstractmethod
    def description(self) -> str:
        """Description of the test configuration."""
        ...

    def test_time(self, *, uuts, period_in_ns, **args) -> float:
        """Time in seconds of how long to wait between programming the test and reading the result."""
        cycles = self.tpg.cycles + len(uuts)  # 1 cycle per uut
        in_ns = cycles * float(period_in_ns)
        # convert to ms, take the ceiling and add 1 for safety
        in_ms = ceil(in_ns / 1000000) + 1
        return in_ms / 1000  # return in seconds

    @property
    def patcher(self) -> Optional[Patcher]:
        """The tool for patching the placed and routed netlist.  If None, no patching will
        happen."""
        return None

    @property
    @abstractmethod
    def uut_configurations(self) -> PLBConfiguration:
        ...

    # Configuration specific HDL files
    @property
    @abstractmethod
    def tpg(self) -> TPG:
        ...

    @property
    def clk_edge(self) -> str:
        """Determines the clock edge that should be used throughout the test.  

        The value is written to the constants package.  Options are 'RISING' and 'FALLING'."""
        return 'RISING'

    @property
    def other_constants(self) -> List[VhdlConstant]:
        """Method to allow subclasses to define additional constants to add the the constants package."""
        return []


def build_test(test_name, args: _Arguments, build_dir, results_dir):
    ts = args.specification

    # Gather the files
    constants_file = constants_pkg_file(ts, args.sites, build_dir)
    plb_files = ts.uut_configurations.files(build_dir)
    test_region_file = generate_layout(args.sites, ts, build_dir)
    harness_files = harness_hdl_files(ts, test_region_file, args.capture_file)

    # Validate simulation prior to testing
    if args.simulate:
        sim_plb_files = []
        sim_plb_files.append(constants_file)
        sim_plb_files.extend(plb_files.simulation)
        sim_plb_files.extend(plb_files.gold)
        sim_plb_files.extend(harness_files)
        sim_successful = simulate_design(_SimulationArguments(sim_plb_files, "'1'"), build_dir)
        if not sim_successful:
            raise SimulationError

    # Gather the PLB files
    comp_plb_files = [PLBEntity(t, [constants_file, *f]) for t, f in plb_files.compilation]
    comp_harness_files = [constants_file, *plb_files.gold, *harness_files, *args.io_files]

    harness_netlist = ts.vendor.place_and_route(args.part, comp_plb_files, comp_harness_files, build_dir)

    # Implement patches if the patcher is specified
    if ts.patcher:
        patched_netlist = ts.patcher.patch(harness_netlist, args.sites, test_name, build_dir)
    else:
        patched_netlist = harness_netlist

    bitstream = ts.vendor.make_bitstream(patched_netlist, build_dir)

    # Move the bitstream from the work directory to the results directory
    final_bitstream = results_dir/f'{test_name}.bit'
    shutil.move(os.fspath(bitstream), os.fspath(final_bitstream))

    return final_bitstream


def harness_hdl_files(ts, test_region_file, capture) -> Sequence[HdlFile]:
    """All IO agnostic files except plb files."""
    hdl = []
    hdl.extend(ts.tpg.files)
    hdl.append(HdlFile(_hdl_dir / 'checker.vhd', 'vhdl', 'work'))
    hdl.append(test_region_file)
    hdl.append(capture)
    hdl.append(HdlFile(_hdl_dir / 'harness.vhd', 'vhdl', 'work'))
    return hdl


def constants_pkg_file(ts, uuts, work_dir):
    """Package containing test constants.  Not for the user to define."""
    fpath = work_dir/'constants_pkg.vhd'
    with open(fpath, 'w') as f:
        fprint = partial(print, file=f)
        fprint('library ieee;')
        fprint('use ieee.std_logic_1164.all;')
        fprint('use ieee.numeric_std.all;')
        fprint('package TEST_CONSTANTS_PKG is')
        fprint(f'  type integer_vector is array (integer range <>) of integer;')
        fprint(f'  type signed64_vector is array (integer range <>) of signed(63 downto 0);')
        fprint(f'  constant RESOURCE_COUNT_BITS: positive := {len(uuts).bit_length()};')
        fprint(f'  constant CLK_EDGE: string := "{ts.clk_edge}";')
        fprint(f'  constant PLB_INPUTS: positive := {ts.tpg.num_inputs};')
        fprint(f'  constant PLB_OUTPUTS: positive := {ts.uut_configurations.num_outputs};')
        # Xilinx has issues if this is empty ranges so force this to at least one bit
        fprint(f'  constant PLB_CARRIES: natural := {max(ts.uut_configurations.num_carries, 1)};')
        for name, type, value in map(dc.astuple, ts.other_constants):
            fprint(f'  constant {name}: {type} := {value};')
        for name, type, value in map(dc.astuple, ts.tpg.package_constants):
            fprint(f'  constant {name}: {type} := {value};')
        fprint('end package TEST_CONSTANTS_PKG;')

    return HdlFile(fpath, 'vhdl', 'work')


def generate_layout(uuts, ts: PLBTestSpecification, work_dir):
    """Lays out all of the slices to test with."""
    fpath = work_dir/'test_gen.vhd'
    with open(fpath, 'w') as f:
        fprint = partial(print, file=f)
        fprint('library ieee;')
        fprint('use ieee.std_logic_1164.all;')
        fprint('use work.TEST_CONSTANTS_PKG.all;')
        fprint()
        fprint('entity test_region is')
        fprint('  port (')
        fprint('    clk: in std_logic;')
        fprint('    reset: in std_logic;')
        fprint('    inputs: in std_logic_vector(PLB_INPUTS-1 downto 0);')
        fprint('    error: out std_logic;')
        fprint('    check: in std_logic;')
        fprint('    latch: in std_logic;')
        fprint('    done_in: in std_logic;')
        fprint('    done_out: out std_logic;')
        fprint('    propagate: in std_logic')
        fprint('  );')
        fprint('end entity test_region;')
        fprint()
        fprint('architecture structural of test_region is')
        fprint(f'  type plb_output_array is array (integer range <>) of std_logic_vector(PLB_OUTPUTS-1 downto 0);')
        fprint(f'  type plb_carry_array is array (integer range <>) of std_logic_vector(PLB_CARRIES-1 downto 0);')
        fprint()
        fprint(f'  signal outputs: plb_output_array(0 to {len(uuts) - 1});')
        fprint(f'  signal carries: plb_carry_array(0 to {len(uuts)});')
        fprint('  signal expected: std_logic_vector(PLB_OUTPUTS-1 downto 0);')
        fprint(f'  signal error_vector: std_logic_vector(0 to {len(uuts)});')
        fprint(f'  signal done: std_logic_vector(0 to {len(uuts)});')
        fprint()
        fprint('  component gold is')
        fprint('    port (')
        fprint('      clk: in std_logic;')
        fprint('      I: in std_logic_vector(PLB_INPUTS-1 downto 0);')
        fprint('      O: out std_logic_vector(PLB_OUTPUTS-1 downto 0)')
        fprint('    );')
        fprint('  end component gold;')

        # Declare all of the UUT types
        for t in ts.uut_configurations.uut_types:
            fprint()
            fprint(f'  component {t} is')
            fprint('  port (')
            fprint('    clk: in std_logic;')
            fprint('    I: in std_logic_vector(PLB_INPUTS-1 downto 0);')
            fprint('    O: out std_logic_vector(PLB_OUTPUTS-1 downto 0);')
            fprint('    P: in std_logic_vector(PLB_CARRIES-1 downto 0);')
            fprint('    N: out std_logic_vector(PLB_CARRIES-1 downto 0)')
            fprint('  );')
            fprint('  end component;')
        fprint('')

        # Use the vendor to create placement constraints in the file
        # Only do this if the loc_attribute is declared
        cg = ts.constraints_generator
        if cg.loc_attribute:
            fprint(cg.loc_attribute)
            for site in uuts:
                fprint(cg.loc_constraint(f'{site.where}', site.where))

        fprint()
        fprint('begin')
        fprint("  error_vector(0) <= '0';")
        fprint("  done(0) <= done_in;")

        # Instntiate the gold module
        fprint(f'  gold_i: gold', end='')
        fprint(f' port map (clk => clk, I => inputs, O => expected);')

        # Instantiate each of the UUTs and ORAs
        for i, uut in enumerate(uuts):
            fprint(f'  {uut.where}: {ts.uut_configurations.entity_type((uut, i), uuts)}', end='')
            fprint(f' port map (clk => clk, I => inputs, O => outputs({i}), P => carries({i}), N => carries({i+1}));')
            fprint(f'  {uut.where}_check: entity work.checker generic map(WIDTH => PLB_OUTPUTS)', end='')
            fprint(f' port map (clk => clk, reset => reset, error_in => error_vector({i}),', end='')
            fprint(f' check => check, propagate => propagate, latch => latch,', end='')
            fprint(f' done_in => done({i}), done_out => done({i+1}),', end='')
            fprint(f' expected => expected, actual => outputs({i}), error_out => error_vector({i+1}));')

        fprint()
        fprint(f'  error <= error_vector({len(uuts)});')
        fprint(f'  done_out <= done({len(uuts)});')
        fprint('end architecture structural;')

    return HdlFile(fpath, 'vhdl', 'work')


def simulate_design(sim, work_dir):
    simulator = Simulator(work_dir)
    hdls = list(sim.hdl_files)
    hdls.append(HdlFile(_debug_dir/'testbench.vhd', 'vhdl', 'work'))
    try:
        result = simulator.simulate(hdls, 'testbench', sim.expected_result)
        if result:
            LOG.info('Simulation passed')
        else:
            LOG.error('Simulation failed')
            return False
    except:
        LOG.exception('Error occurred while simulating')
        return False
    return True


@dc.dataclass(frozen=True)
class CCRegion:
    """A pair of slices forming a carry chain of some sort.  

    The objects are used in some tests to indicate the locations of the carry chains."""
    lower: Resource
    """Resource starting the carry chain."""

    upper: Resource
    """Resource ending the carry chain."""

    @property
    def where(self):
        return self.lower
