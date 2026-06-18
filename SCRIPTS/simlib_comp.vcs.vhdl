mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/altera
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_syn_attributes.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_standard_functions.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/alt_dspbuilder_package.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_europa_support_lib.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_primitives_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_primitives.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/lpm
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work lpm /opt/intel/quartus/21.4/quartus/eda/sim_lib/220pack.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work lpm /opt/intel/quartus/21.4/quartus/eda/sim_lib/220model.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/sgate
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work sgate /opt/intel/quartus/21.4/quartus/eda/sim_lib/sgate_pack.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work sgate /opt/intel/quartus/21.4/quartus/eda/sim_lib/sgate.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/altera_mf
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera_mf /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_mf_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera_mf /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_mf.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/altera_lnsim
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work altera_lnsim /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_lnsim.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work altera_lnsim /opt/intel/quartus/21.4/quartus/eda/sim_lib/altera_lnsim_components.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/tennm
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work tennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/tennm_atoms_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/tennm_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/tennm_components.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/tennm_hssi_all
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/tennm_hssi_atoms_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/cr3v0_serdes_models_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/tennm_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/tennm_hssi_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ctp_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work tennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ctp_hssi_atoms.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/twentynm
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work twentynm /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/twentynm_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_components.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/twentynm_hssi
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work twentynm_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/twentynm_hssi_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_hssi_atoms.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/twentynm_hip
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work twentynm_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/twentynm_hip_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_hip_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work twentynm_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/twentynm_hip_atoms.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/cyclone10gx
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work cyclone10gx /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/cyclone10gx_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_components.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/cyclone10gx_hssi
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work cyclone10gx_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/cyclone10gx_hssi_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx_hssi /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_hssi_atoms.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/cyclone10gx_hip
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan  -nc -work cyclone10gx_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/cyclone10gx_hip_atoms_ncrypt.v 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_hip_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work cyclone10gx_hip /opt/intel/quartus/21.4/quartus/eda/sim_lib/cyclone10gx_hip_atoms.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/diamondmesa_lib
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/fourteennm
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work fourteennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/fourteennm_atoms_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/fourteennm_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm /opt/intel/quartus/21.4/quartus/eda/sim_lib/fourteennm_components.vhd 
mkdir -p /nas/home/tsung/CODE/stratix_cift-internal/work/VCS_SIM/XXX/vhdl_libs/fourteennm_hssi_all
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ct1_hssi_atoms_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vlogan -sverilog -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/synopsys/cr3v0_serdes_models_ncrypt.sv 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ct1_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ct1_hssi_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ct1_hip_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ct1_hip_atoms.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ctp_hssi_components.vhd 
/export/tools/synopsys/L-2016.06-SP1/bin/vhdlan  -nc -work fourteennm_hssi_all /opt/intel/quartus/21.4/quartus/eda/sim_lib/ctp_hssi_atoms.vhd 
