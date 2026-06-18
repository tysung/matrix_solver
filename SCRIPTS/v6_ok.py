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

load_builder_repo()

parallel_jobs = 16 
family = 'virtex6'
part = 'xc6vlx240tff1156-1'


# Configuration memory

io_interface = 'interfaces/bscanv6/io_wrapper_20MHz.vhd,interfaces/bscanv6/io_wrapper.ucf'
description = f'Basic configuration memory test on the {part}.'

mytg = tg.create(f'configuration-memory-{part}', family, part, description)
tg.add(mytg, 'configuration-memory', io=io_interface)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)


# Harness
io_interface = 'interfaces/bscanv6/io_wrapper_20MHz.vhd,interfaces/bscanv6/io_wrapper.ucf'
description = f'Test harness validation for the {part}.'

mytg = tg.create(f'harness-{part}', family, part, description)
tg.add(mytg, 'iopin', io=io_interface)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)


# BRAMs

region = None
io_interface = 'interfaces/bscanv6/io_wrapper_20MHz.vhd,interfaces/bscanv6/io_wrapper.ucf'
description = f'All BRAMs on the {part}.'

mytg = tg.create(f'all-brams-{part}', family, part, description)
tg.add(mytg, 'marchlr_32kx1_dp', io=io_interface, region=region)
tg.add(mytg, 'marchb_32kx1_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_16kx2_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_8kx4_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_4kx9_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_2kx18_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_1kx36_dp', io=io_interface, region=region)
tg.add(mytg, 'marchs2pf_32kx1', io=io_interface, region=region)
tg.add(mytg, 'marchx_cascade_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_16kx1_dp', io=io_interface, region=region)
tg.add(mytg, 'marchx_1kx18_dp', io=io_interface, region=region)
tg.add(mytg, 'fifo_18k_4kx4', io=io_interface, region=region)
tg.add(mytg, 'fifo_18k_2kx9', io=io_interface, region=region)
tg.add(mytg, 'fifo_18k_1kx18', io=io_interface, region=region)
tg.add(mytg, 'fifo_18k_512x36', io=io_interface, region=region)
tg.add(mytg, 'fifo_36k_8kx4', io=io_interface, region=region)
tg.add(mytg, 'fifo_36k_4kx9', io=io_interface, region=region)
tg.add(mytg, 'fifo_36k_2kx18', io=io_interface, region=region)
tg.add(mytg, 'fifo_36k_1kx36', io=io_interface, region=region)
tg.add(mytg, 'fifo_36k_512x72', io=io_interface, region=region)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)


# Slices

region = None
io_interface = 'interfaces/bscanv6/io_wrapper_20MHz.vhd,interfaces/bscanv6/io_wrapper.ucf'
description = f'All slices on the {part}.'

mytg = tg.create(f'all-slices-{part}', family, part, description)
tg.add(mytg, 'luts1', io=io_interface, region=region)
tg.add(mytg, 'luts2', io=io_interface, region=region)
tg.add(mytg, 'mux1', io=io_interface, region=region)
tg.add(mytg, 'mux2', io=io_interface, region=region)
tg.add(mytg, 'mux3', io=io_interface, region=region)
tg.add(mytg, 'mux4', io=io_interface, region=region)
tg.add(mytg, 'mux5', io=io_interface, region=region)
tg.add(mytg, 'mux6', io=io_interface, region=region)
tg.add(mytg, 'ff1', io=io_interface, region=region)
tg.add(mytg, 'ff2', io=io_interface, region=region)
tg.add(mytg, 'ff3', io=io_interface, region=region)
tg.add(mytg, 'ff4', io=io_interface, region=region)
tg.add(mytg, 'ff5', io=io_interface, region=region)
tg.add(mytg, 'vcarry', io=io_interface, region=region)
#tg.add(mytg, 'regtest1', io=io_interface, region=region)
#tg.add(mytg, 'regtest2', io=io_interface, region=region)
tg.add(mytg, 'ram32_0', io=io_interface, region=region)
tg.add(mytg, 'ram32_1', io=io_interface, region=region)
tg.add(mytg, 'ram64_0', io=io_interface, region=region)
tg.add(mytg, 'ram64_1', io=io_interface, region=region)
tg.add(mytg, 'ram128_0', io=io_interface, region=region)
tg.add(mytg, 'ram128_1', io=io_interface, region=region)
tg.add(mytg, 'ram256_0', io=io_interface, region=region)
tg.add(mytg, 'ram256_1', io=io_interface, region=region)
tg.add(mytg, 'srl16', io=io_interface, region=region)
tg.add(mytg, 'srl32', io=io_interface, region=region)
tg.build(mytg, preserve=False, jobs=parallel_jobs, force=False)

