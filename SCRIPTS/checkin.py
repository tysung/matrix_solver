#
#
family = 'kintex7'
part = 'xc7k70tfbg484-3'
region = None #'RAMB_X0Y0:RAMB_X5Y9'
io_interface = 'interfaces/startupe2_interface/io_wrapper_50MHz.vhd,interfaces/startupe2_interface/io_wrapper.ucf'
description = f'All BRAMs on the {part}.'
parallel_jobs = 8

load_builder_repo()
mytg = tg.create(f'all-brams-{part}', family, part, description)
tg.add(mytg, 'fifo_18k_1kx18', io=io_interface,  region=region, test_mode=True )
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)
#
#
family = 'virtex2p'
part = 'xc2vp50ff1152-7'
region = 'R10C10:R14C14'
io_interface = 'interfaces/bscanv2p/io_wrapper_20MHz.vhd,interfaces/bscanv2p/io_wrapper.ucf'
description = f'All slices on the {part}.'
parallel_jobs = 8

mytg = tg.create(f'all-slices-{part}', family, part, description)
tg.add(mytg, 'srl128', io=io_interface,  region=region, test_mode=True )
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)
#
#
family = 'virtex4'
part = 'xc4vlx60ff668-10'
io_interface = 'interfaces/bscanv4/io_wrapper_20MHz.vhd,interfaces/bscanv4/virtex4_avnet.ucf'
description = f'Test harness validation for the {part}.'
parallel_jobs = 8
mytg = tg.create(f'harness-{part}', family, part, description)
tg.add(mytg, 'iopin', io=io_interface)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)
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

family = 'virtex6'
part = 'xc6vlx240tff1156-1'
io_interface = 'interfaces/bscanv6/io_wrapper_20MHz.vhd,interfaces/bscanv6/io_wrapper.ucf'
parallel_jobs = 8
description = f'Basic configuration memory test on the {part}.'

load_builder_repo()
mytg = tg.create(f'configuration-memory-{part}', family, part, description)
tg.add(mytg, 'configuration-memory', io=io_interface)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)
# tg.write(mytg, 'build-tests-virtex6-configmem.ift-tgc', overwrite=True)
