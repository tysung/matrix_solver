#! /usr/bin/env python3
# Copyright University of Southern California 2019
#
# DISCLAIMER. USC MAKES NO EXPRESS OR IMPLIED WARRANTIES, EITHER IN FACT OR BY
# OPERATION OF LAW, BY STATUTE OR OTHERWISE, AND USC SPECIFICALLY AND EXPRESSLY
# DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE, VALIDITY OF THE SOFTWARE OR ANY OTHER INTELLECTUAL PROPERTY
# RIGHTS OR NON-INFRINGEMENT OF THE INTELLECTUAL PROPERTY OR OTHER RIGHTS OF ANY
# THIRD PARTY. SOFTWARE IS MADE AVAILABLE AS-IS.
# LIMITATION OF LIABILITY. TO THE MAXIMUM EXTENT PERMITTED BY LAW, IN NO EVENT WILL
# USC BE LIABLE TO ANY USER OF THIS CODE FOR ANY INCIDENTAL, CONSEQUENTIAL, EXEMPLARY
# OR PUNITIVE DAMAGES OF ANY KIND, LOST GOODWILL, LOST PROFITS, LOST BUSINESS AND/OR
# ANY INDIRECT ECONOMIC DAMAGES WHATSOEVER, REGARDLESS OF WHETHER SUCH DAMAGES
# ARISE FROM CLAIMS BASED UPON CONTRACT, NEGLIGENCE, TORT (INCLUDING STRICT LIABILITY
# OR OTHER LEGAL THEORY), A BREACH OF ANY WARRANTY OR TERM OF THIS AGREEMENT, AND
# REGARDLESS OF WHETHER USC WAS ADVISED OR HAD REASON TO KNOW OF THE POSSIBILITY OF
# INCURRING SUCH DAMAGES IN ADVANCE.
#
# Author: Ting-Yuan Sung
#

import glob
import re
import subprocess
import os
import shutil
import time

def rewrite_build(tmp_name, out_name, part_name, f_name):

    out_f = open(out_name, 'w')
    with open(tmp_name, "r") as f:
        newline = []
        for line in f.readlines():
            if re.search('xc7s6cpga196-1', line):
                #spd_part = dict_parts[part][0]
                newline.append("part = \'" + part_name + "\'" + "\n")
            elif re.search('spartan7', line):
                new_str = line.replace("spartan7", f_name)
                newline.append(new_str)
            else:
                newline.append(line)

    newline.append('\n')
    out_f.writelines(newline)
    f.close()
    out_f.close()

    return



def move_logs(source_dir, dest_dir, N):
    #source_dir = r"/path/to/source"
    #dest_dir = r"/path/to/OUTPUT"

    # List only directories in the source directory
    dirs = [
        os.path.join(source_dir, d)
        for d in os.listdir(source_dir)
        if os.path.isdir(os.path.join(source_dir, d))
    ]

    if not dirs:
        print("No build result directories found.")
    else:
        #N = 3  # number of latest dirs to move
        # Find the latest directory by modification time
        # latest_dir = max(dirs, key=os.path.getmtime)
        dirs_sorted = sorted(dirs, key=os.path.getmtime, reverse=True)

        # Select the N newest files
        latest_dirs = dirs_sorted[:N]

        for f in latest_dirs:
            shutil.move(f, dest_dir)
            print(f"Moved: {os.path.basename(f)}")

        # Build destination path (keep same folder name)
        #dest_path = os.path.join(dest_dir, os.path.basename(latest_dir))
        # Move the directory
        #shutil.move(latest_dir, dest_path)
        #print(f"Moved latest directory: {os.path.basename(latest_dir)}")

    return


def main():

    source_dir = r"/nas/home/tsung/CODE/cift-internal_042026/vivado_workspace/logs"
    output_dir = r"/nas/home/tsung/CODE/cift-internal_042026/OUTPUT"
    #
    # xc7s6cpga196-1 xc7s100fgga676-1 == assembly part name used in "spartan7_slice.py" 
    dict_families = {
        "spartan7": [["xc7s6", "cpga196"], ["xc7s100", "fgga676"]]
    }
#        "artix7-vivado":   [["xc7a12t", "cpg238"], ["xc7a75t", "csg324"], ["xc7a200t", "fbg676"]],
#        "kintex7-vivado":  [["xc7k325t", "fbg676"], ["xc7k480t", "ffg901"]],
#        "virtex7-vivado":  [["xc7vx330t", "ffg1157"], ["xc7vh580t", "flg1155"], ["xc7v2000t", "fhg1761"]]

    print (dict_families)

    #return
    # string editing
    families = list(dict_families.keys())
    for i in range(0, len(families)):
        family = families[i]
        parts = dict_families[family]
        for j in range(0, len(parts)):
            # insertion a timer to check run time
            start = time.perf_counter()
            part = parts[j][0]
            pkge = parts[j][1]
            part_name = part + pkge + '-1'
            tmp_name = "tmp_" + "series7_logic" + ".py"
            out_name = "series7_" + "logic" + ".py"
            rewrite_build(tmp_name, out_name, part_name, family)
            #
            #tmp_name = "tmp_" + "spartan7_bram" + ".py"
            #out_name = "spartan7_" + "bram" + ".py"
            #rewrite_build(tmp_name, out_name, part_name, family)
            #try:
            #    output = subprocess.run(['./run'], stdout=subprocess.PIPE)
            #except subprocess.CalledProcessError:
            #    print("ERROR gen_type script")

            family_dir = os.path.join(output_dir, family)
            part_dir = os.path.join(family_dir, part)
            # --- Ensure OUTPUT/family/part exists ---
            os.makedirs(part_dir, exist_ok=True)
            N = 1  # number of latest dirs to move
            move_logs(source_dir, part_dir, N)

            end = time.perf_counter()
            elapsed = end - start
            hours = int(elapsed // 3600)
            minutes = int((elapsed % 3600) // 60) 
            seconds = elapsed % 60
            print("************")
            print(f"{family:^15s} {part:^10s} elapse time: {hours:02d} : {minutes:02d}")
            print("************")
            time.sleep(10)

    return


if __name__ == '__main__':
    main()

