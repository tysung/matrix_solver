#
#  /usr/bin/env python3.7
#
# after pip install the cift.cli package
# retrieved the plugins to be enable
# cift-internal/code/main/python/cift/internal/plugins.py
#

from cift.cli.plugins import *
for plugin in get_plugins:
    enable_plugin(plugin)
#
family = 'kintex7'
vendor = 'xilinx-ise'
part = 'xc7k70tfbg484-3'
name = f'all-brams-{part}'
region = None  # 'RAMB_X0Y0:RAMB_X5Y9'
io_interface = 'interfaces/bscan_series7/io_wrapper_50MHz.vhd,interfaces/bscan_series7/io_wrapper.ucf'
description = f'All BRAMs on the {part}.'
parallel_jobs = 1
#
from cift.cli.build import *
#
#tg = BuildConfiguration(name, vendor, family, part, description)
#tg.tests.append(cfg('init-0', io=io_interface, region=region))
#tg.tests.append(cfg('init-1', io=io_interface, region=region))
#tg.tests.append(cfg('marchlr_32kx1_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchb_32kx1_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_16kx2_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_8kx4_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_4kx9_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_2kx18_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_1kx36_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchs2pf_32kx1', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_cascade_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_16kx1_dp', io=io_interface, region=region))
#tg.tests.append(cfg('marchx_1kx18_dp', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_18k_4kx4', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_18k_2kx9', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_18k_1kx18', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_18k_512x36', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_36k_8kx4', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_36k_4kx9', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_36k_2kx18', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_36k_1kx36', io=io_interface, region=region))
#tg.tests.append(cfg('fifo_36k_512x72', io=io_interface, region=region))
#build_configuration(tg, preserve=False, jobs=parallel_jobs, force=False)
#save_configuration(tg, 'testgroups/series7/build-tests-brams.ift-tgc', True)

