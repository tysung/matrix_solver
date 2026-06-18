#!/bin/bash -x
# -recursive is not working for 1st git clone
#git clone https://github.com/SymbiFlow/symbiflow-xc-fasm2bels
#git clone https://github.com/SymbiFlow/capnproto-java
#git clone https://github.com/SymbiFlow/fpga-interchange-schema
#
cd symbiflow-xc-fasm2bels
#
export CAPNP_PATH=/import/home/tsung/FASM2BELS/capnproto-java/compiler/src/main/schema
export INTERCHANGE_SCHEMA_PATH=/import/home/tsung/FASM2BELS/fpga-interchange-schema/interchange
#
#export PYTHON=python3.7
#
#make env PYTHON=python3.7
source env/bin/activate
#python -m pip install -r requirements.txt
#make format
#make build
#
#make test-py
#
#python3.7 -m pip install .
#
cd third_party/prjxray
# missing part yaml file
#./download-latest-db.sh
#make db-prepare-parts
#
# edit kintex7.sh to define the part for bitstream files
#source settings/zynq7010.sh
#python3.7 utils/bit2fasm.py and_ref/and.bit &> and_ref/and.fasm
#python3 utils/bit2fasm.py cift_bitstream/luts1-a6ad27fcf25d/luts1-0.bit &> luts1.fasm
#
cd ../..
#
# do fasm2bel installation
#
#python3.7 -m fasm2bels
#
# OUTPUT: luts1_post.v, pseudo.xdc, test_db
#
python3.7 -mfasm2bels --connection_database test.db --db_root third_party/prjxray/database/zynq7 --fasm_file third_party/prjxray/and_ref/and.fasm --part xc7z010clg400-1 --verilog_file and_post.v --xdc_file pseudo.xdc --allow_orphan_sinks
#
#python3 -mfasm2bels --connection_database test.db --db_root third_party/prjxray/database/kintex7 --fasm_file third_party/prjxray/luts1.fasm --part xc7k70tfbg676-2 --verilog_file luts1_post.v --xdc_file pseudo.xdc --allow_orphan_sinks
#


