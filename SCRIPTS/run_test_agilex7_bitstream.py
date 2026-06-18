# Script is automatically generated.

from pathlib import Path

family = 'Agilex 7'
part = 'agfb014r24b2e2v'

project_directory = Path('/nas/home/tsung/CODE/cift-travis/Agilex7_Bram')
project_name = Path('Agilex7_Bram')

load_test_suite_file = True
test_suite_file = Path('/nas/home/tsung/CODE/cift-travis/workspace/bitstream_test.ift-ts')  # not needed if load_test_suite_file = False

hw_bridge = Path('/nas/home/tsung/CODE/cift-travis/interfaces/intel/quartus_prime_vjtag.py')
hw_arguments = ['/nas/home/tsung/CODE/cift-travis/interfaces/intel/agilex7/agfb014r24b.ift-bc']

from cift.hardware import HardwareBridge
from cift.cli.test import *

def open_project():
    project_file = project_directory / 'project.ift'
    if project_file.exists():
        prj = load_project(project_file)
    else:
        prj = create_project(project_name, family, part, project_directory)
    return prj

def open_test_suite():
    if load_test_suite_file:
        test_suite = load_test_suite(test_suite_file)
    else:
        test_suite = make_test_suite()
    return test_suite

def make_test_suite():
    test_suite = []

    def tp(test_name):
        return test_package([family, part, test_name])

    test_suite.append(tp('bram-marchb_2kx10_tdp'))
    test_suite.append(tp('bram-marchx_512x40_sdp'))
    test_suite.append(tp('bram-marchx_1kx20_tdp'))
    test_suite.append(tp('bram-marchx_2kx10_tdp'))
    test_suite.append(tp('bram-marchx_2kx10_sdp'))
    test_suite.append(tp('bram-marchs2pf_2kx10_tdp'))
    test_suite.append(tp('bram-marchlr_2kx10_tdp'))
    test_suite.append(tp('bram-marchx_2kx10_qdp'))

    return test_suite

def select_hardware():
    return HardwareBridge(Path(hw_bridge), hw_arguments)

def main():
    prj = open_project()
    ts = open_test_suite()
    bridge = select_hardware()
    execute_tests(prj, bridge, ts)


if __name__ == '__main__':
    main()

