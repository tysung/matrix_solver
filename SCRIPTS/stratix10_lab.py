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
import logging

import cift

group_prefix = None

family = 'stratix 10'
vendor = 'intel-qprime'
part = '1SG280LU2F50E2VG'
# part = '1SG040HH1F35E1VG'
region = None
# region = 'LAB_X46_Y40:LAB_X52_Y41'
io_interface = [
    '{CIFT_INSTALL_ROOT}/interfaces/intel/stratix10/vjtag/stratix10gx-iowrapper-50MHz.vhd',
    '{CIFT_INSTALL_ROOT}/interfaces/intel/stratix10/vjtag/stratix10gx.sdc',
    '{CIFT_INSTALL_ROOT}/interfaces/intel/stratix10/vjtag/stratix10gx.qsf',
    # '{CIFT_INSTALL_ROOT}/interfaces/intel/stratix10/vjtag/s10gx400.sdc',
    # '{CIFT_INSTALL_ROOT}/interfaces/intel/stratix10/vjtag/s10gx400.qsf'
]
parallel_jobs = 6 
preserve_build_files = True
other_args = {}
# other_args = {'simulate': True, 'test_mode': True}


###################################################################################

from cift.cli.build import *
from cift.cli.build import cfg

cift.set_logging_level(logging.DEBUG)

io_interface = ','.join(io_interface)
tg = BuildGroup(vendor, family, part)
def add_test(config, **o_args):
    global tg

    def make_name():
        gid = f'{group_prefix}-' if group_prefix else ''
        return f'{gid}slice-{config}'

    def desc():
        reg = 'Full Device' if region is None else region
        return f'''region: {reg}\nio interface: {io_interface}\n'''

    args = {'io': io_interface, 'region': region, 'spacing': (1, 1)}
    args.update(other_args)
    args.update(o_args)
    tg.tests.append(cfg(make_name(), desc(), config, **args))


#add_test('lut6_xor')
#add_test('lut6_xnor')
#add_test('lut5s')
#add_test('ff')
#add_test('feedback')
#add_test('mlab')
#add_test('adders1')
#add_test('adders2')
#add_test('adders3')
#add_test('vcarry', region=
add_test('ff', spacing=(2, 1), region=\
    'LAB_X2_Y1:LAB_X36_Y36;'
    'LAB_X37_Y37:LAB_X52_Y72;'
    'LAB_X53_Y73:LAB_X86_Y108'
)

#    'LAB_X37_Y1:LAB_X52_Y36,'
#    'LAB_X53_Y1:LAB_X86_Y36,'
#    'LAB_X2_Y37:LAB_X36_Y72,'
#    'LAB_X53_Y37:LAB_X86_Y72,'
#    'LAB_X2_Y73:LAB_X36_Y108,'
#    'LAB_X37_Y73:LAB_X52_Y108,'

# export_build_group(tg, 'build-tests-brams.ift-tgc', True)
build_tests(tg, preserve=preserve_build_files, jobs=parallel_jobs, force=True)

if __name__ == '__main__':
    pass
