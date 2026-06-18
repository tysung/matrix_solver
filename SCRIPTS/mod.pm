$db_mods = {
    "X_ONE" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O"
      }
    },
    "X_BSCAN_VIRTEX5" => {
      "type" => "seq", 
      "pmap" => {
        "SHIFT" => "I",
        "TDI" => "I",
        "CAPTURE" => "I",
        "SEL" => "I",
        "RESET" => "I",
        "TDO" => "O",
        "UPDATE" => "I",
        "DRCK" => "I"
      }
    },
    "X_BUF" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O",
        "I" => "I"
      }
    },
    "X_SFF" => {
      "type" => "seq", 
      "pmap" => {
        "O" => "O",
        "I" => "I",
        "CE" => "I",
        "SRST" => "I",
        "SSET" => "I",
        "RST" => "S",
        "SET" => "S",
        "CLK" => "C"
      }
    },
    "X_CKBUF" => {
      "type" => "comb", 
      "pmap" => {
        "I" => "I",
        "O" => "O"
      }
    },
    "X_LUT6" => {
      "type" => "comb", 
      "pmap" => {
        "ADR2" => "I",
        "ADR4" => "I",
        "ADR1" => "I",
        "ADR0" => "I",
        "ADR5" => "I",
        "O" => "O",
        "ADR3" => "I"
      }
    },
    "X_SRLC16E" => {
      "type" => "seq", 
      "pmap" => {
        "CE" => "I",
        "Q15" => "O",
        "A1" => "I",
        "Q" => "O",
        "A0" => "I",
        "D" => "I",
        "A3" => "I",
        "A2" => "I",
        "CLK" => "C"
      }
    },
    "X_MUX2" => {
      "type" => "comb", 
      "pmap" => {
        "IB" => "I",
        "IA" => "I",
        "O" => "O",
        "SEL" => "I"
      }
    },
    "X_ROC" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O"
      }
    },
    "X_TOC" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O"
      }
    },
    "X_LUT5" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O",
        "ADR3" => "I",
        "ADR0" => "I",
        "ADR1" => "I",
        "ADR2" => "I",
        "ADR4" => "I"
      }
    },
    "X_CARRY4" => {
      "type" => "comb", 
      "pmap" => {
        "S(3)" => "I",
        "DI(1)" => "I",
        "CO(3)" => "O",
        "S(2)" => "I",
        "O(0)" => "O",
        "O(2)" => "O",
        "O(1)" => "O",
        "S(0)" => "I",
        "DI(2)" => "I",
        "S(1)" => "I",
        "CO(0)" => "O",
        "CYINIT" => "I",
        "CO(1)" => "O",
        "CI" => "I",
        "DI(0)" => "I",
        "O(3)" => "O",
        "DI(3)" => "I",
        "CO(2)" => "O"
      }
    },
    "X_FF" => {
      "type" => "seq", 
      "pmap" => {
        "O" => "O",
        "I" => "I",
        "SET" => "S",
        "CE" => "I",
        "RST" => "S",
        "CLK" => "C"
      }
    },
    "X_ZERO" => {
      "type" => "comb", 
      "pmap" => {
        "O" => "O"
      }
    }
  };
