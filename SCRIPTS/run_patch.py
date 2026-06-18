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

def rewrite_build(tmp_name, out_name, part, part_name):

    out_f = open(out_name, 'w')
    with open(tmp_name, "r") as f:
        newline = []
        for line in f.readlines():
            if re.search('AGFA006R16A2E1V', line):
                #spd_part = dict_parts[part][0]
                newline.append("part = \'" + part_name + "\'" + "\n")
            elif re.search('agfa006r16a', line):
                new_str = line.replace("agfa006r16a", part)
                newline.append(new_str)
            else:
                newline.append(line)

    newline.append('\n')
    out_f.writelines(newline)
    f.close()
    out_f.close()

def rewrite_qsf(tmp_name, out_name, pin_name):

    out_f = open(out_name, 'w')
    with open(tmp_name, "r") as f:
        newline = []
        for line in f.readlines():
            if re.search('PIN_CK33', line):
                new_str = line.replace("PIN_CK33", pin_name)
                newline.append(new_str)
            else:
                newline.append(line)

    out_f.writelines(newline)
    f.close()
    out_f.close()


def main():

    archs = ["slice", "bram"]
    # Define a list across several lines
    dict_parts = {
        "agfa012r24b": ["AGFA012R24B1E1V", "CR24"],
        "agfb014r24b": ["AGFB014R24B2E2V", "CU10"],
        "agfa019r24c": ["AGFA019R24C2E1V", "DF10"],
        "agfa022r24c": ["AGFA022R24C2E1V", "DF10"],
        "agfa023r24c": ["AGFA023R24C2E1V", "DF10"],
        "agfa027r24c": ["AGFA027R24C2E1V", "DF10"],
        "agid019r31b": ["AGID019R31B1E1V", "DM17"],
        "agib022r31b": ["AGIB022R31B1E1V", "DM17"],
        "agib023r31b": ["AGIB023R31B1E1V", "DM17"],
        "agib027r31b": ["AGIB027R31B1E1V", "DM17"],
        "agia035r39a": ["AGIA035R39A1E1VB", "EF24"],
        "agia040r39a": ["AGIA040R39A1E1VB", "EF24"],
        "agia041r31b": ["AGIA041R31B1E1VB", "DM17"]
    }

    qsf_dict = {}
    for part in dict_parts:
        directory = "interfaces/intel/agilex/" + part
        if not os.path.exists(directory):
            os.makedirs(directory)
        #tgc = '-'.join(words[:-1]) + '.ift-tgc'
        qsf_file = part + ".qsf"
        qsf = directory + '/' + qsf_file
        qsf_dict[part] = qsf
        dict_parts[part].append(qsf)

    #print (qsf_dict)
    print (dict_parts)

    #return

    # string editing
    parts = list(dict_parts.keys())
    for i in range(0, len(parts), 4):
        processes = []
        for j in range(0, 4):
            if i+j < len(parts):
                part = parts[i+j]
                tmp_name = "tmp_" + "agilex7_slice" + ".py"
                out_name = "agilex7_" + "slice" + str(j+1) + ".py"
                cmd_name = './' + "run" + str(j+1)
                part_name = dict_parts[part][0]
                rewrite_build(tmp_name, out_name, part, part_name)

                try:
                    p = subprocess.Popen(cmd_name, shell=True, stdout=subprocess.PIPE)
                    processes.append(p)
                except subprocess.CalledProcessError:
                    print("ERROR gen_type script")

        #results = [p.communicate()[0].strip() for p in processes]
        #print(results)

        for p in processes:
            p.wait()



    return


if __name__ == '__main__':
    main()

