#! /usr/bin/env python3
import os
import sys
import subprocess
import shutil
from datetime import datetime
import re
from pathlib import Path
from collections import defaultdict
import json


QA_HOME = "/nas/home/tsung/CODE/cift-internal_042026"
JSON_F = os.path.join(QA_HOME, 'qa_output.json')

# This function allows for infinite nesting
def recursive_dict():
    return defaultdict(recursive_dict)

# This tells Python: "If a key is missing, automatically make it a dict"
DB = recursive_dict()
#DB = {}

def shell_exec(command, capture=True):
    """Helper to run shell commands and return output or exit code."""
    try:
        if capture:
            result = subprocess.run(command, shell=True, capture_output=True, text=True)
            return result.stdout.strip()
        else:
            return subprocess.run(command, shell=True).returncode
    except Exception as e:
        print(f"Command failed: {command}\n{e}")
        return None

def setup_environment():
    # Update PATH
    os.environ['PATH'] = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin:" + os.environ.get('PATH', '')

def read_golden(filepath, db):
    db['golden'] = {}
    if not os.path.exists(filepath):
        return

    # Using grep-like logic via Python
    try:
        with open(filepath, 'r') as f:
            for line in f:
                if "has passed" in line:
                    match = re.search(r'^(.*?): info:(.*) has passed$', line.strip())
                    if match:
                        file_line, func_parm = match.groups()
                        file_line = file_line.strip()
                        func_parm = func_parm.strip()

                        fl_match = re.search(r'^(.+)\((\d+)\)$', file_line)
                        if fl_match:
                            file, ln = fl_match.groups()
                            if file not in db['golden']:
                                db['golden'][file] = {}
                            db['golden'][file][ln] = func_parm
    except Exception as e:
        print(f"Error reading golden file: {e}")

def read_qarun(filepath, matchfn, db):

    if not hasattr(read_qarun, "fail_count"):
        read_qarun.fail_count = 0

    if not os.path.exists(filepath):
        return 0

    # Get all groups as a tuple
    all_data = matchfn.groups()
    # Or access them individually by index (1-based)
    index_id = matchfn.group(1)  # 1, 2, ... N
    testtype = matchfn.group(2)  # clb|bram|harness|configmem|dsp
    testname = matchfn.group(3)  # luts1,
    serial = matchfn.group(4)    # 00001, 00002, 00003, ... , 0000{Partition #}
    if not db[testtype]['fail']:
        db[testtype]['fail'] = []
    if not db[testtype][testname]:
        db[testtype][testname] = {'status': 'fail', 'Error': 'Error', 'index': index_id, 'series': [serial]}
    flag_fail = 1;
    try:
        with open(filepath, 'r') as f:
            for line in f:
                if "-- write_bitstream --" not in line:
                    continue
                if 'code_end%' not in line:
                    continue

                db[testtype][testname]['status'] = 'pass'
                db[testtype][testname]['Error'] = None
                flag_fail = 0
    except Exception as e:
        print(f"Error reading {filepath.name} results: {e}")

    if flag_fail == 1 :
        db[testtype]['fail'].append(filepath.name)
        read_qarun.fail_count += 1
        print(f"Fail build case:  {filepath.name}")

    return read_qarun.fail_count

def main():

    dict_families = {
        "spartan7": [["xc7s6", "cpga196"], ["xc7s100", "fgga676"]]
    }
    # "artix7-vivado":   [["xc7a12t", "cpg238"], ["xc7a75t", "csg324"], ["xc7a200t", "fbg676"]],
    # "kintex7-vivado":  [["xc7k325t", "fbg676"], ["xc7k480t", "ffg901"]],
    # "virtex7-vivado":  [["xc7vx330t", "ffg1157"], ["xc7vh580t", "flg1155"], ["xc7v2000t", "fhg1761"]]

    setup_environment()

    # Check for existing repo and update
    target_dir = f"{QA_HOME}/OUTPUT"
    if os.path.exists(target_dir):
        os.chdir(target_dir)

    fail_number = -1
    families = list(dict_families.keys())
    for i in range(0, len(families)):
        family = families[i]
        parts = dict_families[family]
        for j in range(0, len(parts)):
            #
            part = parts[j][0]
            print(f"***** '{family}' / '{part}' check run result *****", flush=True)
            #DB[family][part] = {}
            family_dir = os.path.join(target_dir, family)
            part_dir = os.path.join(family_dir, part)
            # --- Ensure OUTPUT/family/part exists ---
            if not os.path.exists(part_dir):
                print(f"Error: The directory '{part_dir}' does not exist.")
                sys.exit(1)

            part_dir = Path(part_dir)
            subdirs = [d for d in part_dir.iterdir() if d.is_dir()]
            # 3. Find the one with the maximum modification time
            # d.stat().st_mtime returns the timestamp of the last modification
            latest_subdir = max(subdirs, key=lambda d: d.stat().st_mtime)

            # Matches anything, followed by -build-, followed by 5 digits and .log
            # More restrictive: Starts with digits, hyphen, then anything, then -build-
            pattern = re.compile(r"^(\d+)-(clb|bram|harness|cfgmem|dsp)-(.*)-build-(\d{5})\.log$")
            # Check directory exists
            if not latest_subdir.is_dir():
                print(f"Error: Path {latest_subdir} not found.")
            else:
                # Filter files in the directory
                matched_files = [
                    f for f in latest_subdir.iterdir()
                    if f.is_file() and pattern.match(f.name)
                ]
            os.chdir(latest_subdir)
            # Print results
            #print(f"Found {len(matched_files)} matching log files:")
            for file in sorted(matched_files):
                match = pattern.match(file.name)
                if not match:
                    continue

                #print(f" - {file.name}")
                #if not isinstance(DB[family][part], defaultdict):
                if not DB[family][part]:
                    DB[family][part] = defaultdict(recursive_dict)
                fail_number = read_qarun(file, match, DB[family][part])
            filename = family + '_' + part + '_qa.json'
            js_f = os.path.join(part_dir, filename)
            with open(js_f, "w") as json_file:
                json.dump(DB[family][part], json_file, indent=4, sort_keys=True)

            print(f"----- Finish Check on part '{part}'  -----\n", flush=True)

    #os.chdir("today")
    print(f"Number of failure build case is  {fail_number}")
    #print(DB)
    #JSON_F = os.path.join(QA_HOME, 'qa_output.json')
    try:
        with open(JSON_F, "w") as json_file:
            # 'indent=4' makes the file human-readable (like Data::Dumper's Indent)
            # 'sort_keys=True' keeps the output organized
            json.dump(DB, json_file, indent=4, sort_keys=True)
        print(f"Successfully wrote data to {JSON_F}")
    except Exception as e:
        print(f"An error occurred while writing: {e}")

    sys.exit(0)

if __name__ == "__main__":
    main()


