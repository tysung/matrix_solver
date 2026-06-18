
batch = 'v4-0'
interface = '/ift/ift/interfaces/bscanv4/v4_interface.py'

load_test_repo()
suite = ts.create()
#ts.add(suite, 'harness-xc2vp50ff1152-7')
#ts.add(suite, 'configuration-memory-xc2vp50ff1152-7')
#ts.add(suite, 'all-slices-xc4vlx60ff668-10')
#ts.add(suite, 'all-brams-xc2vp50ff1152-7')
#ts.add(suite, 'interconnect-xc2vp50ff1152-7')
ts.add(suite,' interconnect-xc5vlx110tff1136-1')
ts.run(suite, batch, hw_int=interface, description='V4.')
