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
# Author: Ting-Yuan Sung
#

family = 'spartan6'
vendor = 'xilinx-ise'
part = 'xc6slx45csg484-3'
#part = 'xc6slx45tfgg484-3'
#region = None 
region =  'SLICE_X0Y0:SLICE_X5Y5'
io_interface = \
    'interfaces/bscan_spartan6/io_wrapper_50MHz.vhd,' \
    'interfaces/bscan_spartan6/io_wrapper.ucf'

parallel_jobs = 8

import os
from cift.cli.build import *
from cift.cli.build import cfg
from cift.settings import GlobalSettings

print(GlobalSettings["xilinx", "XILINX_ISE_ENV"])

#os.chdir('../..')

#tg = BuildGroup(vendor, family, part)
def add_test(config):
    global tg

    def make_name():
        return f'{part}-slice-{config}-region_area'

    def desc():
        reg = 'Full Device' if region is None else region
        return f'''region: {reg}\nio interface: {io_interface}\n'''

    tg.tests.append(cfg(make_name(), desc(), config, io=io_interface, region=region, test_mode=True))

#add_test('luts1')
#add_test('luts2')
#add_test('mux1')
#add_test('mux2')
#add_test('mux3')
#add_test('mux5')
#add_test('mux6')
#add_test('ff1')
#add_test('ff2')
#add_test('ff3')
#add_test('ff4')
#add_test('ff5')
#add_test('vcarry')
#add_test('regtest1')
#add_test('regtest2')
#add_test('ram32_0')
#add_test('ram32_1')
#add_test('ram64_0')
#add_test('ram64_1')
#add_test('ram128_0')
#add_test('ram128_1')
#add_test('ram256_0')
#add_test('ram256_1')
#add_test('srl16')
#add_test('srl32')

# export_build_group(tg, 'testgroups/series7/build-tests-slices.ift-tgc', True)
#build_tests(tg, preserve=True, jobs=parallel_jobs, force=True)

def add_bram_test(config):
    global tg

    def make_name():
        return f'{part}-bram-{config}-region_area'

    def desc():
        reg = 'Full Device' if region is None else region
        return f'''region: {reg}\nio interface: {io_interface}\n'''

    tg.tests.append(cfg(make_name(), desc(), config, io=io_interface, region=region, test_mode=True))

# BRAMs
region = None
#region16 = 'RAMB16_X0Y0:RAMB16_X3Y4'
#region8 = 'RAMB8_X0Y0:RAMB8_X3Y4'
#io_interface = 'interfaces/bscan_spartan6/io_wrapper_50MHz.vhd,interfaces/bscan_spartan6/io_wrapper.ucf'
description = f'All BRAMs on the {part}.'
#
tg = BuildGroup(vendor, family, part)
#
add_bram_test('marchx_cascade_dp')
add_bram_test('marchx_16kx1_dp')
add_bram_test('marchx_1kx18_dp')
add_bram_test('marchx_2kx9_dp')
add_bram_test('marchx_4kx4_dp')
add_bram_test('marchx_8kx2_dp')
add_bram_test('marchx_512x36_dp')
add_bram_test('marchb_16kx1_dp')
add_bram_test('marchlr_16kx1_dp')
add_bram_test('marchlr_8kx1_dp')
add_bram_test('marchs2pf_16kx1')
add_bram_test('init-0')
add_bram_test('init-1')
#
build_tests(tg, preserve=True, jobs=parallel_jobs, force=True)
#


# Interconnect
#
#region = None 
region = 'INT_X20Y20:INT_X23Y23'
pips_per_tile = 8 
io_interface = 'interfaces/startup_spartan6/io_wrapper_50MHz.vhd,interfaces/startup_spartan6/io_wrapper.ucf'
#io_interface = 'interfaces/bscan_spartan6/io_wrapper_50MHz.vhd,interfaces/bscan_spartan6/io_wrapper.ucf'
#description = f'All interconnect on the {part}.'
#
def add_intcnt_test(config):
    global tg

    def make_name():
        return f'{part}-intcnt-{config}-region_area'

    def desc():
        reg = 'Full Device' if region is None else region
        return f'''region: {reg}\nio interface: {io_interface}\n'''

    tg.tests.append(cfg(make_name(), desc(), config, io=io_interface, region=region, pips_per_tile=pips_per_tile, test_mode=True))
#
#
tg = BuildGroup(vendor, family, part)
#
#tg.add(mytg, 'interconnect', io=io_interface, pips_per_tile=pips_per_tile, region=region, test_mode=True)
add_intcnt_test('interconnect')
#
build_tests(tg, preserve=True, jobs=parallel_jobs, force=True)
#


