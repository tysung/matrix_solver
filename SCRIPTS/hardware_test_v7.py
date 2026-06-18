# This script will run a set of CIFT tests on hardware.
# Fill in the below information and run this script directly


# **************  Fill in this information ******************
from ift.testlog import _TestRecordBuilder, _ComponentRecordBuilder

TEST_REPO = 'RESULT'  # Path to the test repository
run_id = 'board-test'  # Some identifier for the part your testing
hw_bridge = 'interfaces/ise_bscan.py'
board_cfg = 'interfaces/bscan_series7/skoll-k7.ift-bc'
description = 'description of the hardware'
# the test group to run on hardware, found in the test repository
test_groups = [
    'series7/brams/all-brams-xc7k70tfbg484-3.ift-tg',
    'series7/configmem/configuration-memory-xc7k70tfbg484-3.ift-tg',
    'series7/harness/harness-xc7k70tfbg484-3.ift-tg',
    'series7/interconnect/interconnect-xc7k70tfbg484-3.ift-tg',
    'series7/slices/all-slices-xc7k70tfbg484-3.ift-tg'
]


# **************  Don't touch this ******************

import logging
import subprocess 
from pathlib import Path
from ift.application.run import TestSuiteConfiguration, execute_test_suite, TestExecCallback
from ift.tests import TestGroupPackageFile


class CLITestExecCallback(TestExecCallback):
    def __init__(self):
        self.runner_file = None

    def initialization_error(self, exception):
        logging.getLogger('ift.cli').exception('Error during initialization')

    def suite_done(self, suite_results):
        def count_failed(r):
            if type(r) is list:
                return sum(count_failed(it) for it in r)
            try:
                return sum(count_failed(it) for it in r.components)
            except AttributeError:
                return 1 if not r else 0

        fail_count = count_failed(suite_results)
        if fail_count > 0:
            logging.getLogger('ift.cli').info(f'Done: {fail_count} tests failed')
        else:
            logging.getLogger('ift.cli').info('Done: All tests passed')

    def group_started(self, num, test_group):
        logging.getLogger('ift.cli').info(f'Beginning group {num}: {test_group.name}')

    def test_started(self, num, test_info_file):
        logging.getLogger('ift.cli').info(f'Beginning test {num}: {test_info_file.name}')

    def component_started(self, num: int, component):
        self.runner_file = component.runner
        logging.getLogger('ift.cli').info(f'Testing component {num}')

    def component_done(self, status):
        if status.result:
            logging.getLogger('ift.cli').info('Passed')
        else:
            logging.getLogger('ift.cli').warning(f'Failed, {self.runner_file}')
        self.runner_file = None

    def component_error(self, exception):
        logging.getLogger('ift.cli').exception('exception occurred while running test')

    def write_error(self, exception):
        logging.getLogger('ift.cli').exception('exception occurred while writing results')


TEST_REPO = Path(TEST_REPO)
for x in range(1):
    print(f'\nHarware Iternation TEST: iteration {x} \n') 
    #subprocess.run(['sleep', '3'])
    suite = TestSuiteConfiguration()
    for tg in test_groups:
        suite.test_groups.append(TestGroupPackageFile(TEST_REPO/tg))
    suite = suite.to_test_suite()
    args = [board_cfg]
    execute_test_suite(run_id, suite, Path(hw_bridge), description, args, CLITestExecCallback())
    #subprocess.run(['sleep', '57'])


