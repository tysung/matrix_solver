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

from parameterized import parameterized

from cift.cli.build import *
from cift.cli.build import cfg

group_prefix = None
directory = Path(__file__).parent.absolute()

family = 'stratix 10'
vendor = 'intel-qprime'
#part = '1SG040HH1F35E1VG'
part = '1SG280LU2F50E2VG'
region = 'M20K_X20_Y1:M20K_X30_Y3'
#region='LAB_X32_Y10:LAB_X38_Y19'
io_interface = f'{directory}/interfaces/intel/stratix10/vjtag/stratix10gx-iowrapper-50MHz.vhd,' \
               f'{directory}/interfaces/intel/stratix10/vjtag/stratix10gx.sdc,' \
               f'{directory}/test/builds/short/intel/stratix10gx.qsf'

#               f'{directory}/stratix10gx.qsf'

parallel_jobs = 4 
preserve_build_files = True 
other_args = {'test_mode': True}
#other_args = {'simulate': True, 'test_mode': True}

###################################################################################


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


add_test('marchx_2kx10_qdp')
#add_test('marchx_2kx10_sdp')
#add_test('marchx_512x40_sdp')
#add_test('marchs2pf_2kx10_tdp')
#add_test('marchlr_2kx10_tdp')
#add_test('marchb_2kx10_tdp')
#add_test('marchx_2kx10_tdp')
#add_test('marchx_1kx20_tdp')
#add_test('luts1')

# export_build_group(tg, 'build-tests-brams.ift-tgc', True)
build_tests(tg, preserve=preserve_build_files, jobs=parallel_jobs, force=True)

if __name__ == '__main__':
    pass
