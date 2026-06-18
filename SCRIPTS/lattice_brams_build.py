# Copyright University of Southern California 2019-2021
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

from pathlib import Path

CIFT_INSTALL_ROOT = '/nas/home/tsung/CODE/cift-internal_feb2024'

group_prefix = None

vendor = 'lattice-diamond'
#family = 'ecp5u'
#part = 'LFE5U-45F-6BG381C'

family = 'ecp5um5g'
part = 'LFE5UM5G-85F-8BG381C'
# region = 'EBR_R22C4:EBR_R22C8'
region = None  # 'EBR_R22C4:EBR_R22C8'
io_interface = \
    f'{CIFT_INSTALL_ROOT}/interfaces/lattice/ecp5/jtag/eval-5g/io_wrapper_20MHz.vhd,' \
    f'{CIFT_INSTALL_ROOT}/interfaces/lattice/ecp5/jtag/eval-5g/io_wrapper_20MHz.lpf,' \
    f'{CIFT_INSTALL_ROOT}/interfaces/lattice/ecp5/jtag/eval-5g/io_wrapper_20MHz.ldc'

parallel_jobs = 1
preserve_build_files = True
other_args = {'simulate': False, 'test_mode': False}


###################################################################################

from cift.cli.build import *
from cift.cli.build import cfg
import cift
cift.LOGGING_LEVEL = 'DEBUG'
from cift import GlobalSettings
GlobalSettings['torc', 'TORC_INSTALL'] = Path('/opt/torc/lattice')

tg = BuildGroup(vendor, family, part)
def add_test(config, **o_args):
    global tg

    def make_name():
        gid = f'{group_prefix}-' if group_prefix else ''
        return f'{gid}bram-{config}'

    def desc():
        reg = 'Full Device' if region is None else region
        return f'''region: {reg}\nio interface: {io_interface}\n'''

    tg.tests.append(cfg(make_name(), desc(), config, io=io_interface, region=region, **other_args, **o_args))

add_test('marchx_16kx1_dp')
#add_test('marchx_8kx2_dp')
#add_test('marchx_4kx4_dp')
#add_test('marchx_2kx9_dp')
#add_test('marchx_1kx18_dp')
#add_test('marchb_2kx9_dp')
#add_test('marchlr_2kx9_dp')
#add_test('marchs2pf_2kx9_dp')
#add_test('init-0')
#add_test('init-1')

# export_build_group(tg, '{CIFT_INSTALL_ROOT}/testgroups/series7/build-tests-harness.ift-tgc', True)
build_tests(tg, preserve=preserve_build_files, jobs=parallel_jobs, force=True)

