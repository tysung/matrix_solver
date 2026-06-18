#!/usr/bin/env python
#
#
import sys
import ply.lex as lex
import re

# Set up a logging object
import logging
logging.basicConfig(
    level = logging.DEBUG,
    filename = "parselog.txt",
    filemode = "w",
    format = "%(filename)10s:%(lineno)4d:%(message)s"
)
log = logging.getLogger()


#
#reserved = {
#   '.device' : 'DEVICE',
#   '.pins' : 'PINS',
#   '5k' : 'FAMILY'
#}
#tokens = list(reserved.values()) + [ 'GBUFIN', ... ]

tokens = [ 'DEVICE',
           'LOCKED',
           'PINS',
           'FAMILY',
           'GBUFIN',
           'GBUFPIN',
           'IOLATCH',
           'IEREN',
           'COLBUF',
           'IO_TILE',
           'LOGIC_TILE',
           'RAMB_TILE',
           'RAMT_TILE',
           'DSP_TILE',
           'IPCON_TILE',
           'IO_TILE_BITS',
           'LOGIC_TILE_BITS',
           'RAMB_TILE_BITS',
           'RAMT_TILE_BITS',
           'DSP_TILE_BITS',
           'IPCON_TILE_BITS',
           'EXTRA_CELL',
           'EXTRA_BITS',
           'NET',
           'BUFFER',
           'ROUTING',
           'NUMBER',
           'NAME',
           'STRING',
           'CONFIG_BIT',
           'DOT',
           'NEWLINE',
           'COMMENT' ]

#tokens = ['LPAREN','RPAREN',...,'ID'] + list(reserved.values())
#
#def t_ID(t):
#    r'[a-zA-Z_][a-zA-Z_0-9]*'
#    t.type = reserved.get(t.value,'ID')    # Check for reserved words
#    return t
#

def t_DEVICE(t):
    '.device'
    return t


def t_FAMILY(t):
    r'[135]k'
    return t
#    r'\S+'
#    return t

def t_LOCKED(t):
    'LOCKED'
    return t

def t_PINS(t):
    '.pins'
    return t

def t_GBUFIN(t):
    '.gbufin'
    return t

def t_GBUFPIN(t):
    '.gbufpin'
    return t

def t_IOLATCH(t):
    '.iolatch'
    return t

def t_IEREN(t):
    '.ieren'
    return t

def t_COLBUF(t):
    '.colbuf'
    return t

def t_NET(t):
    '.net'
    return t


def t_IO_TILE_BITS(t):
    '.io_tile_bits'
    return t

def t_IO_TILE(t):
    '.io_tile'
    return t

def t_LOGIC_TILE_BITS(t):
    '.logic_tile_bits'
    return t


def t_LOGIC_TILE(t):
    '.logic_tile'
    return t


def t_RAMB_TILE_BITS(t):
    '.ramb_tile_bits'
    return t


def t_RAMB_TILE(t):
    '.ramb_tile'
    return t


def t_RAMT_TILE_BITS(t):
    '.ramt_tile_bits'
    return t


def t_RAMT_TILE(t):
    '.ramt_tile'
    return t


def t_DSP_TILE_BITS(t):
    r'.dsp[0-3]_tile_bits'
    return t


def t_DSP_TILE(t):
    r'.dsp[0-3]_tile'
    return t


def t_IPCON_TILE_BITS(t):
    '.ipcon_tile_bits'
    return t

def t_IPCON_TILE(t):
    '.ipcon_tile'
    return t


def t_EXTRA_CELL(t):
    '.extra_cell'
    return t

def t_EXTRA_BITS(t):
    '.extra_bits'
    return t

def t_BUFFER(t):
    '.buffer'
    return t


def t_ROUTING(t):
    '.routing'
    return t

def t_CONFIG_BIT(t):
    r'B[0-9]*\[[0-9]*\]'
    return t

def t_NEWLINE(t):
    r'\n+'

    #t.lexer.lineno += 1 
    t.lexer.lineno += len(t.value)
    #pass 

def t_COMMENT(t):
    r'\#.*'
    #t.lexer.lineno += 1 
    pass
    # No return value. Token discarded

def t_NUMBER(t): 
    r'\d+'
    t.value = int(t.value)
    return t

#def t_BIT_ARRAY(t):
#    r'[0-1]+'
#    return t

def t_NAME(t):
    r'[a-zA-Z_][a-zA-Z0-9_\/]*'
    return t

def t_STRING(t):
    r'(\".*\"|\'.*\')'
    t.value = t.value[1:-1]
    return t

def t_DOT(t):
    '\.'
    return t




#def t_LBRACKET(t):
#    '['
#    return t

#def t_RBRACKET(t):
#    ']'
#    return t

t_ignore = ' \t'

# Error handling rule
def t_error(t):
    print("Illegal word '{0}' at line {1}".format(t.value[0:5], t.lineno))
    t.lexer.skip(1)

lexer = lex.lex(debug=True, debuglog=log)


if __name__ == '__main__':
#	lex.runmain()
	filename = sys.argv[1]
	with open(filename, 'r') as f:
		input = f.read()
		#pp.pprint(parser.parse(input))
		lex.input(input)
		while 1:
			tok = lex.token()
			if not tok: break
			print(tok)









