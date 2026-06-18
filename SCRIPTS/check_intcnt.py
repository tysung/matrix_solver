#!/usr/bin/env python3
#
import glob
import re
import subprocess
import os
import shutil
import json
from datetime import datetime
from pathlib import Path
#from excel.excel import write_all_excel


############################
# collect_result 
############################

class Tile:
    instances = {}

    def __new__(cls, *args):
        if args[0] in cls.instances:
            return cls.instances[args[0]]
        self = super().__new__(cls)
        cls.instances[args[0]] = self
        return self

    def __init__(self, name):
        self.name = name



class Pip:
    instances = {}

    def __new__(cls, *args):
        if args in cls.instances:
            return cls.instances[args][0]
        self = super().__new__(cls)
        cls.instances[args] = [self, 0]
        return self

    def __init__(self, tile, bgn, end):
        self.tile = tile 
        self.bgn = bgn 
        self.end = end 

    def find_pips(self, pips):
        if self in pips:
            return True
        return False


############################
#
# collect_build 
#
############################
class CollectBuild:

    py_files = {}
    counter = 0

    def __init__(self, qa_home):
        self.run_dir = qa_home

    def pip_report (self):
        target_pip_number = 0
        for drtry in CollectBuild.py_files:
            target_pip_number = target_pip_number + len(CollectBuild.py_files[drtry]['pip'])

        total_pip_number = len(Pip.instances.keys())
        use_pip_number = 0
        for pip in Pip.instances.keys():
            use_pip_number = use_pip_number + Pip.instances[pip][1]

        print("*************************")
        print("* FUNC - pip_report() *  ")
        print(f'* Total_Pip_Number {total_pip_number}, Target_Pip_Number {target_pip_number}, Use_Pip_Number {use_pip_number}')
        print("*************************")            



    def build_calc (self):
        print("*************************")
        print("* FUNC - build_calc() *")
        print("*************************")

        os.chdir(self.run_dir)

        #os.chdir('today/cosmic-canary/output')
        for drtry in glob.glob("build-*"):
            os.chdir(drtry)
            result = glob.glob("results.txt")
            pip = glob.glob("pips-*")
            #words = file.split('.')
            #test = words[0] 
            CollectBuild.py_files[drtry] = {'result': result, 'pip': pip}
            pip_data = self.read_pips(pip[0])
            CollectBuild.counter = CollectBuild.counter + 1
            result_data = self.read_result(result[0], pip_data, CollectBuild.counter)
            CollectBuild.py_files[drtry] = {'result': result_data, 'pip': pip_data}
            #
            #os.chdir("DB")
            with open("pip_data.json", "w") as outfile:
                json.dump(result_data, outfile, indent=4)
            outfile.close()
            os.chdir('..')
            #
        print (CollectBuild.py_files)
        #return(py_files)


    def read_pips(self, pip_file):
        with open(pip_file, "r") as f:
            lines = f.read().splitlines()
        f.close()
        array1 = []
        #data_3.sort(key=int)
        for line in lines:
            data = line.split()
            tile_name = data[0]
            bgn = data[1]
            end = data[2]
            tile = Tile(tile_name)
            pip = Pip(tile, bgn, end) 
            array1.append(pip)
       
        return array1

    def read_result(self, result_file, pip_data, counter):

        found_pips = {}
        outf_name = 'result_' + str(counter)
        outf = open(outf_name, "w")

        with open(result_file, "r") as f:
            lines = f.read().splitlines()
        f.close()
        array1 = []
        # data_3.sort(key=int)
        for line in lines:
            data = line.split()
            tile_name = data[0]
            bgn = data[1]
            end = data[2]
            tile = Tile(tile_name)
            pip = Pip(tile, bgn, end)
            array1.append(pip)
            flag = pip.find_pips(pip_data)
            if flag == True:
                outf.write("Found pip - %s\n" % line)
                found_pips[line] = True
                Pip.instances[(tile, bgn, end)][1] = Pip.instances[(tile, bgn, end)][1] + 1
            else:
                outf.write("Not Found pip - %s\n" % line)
                found_pips[line] = False

        outf.close()

        return found_pips



############################
#
# main program  
#
############################
def main():

    QA_HOME = "/nas/home/tsung/CODE/sp6_cift-internal/work/new_v7_intcnt"
    #QA_HOME = "/nas/home/tsung/CODE/sp6_cift-internal/work/2021-09-17T12-38-52/1-interconnect"

    CB = CollectBuild(QA_HOME)
    CB.build_calc()
    CB.pip_report()

    #pip_data = collect_output(build_files)

    #sort_pip(pip_data)

    #dcp_files = collect_dcps()

    return

if __name__ == '__main__':
    main()

