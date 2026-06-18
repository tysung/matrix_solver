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
description = f'All slices on the {part}.'
parallel_jobs = 16 
region =  'SLICE_X0Y0:SLICE_X79Y119'

load_builder_repo()

mytg = tg.create(f'4qr-{part}', family, part, description)
#
region =  'SLICE_X0Y0:SLICE_X79Y119'
tg.add(mytg, 'luts1', io=io_interface, spacing=(4,1), region=region)
#tg.build(mytg, preserve=True, jobs=parallel_jobs, force=True)

region =  'SLICE_X80Y0:SLICE_X159Y119'
#mytg = tg.create(f'br-{part}', family, part, description)
tg.add(mytg, 'luts1', io=io_interface, spacing=(4,1), region=region)
#tg.build(mytg, preserve=True, jobs=parallel_jobs, force=True)

region =  'SLICE_X0Y120:SLICE_X79Y239'
#mytg = tg.create(f'tl`-{part}', family, part, description)
tg.add(mytg, 'luts1', io=io_interface, spacing=(4,1), region=region)
#tg.build(mytg, preserve=True, jobs=parallel_jobs, force=True)

#region =  'SLICE_X8Y12:SLICE_X9Y24'
region =  'SLICE_X80Y120:SLICE_X159Y239'
#mytg = tg.create(f'tr-{part}', family, part, description)
tg.add(mytg, 'luts1', io=io_interface, spacing=(4,1), region=region)
#
#
tg.build(mytg, preserve=True, jobs=parallel_jobs, force=True)
# tg.write(mytg, 'build-tests-virtex6-slices.ift-tgc', overwrite=True)

