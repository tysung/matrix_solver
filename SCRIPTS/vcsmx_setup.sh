
# (C) 2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Intel 
# Program License Subscription Agreement, Intel FPGA IP 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Intel and sold by Intel 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 13.1 63 linux 2013.05.15.10:51:32

# ----------------------------------------
# vcsmx - auto-generated simulation script

# ----------------------------------------
#
#export VCS_HOME=/export/tools/synopsys/vcs/Q-2020.03
export VCS_HOME=/export/tools/synopsys/L-2016.06-SP1
export PATH=$VCS_HOME/bin:$PATH
#
# initialize variables
TOP_LEVEL_NAME="top_level"
QSYS_SIMDIR="./../../"
QUARTUS_INSTALL_DIR="/opt/intel/quartus/21.4/quartus"
SKIP_FILE_COPY=0
SKIP_DEV_COM=0
SKIP_COM=0
SKIP_ELAB=0
SKIP_SIM=0
USER_DEFINED_ELAB_OPTIONS=""
USER_DEFINED_SIM_OPTIONS="+vcs+finish+100"

# ----------------------------------------
# overwrite variables - DO NOT MODIFY!
# This block evaluates each command line argument, typically used for 
# overwriting variables. An example usage:
#   sh <simulator>_setup.sh SKIP_ELAB=1 SKIP_SIM=1
for expression in "$@"; do
  eval $expression
  if [ $? -ne 0 ]; then
    echo "Error: This command line argument, \"$expression\", is/has an invalid expression." >&2
    exit $?
  fi
done

# ----------------------------------------
# create compilation libraries
rm -rf libraries/*
mkdir -p ./libraries/work/
mkdir -p ./libraries/altera_ver/
mkdir -p ./libraries/lpm_ver/
mkdir -p ./libraries/sgate_ver/
mkdir -p ./libraries/altera_mf/
mkdir -p ./libraries/altera_lnsim_ver/
#mkdir -p ./libraries/stratix10_ver/
mkdir -p ./libraries/fourteennm/

# ----------------------------------------
# copy RAM/ROM files to simulation directory

# ----------------------------------------
# compile device library files
if [ $SKIP_DEV_COM -eq 0 ]; then
  vlogan -full64 +v2k "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v" -work altera_ver
  vlogan -full64 +v2k "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v" -work lpm_ver
  vlogan -full64 +v2k "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v" -work sgate_ver
  vlogan -full64 +v2k "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v" -work altera_mf
  vhdlan -full64 "$QUARTUS_INSTALL_DIR/libraries/vhdl/altera_mf/altera_mf_components.vhd" -work altera_mf         
  vlogan -full64 +v2k -sverilog "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv" -work altera_lnsim_ver
  vhdlan -full64 "$QUARTUS_INSTALL_DIR/libraries/vhdl/wys_vhdl_def/fourteennm_entities.vhd" -work fourteennm         
  vhdlan -full64 "$QUARTUS_INSTALL_DIR/libraries/vhdl/fourteennm/fourteennm_components.vhd" -work fourteennm         
#  vhdlan "$QUARTUS_INSTALL_DIR/eda/sim_lib/fourteennm_atoms.vhd" -work fourteennm         
fi

# ----------------------------------------
# compile design files in correct order
if [ $SKIP_COM -eq 0 ]; then
  vlogan +v2k "$QSYS_SIMDIR/pll_sv.vo"
fi

# ----------------------------------------
# elaborate top level design
if [ $SKIP_ELAB -eq 0 ]; then
  vcs -lca -t ps $USER_DEFINED_ELAB_OPTIONS $TOP_LEVEL_NAME
fi

# ----------------------------------------
# simulate
if [ $SKIP_SIM -eq 0 ]; then
  ./simv $USER_DEFINED_SIM_OPTIONS
fi
