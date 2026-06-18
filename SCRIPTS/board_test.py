#
interface = '/import/home/tsung/CIFT_WEEK/week/cift-internal/interfaces/bscanv6/v6_interface.py'
load_test_repo()
#
description = 'V6_Slices'
batch = 'v6-iter'
suite = ts.create()
ts.add(suite, 'all-slices-xc6vlx240tff1156-1')
ts.run(suite, 'v6-iter-19', hw_int=interface, description=description)
#
