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
import pandas as pd



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


def catch_error(filepath, matchfn, db):
    # Get all groups as a tuple
    all_data = matchfn.groups()
    # Or access them individually by index (1-based)
    index_id = matchfn.group(1)  # 1, 2, ... N
    testtype = matchfn.group(2)  # clb|bram|harness|configmem|dsp
    testname = matchfn.group(3)  # luts1,
    serial = matchfn.group(4)    # 00001, 00002, 00003, ... , 0000{Partition #}

    # now access the vivado under -- OUTPUT/family/part/work/27-clb-luts1/build-00000/vivado.log
    parts = list(filepath.parts)
    #db[testtype][testname]['series'].append(serial)

    path1 = index_id + '-' + testtype + '-' + testname
    path2 = 'build' + '-' + serial
    idx = parts.index("OUTPUT")
    new_parts = parts[:idx+3] + ["work", path1 ] + parts[idx + 4:-1] + [path2] + ['vivado.log']
    new_path = Path(*new_parts)
    pattern = '[DRC UTLZ-1]'
    if new_path.exists():
        text = new_path.read_text()
        if pattern in text:
            return(pattern)

    else:
        return("vivado.log file does not exist")

    return('Other')


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
        db[testtype]['fail'] = defaultdict(recursive_dict)
    if not db[testtype][testname]:
        db[testtype][testname] = {'status': 'pass', 'Error': None, 'index': index_id, 'series': []}
    db[testtype][testname]['series'].append(serial)
    flag_fail = 1;
    try:
        with open(filepath, 'r') as f:
            for line in f:
                if "-- write_bitstream --" in line:
                    flag_fail = 0
                    continue
                if 'code_end%' not in line:
                    continue

                #db[testtype][testname]['status'] = 'pass'
                #db[testtype][testname]['Error'] = None
                #flag_fail = 0
    except Exception as e:
        print(f"Error reading {filepath.name} results: {e}")

    if flag_fail == 1 :
        if not db[testtype]['fail'][testname]:
            db[testtype]['fail'][testname] = 0
        db[testtype]['fail'][testname] += 1
        read_qarun.fail_count += 1
        db[testtype][testname]['status'] = 'fail'
        # here process LOG file to give "Error" reason why fail
        db[testtype][testname]['Error'] = catch_error(filepath, matchfn, db)
        print(f"Fail build case:  {filepath.name}")

    return read_qarun.fail_count

def main():

    #print(pd.__version__)
    #sys.exit(0)

    dict_families = {
        "spartan7": [["xc7s6", "cpga196"], ["xc7s100", "fgga676"]]
    }
    # "spartan7": [["xc7s6", "cpga196"], ["xc7s100", "fgga676"]]
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
    # Now, we are pro-processing to count number of failures for each category:
    excel_db = defaultdict(recursive_dict)
    excel_db.update({'X_date':['Result','Fail'], 'Y_name':[], 'Cells':defaultdict(recursive_dict)})
    for family in DB:
        for part in DB[family]:
            excel_db[family][part] = defaultdict(recursive_dict)
            for type in DB[family][part]:
                fail_number = 0
                if DB[family][part][type]['fail']:
                    fail_number = len(DB[family][part][type]['fail'].keys())
                # Remove 'fail' from the testname
                all_testname = {k: v for k, v in DB[family][part][type].items() if k != 'fail'}
                total_number = len(all_testname)
                y_name = family + ":" + part + ":" + type
                excel_db['Y_name'].append(y_name)
                excel_db['Cells'][y_name]['Result'] = f"{fail_number} / {total_number}"
                #excel_db['Cells'][y_name]['Fail'] = "\n".join(DB[family][part][type]['fail'].keys())
                fail_list = DB[family][part][type]['fail'].keys()
                error_list = [DB[family][part][type][i]['Error'] for i in fail_list]
                output_list = [f"{a}::{b}" for a, b in zip(fail_list, error_list)]
                excel_db['Cells'][y_name]['Fail'] = "\n".join(output_list)

    # Lookup the cell status (X-axis), default to 'N/A' if data is missing
    #print(DB)
    #JSON_F = os.path.join(QA_HOME, 'qa_output.json')
    with open(JSON_F, "w") as json_file:
        # 'indent=4' makes the file human-readable (like Data::Dumper's Indent)
        # 'sort_keys=True' keeps the output organized
        json.dump(DB, json_file, indent=4, sort_keys=True)
        print(f"Successfully wrote data to {JSON_F}")

    rows = []
    for name in excel_db["Y_name"]:
        # Initialize row with the Test Name (Y-axis)
        row_data = {"Test Name": name}
        for date in excel_db["X_date"]:
            # Lookup the cell status (X-axis), default to 'N/A' if data is missing
            row_data[date] = excel_db["Cells"].get(name, {}).get(date, "N/A")
        rows.append(row_data)

    # 5. Create a DataFrame and Export to Excel
    df = pd.DataFrame(rows)
    excel_file = os.path.join(QA_HOME, "qa_report.xlsx")

    # Use pd.ExcelWriter to apply custom formatting
    with pd.ExcelWriter(excel_file, engine='xlsxwriter') as writer:
        df.to_excel(writer, sheet_name='FPGA Test Results', index=False)

        workbook = writer.book
        worksheet = writer.sheets['FPGA Test Results']

        # Define a professional header format
        header_fmt = workbook.add_format({
            'bold': True,
            'bg_color': '#D7E4BC',
            'border': 1,
            'align': 'center'
        })

        # Apply the format to headers and adjust column widths
        for col_num, value in enumerate(df.columns.values):
            worksheet.write(0, col_num, value, header_fmt)
            worksheet.set_column(col_num, col_num, 20)

    print(f"Workflow Complete: Created {json_file} and {excel_file}")

    sys.exit(0)

if __name__ == "__main__":
    main()


