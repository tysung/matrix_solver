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

from cift.global_configs import CIFT_DEFAULT_WORKSPACE, CIFT_INSTALL_ROOT
from cift.hardware import HardwareBridge
from cift.cli.test import *


family = 'spartan7'
part = 'xc7s25csga324-1'

def open_project():
    # Create a new project
    #name = f'skoll-k7-example'
    #prj_directory = CIFT_DEFAULT_WORKSPACE / 'projects' / f'{name}'
    #prj = create_project(name, family, part, prj_directory)

    # Or use an existing project
    # prj_file = CIFT_DEFAULT_WORKSPACE / 'projects' / 'skoll-k7-example'
    prj_file = '/nas/projects/cift/tysung/TEST_Q7/cift-internal/sp7_test/project.ift'
    prj = load_project(prj_file)

    return prj

def open_test_suite():
    # Create the test
    test_suite = make_test_suite()

    # And save it if you'd like
    # test_suite_file = CIFT_DEFAULT_WORKSPACE / f'{part}-all.ift-ts'
    # write_test_suite(test_suite, test_suite_file, True)

    # Or use an existing test suite
    # test_suite_file = CIFT_DEFAULT_WORKSPACE / f'{part}-all.ift-ts'
    # test_suite = load_test_suite(test_suite_file)

    return test_suite

def select_hardware():
    # Select the hardware and interface
    hw_bridge = f'{CIFT_INSTALL_ROOT}/interfaces/ise_bscan.py'
    #hw_bridge = f'{CIFT_INSTALL_ROOT}/interfaces/vivado_hw_interface.py'
    #board_config = f'{CIFT_INSTALL_ROOT}/interfaces/bscan_spartan7/artys7.ift-bc'
    board_config = f'{CIFT_INSTALL_ROOT}/interfaces/bscan_series7/artys7.ift-bc'
    return HardwareBridge(Path(hw_bridge), [board_config])


def make_test_suite():
    test_suite = []

    def tp(test_name):
        return test_package([family, part, test_name])

    # harness test
    test_suite.append(tp('harness-iopin'))

    # configuration memory
    #test_suite.append(tp('configuration-memory'))

    # CLBs
    #test_suite.append(tp('slice-luts1'))
    #test_suite.append(tp('slice-luts2'))
    #test_suite.append(tp('slice-mux1'))
    #test_suite.append(tp('slice-mux2'))
    #test_suite.append(tp('slice-mux3'))
    #test_suite.append(tp('slice-mux4'))
    #test_suite.append(tp('slice-cyinit0'))
    #test_suite.append(tp('slice-vcarry'))
    #test_suite.append(tp('slice-regtest1'))
    #test_suite.append(tp('slice-regtest2'))
    #test_suite.append(tp('slice-ram32'))
    #test_suite.append(tp('slice-ram64'))
    #test_suite.append(tp('slice-ram128'))
    #test_suite.append(tp('slice-ram256'))
    #test_suite.append(tp('slice-srl16'))
    #test_suite.append(tp('slice-srl32'))

    # brams
    #test_suite.append(tp('bram-init-0'))
    #test_suite.append(tp('bram-init-1'))
    #test_suite.append(tp('bram-marchlr_32kx1_dp'))
    #test_suite.append(tp('bram-marchb_32kx1_dp'))
    #test_suite.append(tp('bram-marchx_16kx2_dp'))
    #test_suite.append(tp('bram-marchx_8kx4_dp'))
    #test_suite.append(tp('bram-marchx_4kx9_dp'))
    #test_suite.append(tp('bram-marchx_2kx18_dp'))
    #test_suite.append(tp('bram-marchx_1kx36_dp'))
    #test_suite.append(tp('bram-marchs2pf_32kx1'))
    #test_suite.append(tp('bram-marchx_cascade_dp'))
    #test_suite.append(tp('bram-marchx_16kx1_dp'))
    #test_suite.append(tp('bram-marchx_1kx18_dp'))
    #test_suite.append(tp('bram-fifo_18k_4kx4'))
    #test_suite.append(tp('bram-fifo_18k_2kx9'))
    #test_suite.append(tp('bram-fifo_18k_1kx18'))
    #test_suite.append(tp('bram-fifo_18k_512x36'))
    #test_suite.append(tp('bram-fifo_36k_8kx4'))
    #test_suite.append(tp('bram-fifo_36k_4kx9'))
    #test_suite.append(tp('bram-fifo_36k_2kx18'))
    #test_suite.append(tp('bram-fifo_36k_1kx36'))
    #test_suite.append(tp('bram-fifo_36k_512x72'))

    # interconnect
    #test_suite.append(tp('interconnect'))

    return test_suite

def main():
    prj = open_project()
    ts = open_test_suite()
    bridge = select_hardware()
    # Runs the tests
    execute_tests(prj, bridge, ts)


if __name__ == '__main__':
    main()

