#!/usr/bin/env python
import sys
import pprint
import ply.yacc as yacc
import re
import code
import subprocess

from lexer import tokens, log


Tile2Darr = []
NetArr = []
# add similar data like chipdb from ICESTORM
BEL = { 'primitive_def':{} }
indent_1t=1*2*' '
indent_2t=2*2*' '
indent_3t=3*2*' '
indent_4t=4*2*' '
def p_config(p):
    ''' config : device_sec pins_list gbufin_sec gbufpin_sec iolatch_sec ieren_sec colbuf_sec tiles_secs bits_secs extra_cell_list extra_bits_sec net_secs all_route_list '''
    line   = p.lineno(1)        # line number of the PLUS token
    index  = p.lexpos(1)        # Position of the PLUS token
    #p[0] = p[1]
    p[0] = { 'device':p[1], 'pins':p[2], 'gbufin':p[3], 'gbufpin':p[4], 'colbuf':p[7], 'tiles_secs':p[8], 'bits_secs':p[9], 'extra_cells':p[10], 'extra_bits':p[11], 'net_secs':NetArr, 'all_routes':p[13] }


def p_all_route_list(p):
    ''' all_route_list : all_route_secs
                     | all_route_list all_route_secs
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_all_route_secs(p):
    ''' all_route_secs : buffer_secs routing_secs
    '''
    p[0] = { 'buffers':p[1], 'routings':p[2] }


def p_buffer_secs(p):
    ''' buffer_secs : buffer_sec
                     | buffer_secs buffer_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_buffer_sec(p):
    ''' buffer_sec : BUFFER NUMBER NUMBER NUMBER config_bit_list src_net_list '''
    # we need post-process the syntax 10 -> "0010" for each individual src_net for config_bit
    # N = len(p[5])
    global Tile2Darr
    width = len(p[5])
    for src in p[6]:
        bits = src['src_net'][0]
        str_bits = str(bits)
        padded_bits = str_bits.zfill(width)
        src['src_net'][0] = padded_bits
    x_buffer = { 'X':p[2], 'Y':p[3], 'dest_net_id':p[4], 'config_bits':p[5], 'src_nets':p[6] }
    Tile2Darr[p[2]][p[3]]['buffer'] = Tile2Darr[p[2]][p[3]]['buffer'] + [x_buffer]
    p[0] = x_buffer
    #p[0] = { 'X':p[2], 'Y':p[3], 'dest_net_id':p[4], 'config_bits':p[5], 'src_nets':p[6] }


def p_routing_secs(p):
    ''' routing_secs : routing_sec
                     | routing_secs routing_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_routing_sec(p):
    ''' routing_sec : ROUTING NUMBER NUMBER NUMBER config_bit_list src_net_list '''
    # we need post-process the syntax 10 -> "0010" for each individual src_net for config_bit
    # N = len(p[5])
    global Tild2Darr
    width = len(p[5])
    for src in p[6]:
        bits = src['src_net'][0]
        str_bits = str(bits)
        padded_bits = str_bits.zfill(width)
        src['src_net'][0] = padded_bits
    x_routing = { 'X':p[2], 'Y':p[3], 'dest_net_id':p[4], 'config_bits':p[5], 'src_nets':p[6] }
    Tile2Darr[p[2]][p[3]]['routing'] = Tile2Darr[p[2]][p[3]]['routing'] + [x_routing]
    p[0] = x_routing
    #p[0] = { 'X':p[2], 'Y':p[3], 'dest_net_id':p[4], 'config_bits':p[5], 'src_nets':p[6] }


def p_src_net_list(p):
    ''' src_net_list : src_net_sec
                     | src_net_list src_net_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_src_net_sec(p):
    ''' src_net_sec : NUMBER NUMBER
    '''
    p[0] = { 'src_net': [p[1], p[2]] }


def p_extra_bits_sec(p):
    ''' extra_bits_sec : EXTRA_BITS extra_func_list
    '''
    p[0] = { 'extra_bits':p[2] }


def p_extra_func_list(p):
    ''' extra_func_list : extra_func_sec
                        | extra_func_list extra_func_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_extra_func_sec(p):
    ''' extra_func_sec : NAME DOT NUMBER NUMBER NUMBER NUMBER
    '''
    hier_name = p[1] + p[2] + str(p[3])
    p[0] = { 'function':hier_name, 'misc':[p[4],p[5],p[6]]  }

def p_extra_cell_list(p):
    ''' extra_cell_list : extra_cell_sec
                        | extra_cell_list extra_cell_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_extra_cell_sec(p):
    ''' extra_cell_sec : EXTRA_CELL NUMBER NUMBER NAME key_value_list
                       | EXTRA_CELL NUMBER NUMBER NAME LOCKED pkg_list key_value_list
                       | EXTRA_CELL NUMBER NUMBER NUMBER NAME key_value_list
    '''
    if len(p) == 6:
        p[0] = { 'X':p[2], 'Y':p[3], 'cell':p[4], 'key_value':p[5]  }
    elif len(p) == 7:
        p[0] = { 'X':p[2], 'Y':p[3], 'Z':p[4], 'cell':p[5], 'key_value':p[6]  }
    elif len(p) == 8:
        p[0] = { 'X':p[2], 'Y':p[3], 'cell':p[4], 'key_value':p[7], p[5]:p[6] }


def p_key_value_list(p):
    ''' key_value_list : key_value_sec
                        | key_value_list key_value_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_key_value_sec(p):
    ''' key_value_sec : NAME NUMBER NUMBER NAME
                      | NAME NUMBER NUMBER NUMBER
    '''
    p[0] = [ p[1], p[2], p[3], p[4] ]

def p_pkg_list(p):
    ''' pkg_list : pkg_list NAME
                 | NAME
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_bits_secs(p):
    ''' bits_secs : logic_tile_bit_sec  io_tile_bit_sec  ramb_tile_bit_sec ramt_tile_bit_sec dsp_tile_bit_list ipcon_tile_bit_sec
                  | logic_tile_bit_sec  io_tile_bit_sec  ramb_tile_bit_sec ramt_tile_bit_sec
                  | logic_tile_bit_sec  io_tile_bit_sec
    '''
    if len(p) == 3:
        p[0] = { 'logic_bits':p[1], 'io_bits':p[2] }
    elif len(p) == 5:
        p[0] = { 'logic_bits':p[1], 'io_bits':p[2], 'ramb_bits':p[3], 'ramt_bits':p[4] }
    else:
        p[0] = { 'logic_bits':p[1], 'io_bits':p[2], 'ramb_bits':p[3], 'ramt_bits':p[4], 'dsp_bits':p[5], 'ipcon_bits':p[6] }

def p_ipcon_tile_bit_sec(p):
    ''' ipcon_tile_bit_sec : IPCON_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4]  }


def p_dsp_tile_bit_list(p):
    ''' dsp_tile_bit_list : dsp_tile_bit_sec
                          | dsp_tile_bit_list dsp_tile_bit_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_dsp_tile_bit_sec(p):
    ''' dsp_tile_bit_sec : DSP_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4], 'dsp':p[1]  }


def p_ramb_tile_bit_sec(p):
    ''' ramb_tile_bit_sec : RAMB_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4]  }


def p_ramt_tile_bit_sec(p):
    ''' ramt_tile_bit_sec : RAMT_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4]  }


def p_io_tile_bit_sec(p):
    ''' io_tile_bit_sec : IO_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4]  }


def p_logic_tile_bit_sec(p):
    ''' logic_tile_bit_sec : LOGIC_TILE_BITS NUMBER NUMBER func_list  '''
    p[0] = { 'Column_num':p[2], 'Row_num':p[3], 'funcs':p[4]  }


def p_func_list(p):
    ''' func_list : config_bit
                  | func_list config_bit
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_config_bit(p):
    ''' config_bit : NAME config_bit_list
                   | NAME DOT NAME config_bit_list
    '''
    if len(p) == 3:
        #p[0] = [p[1]]
        p[0] = { 'function':p[1], 'config_bit':p[2]  }
    else:
        #p[0] = p[1] + [p[2]]
        hier_name = p[1] + p[2] + p[3]
        p[0] = { 'function':hier_name, 'config_bit':p[4]  }


def p_net_secs(p):
    ''' net_secs : net_sec
                 | net_secs net_sec
    '''
    #if len(p) == 2:
    #    p[0] = [p[1]]
    #else:
    #    p[0] = p[1] + [p[2]]

def p_net_sec(p):
    ''' net_sec : NET NUMBER in_subnet_3 '''
    global NetArr
    global Tile2Darr
    x_net_sec = { 'id':p[2], 'subnet_list':p[3] }
    NetArr[p[2]] = x_net_sec
    for subnet in p[3]:
        x = subnet['X']
        y = subnet['Y']
        name = subnet['subnet']
        Tile2Darr[x][y]['subnet'][name] = p[2]
    #p[0] = { 'id':p[2], 'subnet_list':p[3] }


def p_in_subnet_3(p):
    ''' in_subnet_3 : in_subnet_3 subnet_elem_3
                    | subnet_elem_3
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_subnet_elem_3(p):
    ''' subnet_elem_3 : NUMBER NUMBER NAME
    '''
    x_subnet = { 'X': p[1], 'Y': p[2], 'subnet':p[3] }
    Tile2Darr[p[1]][p[2]]['subnet'][p[3]] = x_subnet
    p[0] = x_subnet
    #p[0] = { 'X': p[1], 'Y': p[2], 'subnet':p[3] }


def p_config_bit_list(p):
    ''' config_bit_list : CONFIG_BIT
                        | config_bit_list CONFIG_BIT
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_tiles_secs(p):
    ''' tiles_secs : io_tile_list logic_tile_list ramb_tile_list ramt_tile_list dsp_tile_list ipcon_tile_list
                   | io_tile_list logic_tile_list ramb_tile_list ramt_tile_list
                   | io_tile_list logic_tile_list
    '''
    global Tile2Darr
    if len(p) >= 3:
        p[0] = { 'all_tiles':Tile2Darr }
    #else:
    #    p[0] = { 'io_tiles':p[1], 'all_tiles':p[2], 'ramb_tiles':p[3], 'ramt_tiles':p[4], 'dsp_tiles':p[5], 'ipcon_tiles':p[6] }


def p_ipcon_tile_list(p):
    ''' ipcon_tile_list : ipcon_tile_list ipcon_tile_sec
                       | ipcon_tile_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_ipcon_tile_sec(p):
    ''' ipcon_tile_sec : IPCON_TILE NUMBER NUMBER  '''
    p[0] = { 'X': p[2], 'Y': p[3] }


#    ''' device_sec : DEVICE FAMILY NUMBER NUMBER NUMBER'''
def p_device_sec(p):
    ''' device_sec : DEVICE FAMILY NUMBER NUMBER NUMBER
                   | DEVICE NUMBER NUMBER NUMBER NUMBER
    '''
    global Tile2Darr
    global NetArr
    global BEL
    #print(p.parser)
    #print(p.lexer)
    #line   = p.lineno(1)        # line number of the PLUS token
    #index  = p.lexpos(1)        # Position of the PLUS token
    X = p[3]
    Y = p[4]
    arr = [[{'subnet':{}, 'buffer':[], 'routing':[]} for j in range(Y)] for i in range(X)] # creates a 2D array of dictionaries

    Tile2Darr = arr
    arr1 = [{} for i in range(p[5])]
    NetArr = arr1
    p[0] = { 'name': p[2], 'X': p[3], 'Y': p[4], 'num_nets': p[5], 'Bel': BEL }
    #p[0] = { 'name': p[2], 'X': p[3], 'Y': p[4], 'num_nets': p[5], '2Darray':arr, 'NetArr':arr1 }


def p_ramb_tile_list(p):
    ''' ramb_tile_list : ramb_tile_list ramb_tile_sec
                       | ramb_tile_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_ramb_tile_sec(p):
    ''' ramb_tile_sec : RAMB_TILE NUMBER NUMBER  '''
    global Tile2Darr
    x_tile_sec = { 'X': p[2], 'Y': p[3] , 'type':'rambTile', 'subnet':{}, 'outbound':{}, 'buffer':[], 'routing':[]}
    Tile2Darr[p[2]][p[3]] = x_tile_sec


def p_ramt_tile_list(p):
    ''' ramt_tile_list : ramt_tile_list ramt_tile_sec
                    | ramt_tile_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_ramt_tile_sec(p):
    ''' ramt_tile_sec : RAMT_TILE NUMBER NUMBER  '''
    global Tile2Darr
    x_tile_sec = { 'X': p[2], 'Y': p[3] , 'type':'ramtTile', 'subnet':{}, 'outbound':{}, 'buffer':[], 'routing':[]}
    Tile2Darr[p[2]][p[3]] = x_tile_sec


def p_dsp_tile_list(p):
    ''' dsp_tile_list : dsp_tile_list dsp_tile_sec
                      | dsp_tile_sec
    '''

    #if len(p) == 2:
        #p[0] = [p[1]]
        #hash1 = {}
        #hash1[p[1]['dsp']] = [p[1]]
        #p[0] = hash1
    #else:
        #p[0] = p[1] + [p[2]]
        #hash1 = p[1]
        #if not p[2]['dsp'] in hash1:
        #    hash1[p[2]['dsp']] = []
        #list1 = hash1[p[2]['dsp']]
        #hash1[p[2]['dsp']] = [p[2]] + hash1[p[2]['dsp']]
        #p[0] = hash1

def p_dsp_tile_sec(p):
    ''' dsp_tile_sec : DSP_TILE NUMBER NUMBER  '''
    #p[0] = { 'dsp':p[1], 'X': p[2], 'Y': p[3] }
    global Tile2Darr
    x_tile_sec = { 'dsp':p[1], 'X': p[2], 'Y': p[3] , 'type':'ramtTile', 'subnet':{}, 'outbound':{}, 'buffer':[], 'routing':[]}
    Tile2Darr[p[2]][p[3]] = x_tile_sec

def p_logic_tile_list(p):
    ''' logic_tile_list : logic_tile_list logic_tile_sec
                        | logic_tile_sec
    '''
    #if len(p) == 2:
    #    p[0] = [p[1]]
    #else:
    #    p[0] = p[1] + [p[2]]

def p_logic_tile_sec(p):
    ''' logic_tile_sec : LOGIC_TILE NUMBER NUMBER  '''
    global Tile2Darr
    x_tile_sec = { 'X': p[2], 'Y': p[3] , 'type':'logicTile', 'subnet':{}, 'outbound':{}, 'buffer':[], 'routing':[]}
    Tile2Darr[p[2]][p[3]] = x_tile_sec
    #p[0] = x_tile_sec

def p_io_tile_list(p):
    ''' io_tile_list : io_tile_list io_tile_sec
                     | io_tile_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_io_tile_sec(p):
    ''' io_tile_sec : IO_TILE NUMBER NUMBER  '''
    x_tile_sec = { 'X': p[2], 'Y': p[3] , 'type':'ioTile', 'subnet':{}, 'outbound':{}, 'buffer':[], 'routing':[]}
    Tile2Darr[p[2]][p[3]] = x_tile_sec

def p_colbuf_sec(p):
    ''' colbuf_sec : COLBUF in_list_4  '''
    p[0] = { 'colbuf_list': p[2] }


def p_gbufpin_sec(p):
    ''' gbufpin_sec : GBUFPIN in_list_4  '''
    p[0] = { 'gbufpin_list': p[2] }


def p_iolatch_sec(p):
    ''' iolatch_sec : IOLATCH in_list_2  '''
    p[0] = { 'iolatch_list': p[2] }

def p_ieren_sec(p):
    ''' ieren_sec : IEREN in_list_6  '''
    p[0] = { 'ieren_list': p[2] }

def p_in_list_6(p):
    ''' in_list_6 : in_list_6 list_elem_6
                | list_elem_6
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_list_elem_6(p):
    ''' list_elem_6 : NUMBER NUMBER NUMBER NUMBER NUMBER NUMBER
    '''
    p[0] = { 'I1':p[1], 'I2':p[2], 'I3':p[3], 'I4':p[4], 'I5':p[5], 'I6':p[6]  }


def p_in_list_4(p):
    ''' in_list_4 : in_list_4 list_elem_4
                | list_elem_4
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_list_elem_4(p):
    ''' list_elem_4 : NUMBER NUMBER NUMBER NUMBER
    '''
    p[0] = { 'I_1': p[1], 'I_2': p[2], 'I_3': p[3], 'I_4': p[4] }


def p_in_list_2(p):
    ''' in_list_2 : in_list_2 list_elem_2
                | list_elem_2
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_list_elem_2(p):
    ''' list_elem_2 : NUMBER NUMBER
    '''
    p[0] = { 'I_1': p[1], 'I_2': p[2] }


def p_gbufin_sec(p):
    ''' gbufin_sec : GBUFIN gbufin_list  '''
    p[0] = { 'gbufin_list': p[2] }


def p_gbufin_list(p):
    ''' gbufin_list : gbufin_list gbufin 
                    | gbufin 
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_gbufin(p):
    ''' gbufin : NUMBER NUMBER NUMBER 
    '''
    p[0] = { 'X': p[1], 'Y': p[2], 'glb_num': p[3] }

def p_pins_list(p):
    ''' pins_list : pins_list pins_sec
                 | pins_sec
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]

def p_pins_sec(p):
    ''' pins_sec : PINS NAME pin_list  '''
    p[0] = { 'package': p[2], 'pin_list': p[3] }


def p_pin_list(p):
    ''' pin_list : pin_list pin 
                 | pin 
    '''
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_pin(p):
    ''' pin : NUMBER NUMBER NUMBER NUMBER 
            | NAME NUMBER NUMBER NUMBER 
    '''
    p[0] = { 'idx': p[1], 'X': p[2], 'Y': p[3], 'pio_num': p[4] }

def p_error(p):
    if p:
        print("User defined Syntax error at line {1} token {0}".format(p.value, p.lineno))
        # Just discard the token and tell the parser it's okay.
        #parser.errok()
    else:
        print("Uer defined Syntax error at EOF")


def enter_interactive_mode():
    interpreter = code.InteractiveInterpreter()
    while True:
        try:
            code = input(">>> ")
            if code.strip().lower() in ("exit()", "quit()"):
                break
            interpreter.runsource(code)
        except SystemExit:
            break

def process_extra_cells(db):
    global Tile2Darr
    global BEL

    for ec in db['extra_cells']:
        tile = Tile2Darr[ec['X']][ec['Y']]
        cell = ec['cell']
        key_value = ec['key_value']
        tile['extra_cell'] = ec

    tile_info = {'name':'TILE_IO', 'site_num': 2 }
    # need to add extra wire between 2 tile for PLL pinwire(i.e. fabout)
    for col in db['tiles_secs']['all_tiles']:
        for tile in col:
            if 'extra_cell' in tile and ('X' in tile and 'Y' in tile):
                add_bel_ec(tile, tile_info['site_num'])

def write_primitive_defs(db, o_file):
    global BEL
    def_num = len(BEL['primitive_def'])
    print('\n(primitive_defs {} '.format(def_num), file=o_file)
    #
    for site_name in BEL['primitive_def']:
        db['statistic']['sitedef_total'] += 1
        site_inst_1 = BEL['primitive_def'][site_name][0]
        pin_num = len(site_inst_1['input_ports']) + len(site_inst_1['output_ports'])
        elem_num = pin_num + 1
        print('{0}(primitive_def {1} {2} {3}'.format(indent_1t,site_name, pin_num, elem_num), file=o_file)
        for iport_name in site_inst_1['input_ports']:
            print('{0}(pin {1} {2} input)'.format(indent_2t, iport_name, iport_name), file=o_file)
        for oport_name in site_inst_1['output_ports']:
            print('{0}(pin {1} {2} output)'.format(indent_2t, oport_name, oport_name), file=o_file)
        #
        site_blackbox = site_name + '_' + 'bbox'
        for iport_name in site_inst_1['input_ports']:
            print('{0}(element {1} 1'.format(indent_2t, iport_name), file=o_file)
            print('{0}(pin {1} output)'.format(indent_3t, iport_name), file=o_file)
            print('{0}(conn {1} {1} ==> {2} {1})'.format(indent_3t, iport_name, site_blackbox), file=o_file)
            print('{0})'.format(indent_2t), file=o_file)

        for oport_name in site_inst_1['output_ports']:
            print('{0}(element {1} 1'.format(indent_2t, oport_name), file=o_file)
            print('{0}(pin {1} input)'.format(indent_3t, oport_name), file=o_file)
            print('{0}(conn {1} {1} ==> {2} {1})'.format(indent_3t, oport_name, site_blackbox), file=o_file)
            print('{0})'.format(indent_2t), file=o_file)
        #
        print('{0}(element {1} {2} # BEL'.format(indent_2t, site_blackbox, pin_num), file=o_file)
        for iport_name in site_inst_1['input_ports']:
            print('{0}(pin {1} input)'.format(indent_3t, iport_name), file=o_file)
        for oport_name in site_inst_1['output_ports']:
            print('{0}(pin {1} output)'.format(indent_3t, oport_name), file=o_file)
        #
        for iport_name in site_inst_1['input_ports']:
            print('{0}(conn {1} {2} ==> {2} {2})'.format(indent_3t, site_blackbox, iport_name), file=o_file)
        for oport_name in site_inst_1['output_ports']:
            print('{0}(conn {1} {2} ==> {2} {2})'.format(indent_3t, site_blackbox, oport_name), file=o_file)
        #
        print('{0})'.format(indent_2t), file=o_file)
        print('{0})'.format(indent_1t), file=o_file)
    #
    print(')', file=o_file)

def record_outbound_from_tiles(db):

    for col in db['tiles_secs']['all_tiles']:
        for tile in col:
            value = tile.get('type')
            if value is not None and (value == 'logicTile' or value == 'ioTile'):
                tile_find_uphill_pips(db, tile)


def tile_find_uphill_pips(db, tile):

    for buffer_pip in tile['buffer']:
        dest_net_id = buffer_pip['dest_net_id']
        for src_net in buffer_pip['src_nets']:
            src_net_id = src_net['src_net'][1]
            # record the reverse of PIPs
            x = tile['X']
            y = tile['Y']
            outbound_dict = db['tiles_secs']['all_tiles'][x][y]['outbound']
            if outbound_dict.get(src_net_id) is None:
                outbound_dict[src_net_id] = []
            outbound_dict[src_net_id] = outbound_dict[src_net_id] + [dest_net_id]

    for routing_pip in tile['routing']:
        dest_net_id = routing_pip['dest_net_id']
        for src_net in routing_pip['src_nets']:
            src_net_id = src_net['src_net'][1]
            # record the reverse of PIPs
            x = tile['X']
            y = tile['Y']
            outbound_dict = db['tiles_secs']['all_tiles'][x][y]['outbound']
            if outbound_dict.get(src_net_id) is None:
                outbound_dict[src_net_id] = []
            outbound_dict[src_net_id] = outbound_dict[src_net_id] + [dest_net_id]



def write_ramt_tile(db, tile, o_file, o_pkg_file):
    tile_info = {'name':'TILE_RAMT', 'site_num': 0 }
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_file)
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_pkg_file)
    #
    tile['bel'] = [None]

    #add_bel_ram(tile['X'], tile['Y'])

    for site_id in range(tile_info['site_num']):
        write_logic_site(tile, site_id, o_file, o_pkg_file)
        db['statistic']['site_total'] += 1

    wire_num = len(tile['subnet'])
    write_logic_wire(db, tile, o_file)
    # number of available LUT/FF/CARRY_CHAINS
    unknown = 0
    pip_num = 0
    #pip_num = write_logic_pip(db, tile, o_file)
    #db['statistic']['pip_total'] += pip_num
    print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_file)
    #print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_pkg_file)
    print('{})'.format(indent_1t), file=o_file)
    print('{})'.format(indent_1t), file=o_pkg_file)
    #o_file.write(')')


def write_ramb_tile(db, tile, o_file, o_pkg_file):
    tile_info = {'name':'TILE_RAMB', 'site_num': 1 }
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_file)
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_pkg_file)
    #
    tile['bel'] = [None]

    add_bel_ram(tile['X'], tile['Y'])

    for site_id in range(tile_info['site_num']):
        write_logic_site(tile, site_id, o_file, o_pkg_file)
        db['statistic']['site_total'] += 1

    wire_num = len(tile['subnet'])
    write_logic_wire(db, tile, o_file)
    # number of available LUT/FF/CARRY_CHAINS
    unknown = 0
    pip_num = 0
    pip_num = write_logic_pip(db, tile, o_file)
    db['statistic']['pip_total'] += pip_num
    print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_file)
    #print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_pkg_file)
    print('{})'.format(indent_1t), file=o_file)
    print('{})'.format(indent_1t), file=o_pkg_file)
    #o_file.write(')')


def write_io_tile(db, tile, o_file, o_pkg_file):
    tile_info = {'name':'TILE_IO', 'site_num': 2 }
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_file)
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_pkg_file)
    for site_id in range(tile_info['site_num']):
        add_bel_io(tile['X'], tile['Y'], site_id)

    #if 'extra_cell' in tile:
    #    add_bel_ec(tile, tile_info['site_num'])

    for site_id in range(tile_info['site_num']):
        write_io_site(tile, site_id, o_file, o_pkg_file)

    if 'extra_cell' in tile:
        write_ec_site(tile, tile_info['site_num'], o_file, o_pkg_file)

    wire_num = len(tile['subnet'])
    write_logic_wire(db, tile, o_file)
    # number of available LUT/FF/CARRY_CHAINS
    unknown = 0
    pip_num = 0
    pip_num = write_logic_pip(db, tile, o_file)
    db['statistic']['pip_total'] += pip_num
    print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_file)
    #print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_pkg_file)
    print('{})'.format(indent_1t), file=o_file)
    print('{})'.format(indent_1t), file=o_pkg_file)


def write_logic_tile(db, tile, o_file, o_pkg_file):
    tile_info = {'name':'TILE_ICE40', 'site_num': 8 }
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_file)
    print('{0}(tile {1} {2} TILE_X{1}Y{2} {3} {4}'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], tile_info['site_num'] ), file=o_pkg_file)
    #
    tile['bel'] = [None for i in range(tile_info['site_num'])]
    for site_id in range(tile_info['site_num']):
        add_bel_lc(tile['X'], tile['Y'], site_id)

    for site_id in range(tile_info['site_num']):
        write_logic_site(tile, site_id, o_file, o_pkg_file)
        db['statistic']['site_total'] += 1

    wire_num = len(tile['subnet'])
    write_logic_wire(db, tile, o_file)
    # number of available LUT/FF/CARRY_CHAINS
    unknown = 0
    pip_num = 0
    pip_num = write_logic_pip(db, tile, o_file)
    db['statistic']['pip_total'] += pip_num
    print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_file)
    #print('{0}  (tile_summary TILE_X{1}Y{2} {3} {4} {5} {6})'.format(indent_1t, tile['X'], tile['Y'],tile_info['name'], unknown, wire_num, pip_num), file=o_pkg_file)
    print('{})'.format(indent_1t), file=o_file)
    print('{})'.format(indent_1t), file=o_pkg_file)
    #o_file.write(')')

def write_logic_pip(db, tile, o_file):

    pip_count = 0
    debug=0
    if( tile['X']==0 and tile['Y']==1):
        debug=0
    if(debug==1):
        print('## PIP debug TILE [{},{}] buffer pip'.format(tile['X'], tile['Y']), file=o_file)
    for buffer_pip in tile['buffer']:
        dest_net_id = buffer_pip['dest_net_id']
        dest_subnets = get_subnet(db, tile, dest_net_id)
        src_subnets = []
        for src_net in buffer_pip['src_nets']:
            src_net_id = src_net['src_net'][1]
            src_subnets += get_subnet(db, tile, src_net_id)

        for dest_subnet in dest_subnets:
            for src_subnet in src_subnets:
                print('{}(pip {} -> {})'.format(indent_2t, src_subnet['subnet'], dest_subnet['subnet']), file=o_file)
                pip_count += 1
    if(debug==1):
        print('## PIP debug TILE [{},{}] routing pip'.format(tile['X'], tile['Y']), file=o_file)
    for routing_pip in tile['routing']:
        dest_net_id = routing_pip['dest_net_id']
        dest_subnets = get_subnet(db, tile, dest_net_id)
        src_subnets = []
        for src_net in routing_pip['src_nets']:
            src_net_id = src_net['src_net'][1]
            src_subnets = get_subnet(db, tile, src_net_id)

        for dest_subnet in dest_subnets:
            for src_subnet in src_subnets:
                print('{}(pip {} -> {})'.format(indent_2t, src_subnet['subnet'], dest_subnet['subnet']), file=o_file)
                pip_count += 1

    if 'bel' not in tile:
        return pip_count

    for site_id in range(len(tile['bel'])):
        if(debug==1):
            print('## PIP debug TILE [{},{},{}] route_through pip'.format(tile['X'], tile['Y'], site_id), file=o_file)
        if 'route_through' not in tile['bel'][site_id] and 'lut_permutation' not in tile['bel'][site_id]:
            break
        for local_pips in tile['bel'][site_id]['route_through']:
            src_subnet = local_pips[0]
            dest_subnet = local_pips[1]
            print('{}(pip {} -> {})'.format(indent_2t, src_subnet, dest_subnet), file=o_file)
            pip_count += 1
        if(debug==1):
            print('## PIP debug TILE [{},{},{}] lut_permutation pip'.format(tile['X'], tile['Y'], site_id), file=o_file)
        for local_pips in tile['bel'][site_id]['lut_permutation']:
            src_subnet = local_pips[0]
            dest_subnet = local_pips[1]
            print('{}(pip {} -> {})'.format(indent_2t, src_subnet, dest_subnet), file=o_file)
            pip_count += 1
    return(pip_count)


def get_subnet(db, tile, net_id):

    subnet_arr = []
    for subnet in db['net_secs'][net_id]['subnet_list']:
        if subnet['X'] == tile['X'] and subnet['Y'] == tile['Y']:
            subnet_arr.append(subnet)

    return(subnet_arr)


def write_logic_wire(db, tile, o_file):

    debug=0
    if( tile['X']==1 and tile['Y']==1):
        debug=0

    for wire_name in sorted(tile['subnet']):
        if(debug==1 and wire_name == 'lutff_1/in_0'):
            print('## Wire debug TILE [{},{}, {}] '.format(tile['X'], tile['Y'], wire_name), file=o_file)
        net_id = tile['subnet'][wire_name]
        if(net_id == -1):
            subnet_arr = [{'X':tile['X'], 'Y':tile['Y'], 'subnet':wire_name}]
        else:
            subnet_arr = db['net_secs'][net_id]['subnet_list']
        subnet_size = len(subnet_arr)
        print('{}(wire {} {}'.format(indent_2t, wire_name, subnet_size-1), end=' ', file=o_file)
        for subnet in subnet_arr:
            if subnet['X'] == tile['X'] and subnet['Y'] == tile['Y'] and wire_name == subnet['subnet']:
                continue
            print('', file=o_file)
            print('{}  (conn TILE_X{}Y{} {})'.format(indent_2t, subnet['X'], subnet['Y'], subnet['subnet']), end=' ', file=o_file)
        if subnet_size == 1:
            print(')', file=o_file)
        else:
            print(f'\n{indent_2t})', file=o_file)


def write_logic_site(tile, site_id, o_file, o_pkg_file):
    site_info = {'name':'ICESTORM_LC'} # LogicCell40 - after synthesis, tysung 4/2/2024
    site_info['name'] = tile['bel'][site_id]['name'][2]
    site_info['type'] = tile['bel'][site_id]['type']
    site_info['input_ports'] = tile['bel'][site_id]['input_ports']
    site_info['output_ports'] = tile['bel'][site_id]['output_ports']
    port_num = len(site_info['input_ports']) + len(site_info['output_ports'])
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_file)
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_pkg_file)
    for input_pin, pin_value in site_info['input_ports'].items():
        print('{}(pinwire {} input {})'.format(indent_3t, input_pin, pin_value), file=o_file)
    for output_pin, pin_value in site_info['output_ports'].items():
        print('{}(pinwire {} output {})'.format(indent_3t, output_pin, pin_value), file=o_file)

    print('{})'.format(indent_2t), file=o_file)
    print('{})'.format(indent_2t), file=o_pkg_file)

def add_wire(x, y, name):
    global Tile2Darr

    net_id = -1
    if name not in Tile2Darr[x][y]['subnet']:
        Tile2Darr[x][y]['subnet'][name] = net_id # added by ICESTORM database
        #print('## add_wire : {} {} {} ##'.format(x, y, name))
    else:
        net_id = Tile2Darr[x][y]['subnet'][name]

    return (net_id, name)


def add_switch(x, y, bel, type):
    if type not in bel:
        bel[type] = []

    return

def add_pip(bel, type, src, dst, flags=0):
    bel[type] += [(src, dst, flags)]
    return

def add_bel_input(bel, wire, port):
    bel['input_ports'][port] = wire
    return

def add_bel_output(bel, wire, port):
    bel['output_ports'][port] = wire
    return

def wire_names(x, y, wire_name):
    global Tile2Darr
    net_id = -1
    net_id = Tile2Darr[x][y]['subnet'][wire_name]
    return (net_id, wire_name)

def add_bel_lc(x, y, z):
    global Tile2Darr
    global BEL

    tile = Tile2Darr[x][y]
    if tile['bel'][z] is not None:
        return

    bel = {'input_ports':{}, 'output_ports':{}} # eventually write into "site_info" in slice
    tile = Tile2Darr[x][y]
    tile['bel'][z] = bel
    #bel = len(bel_name)
    bel['name'] = (x, y, "lc%d" % z)
    bel['type'] = "ICESTORM_LC" # LogicCell40 - after synthesis, tysung 4/2/2024
    bel['pos'] = (x, y, z)
    #
    if bel['type'] not in BEL['primitive_def']:
        BEL['primitive_def'][bel['type']] = []
    BEL['primitive_def'][bel['type']] += [bel]
    #print(bel['pos'])
    #bel['wires'] = []

    (wire_cen_id, wire_cen) = wire_names(x, y, "lutff_global/cen")
    (wire_clk_id, wire_clk) = wire_names(x, y, "lutff_global/clk")
    (wire_s_r_id, wire_s_r) = wire_names(x, y, "lutff_global/s_r")

    if z == 0:
        (wire_cin_id, wire_cin) = wire_names(x, y, "carry_in_mux")
    else:
        (wire_cin_id, wire_cin) = wire_names(x, y, "lutff_%d/cout" % (z-1))

    (wire_in_0_id, wire_in_0) = add_wire(x, y, "lutff_%d/in_0_lut" % z)
    (wire_in_1_id, wire_in_1) = add_wire(x, y, "lutff_%d/in_1_lut" % z)
    (wire_in_2_id, wire_in_2) = add_wire(x, y, "lutff_%d/in_2_lut" % z)
    (wire_in_3_id, wire_in_3) = add_wire(x, y, "lutff_%d/in_3_lut" % z)

    (wire_out_id, wire_out)  = wire_names(x, y, "lutff_%d/out"  % z)
    (wire_count_id, wire_cout) = wire_names(x, y, "lutff_%d/cout" % z)
    (wire_lout_id, wire_lout) = wire_names(x, y, "lutff_%d/lout" % z) if z < 7 else (-1, None)

    add_bel_input(bel, wire_cen, "CEN")
    add_bel_input(bel, wire_clk, "CLK")
    add_bel_input(bel, wire_s_r, "SR")
    add_bel_input(bel, wire_cin, "CIN")

    add_bel_input(bel, wire_in_0, "I0")
    add_bel_input(bel, wire_in_1, "I1")
    add_bel_input(bel, wire_in_2, "I2")
    add_bel_input(bel, wire_in_3, "I3")

    add_bel_output(bel, wire_out,  "O")
    add_bel_output(bel, wire_cout, "COUT")

    if wire_lout is not None:
        add_bel_output(bel, wire_lout, "LO")

    # route-through LUTs
    type = 'route_through'
    add_switch(x, y, bel, type)
    add_pip(bel, type, wire_in_0, wire_out, 1)
    add_pip(bel, type, wire_in_1, wire_out, 1)
    add_pip(bel, type, wire_in_2, wire_out, 1)
    add_pip(bel, type, wire_in_3, wire_out, 1)

    # LUT permutation pips
    for i in range(4):
        type = 'lut_permutation'
        add_switch(x, y, bel, type)
        for j in range(4):
            if (i == j) or ((i, j) == (1, 2)) or ((i, j) == (2, 1)):
                flags = 0
            else:
                flags = 2
            (src_wire_id, src_wire) = wire_names(x, y, "lutff_%d/in_%d" % (z, i))
            (dst_wire_id, dst_wire) = wire_names(x, y, "lutff_%d/in_%d_lut"  % (z, j))
            add_pip(bel, type, src_wire, dst_wire, flags)
            #add_pip(wire_names[(x, y, "lutff_%d/in_%d" % (z, i))],
            #        wire_names[(x, y, "lutff_%d/in_%d_lut"  % (z, j))], flags)


def add_bel_ram(x, y):
    global Tile2Darr
    global BEL

    tile = Tile2Darr[x][y]
    if tile['bel'][0] is not None:
        return

    bel = {'input_ports':{}, 'output_ports':{}} # eventually write into "site_info" in slice
    tile['bel'][0] = bel
    #bel = len(bel_name)
    bel['name'] = (x, y, "ram")
    bel['type'] = "ICESTORM_RAM"
    bel['pos'] = (x, y)
    #
    if bel['type'] not in BEL['primitive_def']:
        BEL['primitive_def'][bel['type']] = []
    BEL['primitive_def'][bel['type']] += [bel]


    #if (x, y, "ram/WE") in wire_names
    if 'ram/WE' in Tile2Darr[x][y]['subnet']:
        # iCE40 1K-style memories
        y0, y1 = y, y+1
    else:
        # iCE40 8K-style memories
        y1, y0 = y, y+1

    for i in range(16):
        #add_bel_input (bel, wire_names[(x, y0 if i < 8 else y1, "ram/MASK_%d"  % i)], "MASK_%d"  % i)
        if i < 8:
            y = y0
        else:
            y = y1
        (wire_mask_i_id, wire_mask_i) = wire_names(x, y, "ram/MASK_%d"  % i)
        add_bel_input(bel, wire_mask_i, "MASK_%d"  % i)
        #add_bel_input (bel, wire_names[(x, y0 if i < 8 else y1, "ram/WDATA_%d" % i)], "WDATA_%d" % i)
        (wire_wdata_i_id, wire_wdata_i) = wire_names(x, y, "ram/WDATA_%d"  % i)
        add_bel_input(bel, wire_wdata_i, "WDATA_%d"  % i)
        #add_bel_output(bel, wire_names[(x, y0 if i < 8 else y1, "ram/RDATA_%d" % i)], "RDATA_%d" % i)
        (wire_rdata_i_id, wire_rdata_i) = wire_names(x, y, "ram/RDATA_%d"  % i)
        add_bel_output(bel, wire_rdata_i, "RDATA_%d"  % i)


    for i in range(11):
        #add_bel_input(bel, wire_names[(x, y0, "ram/WADDR_%d" % i)], "WADDR_%d" % i)
        (wire_waddr_i_id, wire_waddr_i) = wire_names(x, y0, "ram/WADDR_%d"  % i)
        add_bel_input(bel, wire_waddr_i, "WADDR_%d"  % i)
        #add_bel_input(bel, wire_names[(x, y1, "ram/RADDR_%d" % i)], "RADDR_%d" % i)
        (wire_raddr_i_id, wire_raddr_i) = wire_names(x, y1, "ram/RADDR_%d"  % i)
        add_bel_input(bel, wire_raddr_i, "RADDR_%d"  % i)

    #add_bel_input(bel, wire_names[(x, y0, "ram/WCLK")], "WCLK")
    (wire_wclk_id, wire_wclk) = wire_names(x, y0, "ram/WCLK")
    add_bel_input(bel, wire_wclk, "WCLK")
    #add_bel_input(bel, wire_names[(x, y0, "ram/WCLKE")], "WCLKE")
    (wire_wclke_id, wire_wclke) = wire_names(x, y0, "ram/WCLKE")
    add_bel_input(bel, wire_wclke, "WCLKE")
    #add_bel_input(bel, wire_names[(x, y0, "ram/WE")], "WE")
    (wire_we_id, wire_we) = wire_names(x, y0, "ram/WE")
    add_bel_input(bel, wire_we, "WE")

    #add_bel_input(bel, wire_names[(x, y1, "ram/RCLK")], "RCLK")
    (wire_rclk_id, wire_rclk) = wire_names(x, y1, "ram/RCLK")
    add_bel_input(bel, wire_rclk, "RCLK")
    #add_bel_input(bel, wire_names[(x, y1, "ram/RCLKE")], "RCLKE")
    (wire_rclke_id, wire_rclke) = wire_names(x, y1, "ram/RCLKE")
    add_bel_input(bel, wire_rclke, "RCLKE")
    #add_bel_input(bel, wire_names[(x, y1, "ram/RE")], "RE")
    (wire_re_id, wire_re) = wire_names(x, y1, "ram/RE")
    add_bel_input(bel, wire_re, "RE")

def add_if_new(x, y, name):
    if name in Tile2Darr[x][y]['subnet']:
        (wire_id, wire) = wire_names(x, y, name)
        return wire
    else:
        (wire_id, wire) = add_wire(x, y, name)
        return wire


def is_ec_wire(ec_entry):
    #return ec_entry[1] in wire_names
    return ec_entry[3] in Tile2Darr[ec_entry[1]][ec_entry[2]]['subnet']

def is_ec_output(ec_entry):
    #wirename = ec_entry[1][2]
    wirename = ec_entry[3]
    if "O_" in wirename or "slf_op_" in wirename: return True
    if "neigh_op_" in wirename: return True
    if "glb_netwk_" in wirename: return True
    return False

def is_ec_pll_clock_output(ec, ec_entry):
    return ec == 'PLL' and ec_entry[0] in ('PLLOUT_A', 'PLLOUT_B')

def add_pll_clock_output(bel, entry):
    # Fabric output
    io_x, io_y, io_z = (entry[1], entry[2], entry[3])
    io_zs = 'io_{}/D_IN_0'.format(io_z)
    io_z  = int(io_z)
    #add_bel_output(bel, wire_names[(io_x, io_y, io_zs)], entry[0])
    (wire_id, wire) = wire_names(io_x, io_y, io_zs)
    add_bel_output(bel, wire, entry[0])

    # Global output
    #for gidx, ginfo in glbinfo.items():
    #    if (ginfo['pi_gb_x'], ginfo['pi_gb_y'], ginfo['pi_gb_pio']) == (io_x, io_y, io_z):
    #        add_bel_output(bel, wire_names[(io_x, io_y, "glb_netwk_%d" % gidx)], entry[0] + '_GLOBAL')


def add_bel_ec(tile, z):
    #ectype, x, y, z = ec
    global Tile2Darr
    global BEL

    x = tile['X']
    y = tile['Y']
    ectype = tile['extra_cell']['cell']

    bel = {'input_ports':{}, 'output_ports':{}, 'extra_cell_config':{}} # eventually write into "site_info" in slice
    extra_cell_config = bel['extra_cell_config']
    if 'bel' not in tile:
        tile['bel'] = []
    tile['bel'].append(bel)
    #bel = len(bel_name)
    bel['name'] = (x, y, "%s_%d" % (ectype.lower(), z))
    bel_name = bel['name'][2]
    bel['type'] = ectype
    bel['pos'] = (x, y, z)
    #
    if bel['type'] not in BEL['primitive_def']:
        BEL['primitive_def'][bel['type']] = []
    BEL['primitive_def'][bel['type']] += [bel]

    #ec: [ectype, x, y, z]
    #entry: [port, x1, y1, wire]
    for entry in tile['extra_cell']['key_value']:
        if is_ec_wire(entry):
            # check if this pinwire connection belong to the same tile of this extra_cell
            # if answer is NO, this pinwire has to make "conn" to this wire
            (wire_id, pinwire) = wire_names(entry[1], entry[2], entry[3])
            if entry[1] != x or entry[2] != y:
                pinwire = entry[3] + '_' + str(entry[1]) + '_' + str(entry[2])
                #(new_id, wire) = add_wire(x, y, pinwire)
                NetArr[wire_id]['subnet_list'] += [{'X':x, 'Y':y, 'subnet':pinwire}]
                Tile2Darr[x][y]['subnet'][pinwire]=wire_id
                
            if is_ec_output(entry):
                #add_bel_output(bel, wire_names[entry[1]], entry[0])
                (wire_id, wire) = wire_names(x, y, pinwire)
                add_bel_output(bel, wire, entry[0])
            else:
                #add_bel_input(bel, wire_names[entry[1]], entry[0])
                (wire_id, wire) = wire_names(x, y, pinwire)
                add_bel_input(bel, wire, entry[0])

        elif is_ec_pll_clock_output(ectype, entry):
            add_pll_clock_output(bel, entry)
        else:
            if bel_name not in extra_cell_config:
                extra_cell_config[bel_name] = []
            extra_cell_config[bel_name].append(entry)
    if ectype == "MAC16":
        if y == 5:
            last_dsp_y = 0 # dummy, but the wire is needed
        elif y == 10:
            last_dsp_y = 5
        elif y == 13:
            last_dsp_y = 5
        elif y == 15:
            last_dsp_y = 10
        elif y == 23:
            last_dsp_y = 23
        else:
            assert False, "unknown DSP y " + str(y)

        wire_signextin = add_if_new(x, last_dsp_y, "dsp/signextout")
        wire_signextout = add_if_new(x, y, "dsp/signextout")
        wire_accumci = add_if_new(x, last_dsp_y, "dsp/accumco")
        wire_accumco = add_if_new(x, y, "dsp/accumco")
        add_bel_input(bel, wire_signextin, "SIGNEXTIN")
        add_bel_output(bel, wire_signextout, "SIGNEXTOUT")
        add_bel_input(bel, wire_accumci, "ACCUMCI")
        add_bel_output(bel, wire_accumco, "ACCUMCO")


def add_bel_io(x, y, z):
    global Tile2Darr
    global BEL

    tile = Tile2Darr[x][y]
    #if 'bel' not in tile:
    #    tile['bel'] = [None, None]
    #elif Tile2Darr[x][y]['bel'][z] is not None:
    #    return
    bel = {'input_ports':{}, 'output_ports':{}} # eventually write into "site_info" in slice
    if 'bel' not in tile:
        tile['bel'] = []
    tile['bel'].append(bel)
    #tile['bel'][z] = bel
    #bel = len(bel_name)
    bel['name'] = (x, y, "io%d" % z)
    bel['type'] = "SB_IO"
    bel['pos'] = (x, y, z)
    #
    if bel['type'] not in BEL['primitive_def']:
        BEL['primitive_def'][bel['type']] = []
    BEL['primitive_def'][bel['type']] += [bel]

    (wire_cen_id, wire_cen)   = wire_names(x, y, "io_global/cen")
    (wire_iclk_id, wire_iclk)  = wire_names(x, y, "io_global/inclk")
    (wire_latch_id, wire_latch) = wire_names(x, y, "io_global/latch")
    (wire_oclk_id, wire_oclk)  = wire_names(x, y, "io_global/outclk")

    (wire_din_0_id, wire_din_0)  = wire_names(x, y, "io_%d/D_IN_0"  % z)
    (wire_din_1_id, wire_din_1)  = wire_names(x, y, "io_%d/D_IN_1"  % z)
    (wire_dout_0_id, wire_dout_0) = wire_names(x, y, "io_%d/D_OUT_0" % z)
    (wire_dout_1_id, wire_dout_1) = wire_names(x, y, "io_%d/D_OUT_1" % z)
    (wire_out_en_id, wire_out_en) = wire_names(x, y, "io_%d/OUT_ENB" % z)

    add_bel_input(bel, wire_cen,    "CLOCK_ENABLE")
    add_bel_input(bel, wire_iclk,   "INPUT_CLK")
    add_bel_input(bel, wire_oclk,   "OUTPUT_CLK")
    add_bel_input(bel, wire_latch,  "LATCH_INPUT_VALUE")

    add_bel_output(bel, wire_din_0, "D_IN_0")
    add_bel_output(bel, wire_din_1, "D_IN_1")

    add_bel_input(bel, wire_dout_0, "D_OUT_0")
    add_bel_input(bel, wire_dout_1, "D_OUT_1")
    add_bel_input(bel, wire_out_en, "OUTPUT_ENABLE")

    #for gidx, ginfo in glbinfo.items():
    #    if (ginfo['pi_gb_x'], ginfo['pi_gb_y'], ginfo['pi_gb_pio']) == (x,y,z):
    #        add_bel_output(bel, wire_names[(x, y, "glb_netwk_%d" % gidx)], "GLOBAL_BUFFER_OUTPUT")

def write_io_site(tile, site_id, o_file, o_pkg_file):
    site_info = {'name':'SB_IO'}
    site_info['name'] = tile['bel'][site_id]['name'][2]
    site_info['type'] = tile['bel'][site_id]['type']
    site_info['input_ports'] = tile['bel'][site_id]['input_ports']
    site_info['output_ports'] = tile['bel'][site_id]['output_ports']
    port_num = len(site_info['input_ports']) + len(site_info['output_ports'])
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_file)
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_pkg_file)
    for input_pin, pin_value in site_info['input_ports'].items():
        print('{}(pinwire {} input {})'.format(indent_3t, input_pin, pin_value), file=o_file)
    for output_pin, pin_value in site_info['output_ports'].items():
        print('{}(pinwire {} output {})'.format(indent_3t, output_pin, pin_value), file=o_file)

    print('{})'.format(indent_2t), file=o_file)
    print('{})'.format(indent_2t), file=o_pkg_file)

def write_ec_site(tile, site_id, o_file, o_pkg_file):
    site_info = {'name':'EC_SITE'}
    site_info['name'] = tile['bel'][site_id]['name'][2]
    site_info['type'] = tile['bel'][site_id]['type']
    site_info['input_ports'] = tile['bel'][site_id]['input_ports']
    site_info['output_ports'] = tile['bel'][site_id]['output_ports']
    port_num = len(site_info['input_ports']) + len(site_info['output_ports'])
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_file)
    print('{}(primitive_site {} {} internal {}'.format(indent_2t, site_info['name'], site_info['type'],  port_num ), file=o_pkg_file)
    for input_pin, pin_value in site_info['input_ports'].items():
        print('{}(pinwire {} input {})'.format(indent_3t, input_pin, pin_value), file=o_file)
    for output_pin, pin_value in site_info['output_ports'].items():
        print('{}(pinwire {} output {})'.format(indent_3t, output_pin, pin_value), file=o_file)

    print('{})'.format(indent_2t), file=o_file)
    print('{})'.format(indent_2t), file=o_pkg_file)



start = 'config'

#parser = yacc.yacc(debug=True, tracking=True)
#parser = yacc.yacc(debug=True,debuglog=log)
parser = yacc.yacc(debug=True)



def write_xdlrc(db, conns_name, devicename):
    xdlrc_info = {}
    output_f_name = conns_name + '.conns.xdlrc'
    pkg_f_name = devicename + '.xdlrc'
    db['statistic']={'tile_total':0, 'site_total':0, 'sitedef_total':0, 'pin_total':0, 'pip_total':0}
    o_pkg_file = open(pkg_f_name, 'w')
    with open(output_f_name, 'w') as o_file:
        # write outbound pips for each tile - tile['outbound'] = {src_net_id: [dest_1_id, dest_2_id, ..]}
        #record_outbound_from_tiles(db)
        # add extra_cells into the tiles in description
        process_extra_cells(db)
        # Write the data to the file
        print('# 14.7 "Release 14.7 - xdl P.20131013 (lin64)"', file=o_file)
        print('# 14.7 "Release 14.7 - xdl P.20131013 (lin64)"', file=o_pkg_file)
        #
        print('(xdl_resource_report v0.1 {} ice40'.format(devicename), file=o_file)
        print('(xdl_resource_report v0.1 {} ice40'.format(devicename), file=o_pkg_file)
        print('(tiles {} {}'.format(db['device']['X'], db['device']['Y']), file=o_file)
        print('(tiles {} {}'.format(db['device']['X'], db['device']['Y']), file=o_pkg_file)
        for col in db['tiles_secs']['all_tiles']:
            for tile in col:
                value = tile.get('type')
                if value is not None and value == 'logicTile':
                    write_logic_tile(db, tile, o_file, o_pkg_file)
                    db['statistic']['tile_total'] += 1
                elif value is not None and value == 'ioTile':
                    write_io_tile(db, tile, o_file, o_pkg_file)
                    db['statistic']['tile_total'] += 1
                elif value is not None and value == 'rambTile':
                    write_ramb_tile(db, tile, o_file, o_pkg_file)
                    db['statistic']['tile_total'] += 1
                elif value is not None and value == 'ramtTile':
                    write_ramt_tile(db, tile, o_file, o_pkg_file)
                    db['statistic']['tile_total'] += 1

        o_file.write(')')
        o_pkg_file.write(')')
        #
        write_primitive_defs(db, o_file)
        db['statistic']['sitedef_total'] = 0
        write_primitive_defs(db, o_pkg_file)
        #
        tile_total=db['statistic']['tile_total']
        site_total=db['statistic']['site_total']
        sitedef_total=db['statistic']['sitedef_total']
        pin_total=db['statistic']['pin_total']
        pip_total=db['statistic']['pip_total']
        print('(summary tiles={} sites={} sitedefs={} numpins={} numpips={})'.format(tile_total, site_total, sitedef_total, pin_total, pip_total), file=o_file)
        print('(summary tiles={} sites={} sitedefs={} numpins={} numpips={})'.format(tile_total, site_total, sitedef_total, pin_total, pip_total), file=o_pkg_file)
        o_file.write(')')
        o_pkg_file.write(')')
        o_file.close()
        o_pkg_file.close()
        #
        output_f_name_gz = conns_name + '.conns.xdlrc.gz'
        pkg_f_name_gz = devicename + '.xdlrc.gz'
        result = subprocess.run(['rm', '-f', pkg_f_name_gz, output_f_name_gz], capture_output=True, text=True)
        #
        result = subprocess.run(['gzip', output_f_name], capture_output=True, text=True)
        result = subprocess.run(['gzip', pkg_f_name], capture_output=True, text=True)

def read_db(filename):

    db = {}
    with open(filename, 'r') as f:
        input = f.read()
        db = parser.parse(input)
        #pp.pprint(db)
        #pp.pprint(parser.parse(input))
        f.close()

    return(db)



def write_digest_family(db, family_name, device, minor, pkg):

    output_f_name = family_name + '.packages.digest'
    with open(output_f_name, 'w') as o_file:
        # Write the data to the file
        print('{}{}{}'.format(family_name, minor, device),  end='', file=o_file)
        print(':-1:{};'.format(pkg), end='', file=o_file)
        pin_idx = 0
        for pin in db['pins'][0]['pin_list']:
            p_name = pin['idx']
            t_name = 'TILE_X{}Y{}.io{}'.format(pin['X'], pin['Y'], pin['pio_num'])
            print('{},{},{},unbounded;'.format(pin_idx, p_name, t_name), end='', file=o_file)
            pin_idx += 1
        print('', file=o_file)
    o_file.close()

    output_f_name = '{}{}{}.digest'.format(family_name, minor, device)
    with open(output_f_name, 'w') as o_file:
        tile_idx = 0
        for col in db['tiles_secs']['all_tiles']:
            for tile in col:
                value = tile.get('type')
                if value is None:
                    continue
                X = tile['X']
                Y = tile['Y']
                t_cell = 'unknown'
                if value is not None and value == 'logicTile':
                    t_cell = 'TILE_ICE40'
                elif value is not None and value == 'ioTile':
                    t_cell = 'TILE_IO'
                elif value is not None and value == 'rambTile':
                    t_cell = 'TILE_BRAM'
                elif value is not None and value == 'ramtTile':
                    t_cell = 'TILE_TRAM'
                else:
                    continue
                t_name = 'TILE_X{}Y{}'.format(X, Y)
                # get the site number in this tile
                num = 0
                if 'bel' in tile:
                    num = len(tile['bel'])
                print('{},{},{},{},{},{}'.format(tile_idx, X, Y, t_name, t_cell, num), file=o_file)
                tile_idx += 1
    o_file.close()

    return



def main():
    lattice_family = {
        'ice40': {'384':['lp'], '1k':['lp','hx'], '5k':['up'], '8k':['lp','hx'], 'lm4k':['lp'], 'u4k':['up']},
        'lp': ['swg16','cm36','cm49','cm81','cb81','cm121','cb121','cm225','sg32','qn84'],
        'hx': ['cb132','cm225','ct256','tq144','vq100','bg121'],
        'up': ['uwg30','sg48'] }

    filename = sys.argv[1]
    devicename = sys.argv[2]
    # devicename = "ICE40UP5K-SG48"
    pp = pprint.PrettyPrinter(indent=2)
    db = read_db(filename)
    # chipdb-1k.ext ice40lp387
    device = 'unknown'
    result = re.match(r'chipdb-(\w+).txt', filename)
    if result:
        device = result.group(1)
    #
    # get 1st package from this file.
    pkg = db['pins'][0]['package']
    minor = lattice_family['ice40'][device][0]
    #write_digest_family(db, 'ice40', device, minor, pkg)
    #
    devicename = 'unknowndevicename'
    if 'ice40' in lattice_family:
        #for minor in lattice_family['ice40'][device]:
        minor = lattice_family['ice40'][device][0]
        conns = 'ice40' + minor + device
        # if pkg in lattice_family[minor]:
        pkg = lattice_family[minor][0]
        devicename = 'ice40' + minor + device + pkg
        write_xdlrc(db, conns, devicename)

    write_digest_family(db, 'ice40', device, minor, pkg)

    return

if __name__ == '__main__':
    main()
    exit(0)
