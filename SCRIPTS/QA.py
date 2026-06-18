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


def main():

    py_files = {}
    for file in glob.glob("build-tests-*-script.py"):
        words = file.split('-')
        words[4] = 'ift-tgc'
        tgc = '-'.join(words[:-1]) + '.ift-tgc'
        py_files[file] = tgc

    print (py_files)

    # string editing
    for file in sorted(py_files):
        tgc = py_files[file]
        out_f = open(tgc, 'w')
        with open(file, "r") as f:
            newline = []
            for word in f.readlines():
                if re.search('tg.build', word):
                    newline.append("tg.write(mytg, file=\'" + tgc + "\'" + ", overwrite=True)")
                else:
                    newline.append(word)

        out_f.writelines(newline)
        f.close()
        out_f.close()

        try:
            output = subprocess.run(['./ift', '--batch', f'{tgc}'], stdout=subprocess.PIPE)
        except subprocess.CalledProcessError:
            self.statusbar.showMessage("ERROR gen_type script")


    return


if __name__ == '__main__':
    main()

