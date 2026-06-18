#!/home/tsung/Canary_QA/venv/bin/python3.6

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
import json
from datetime import datetime
from excel.excel import write_all_excel, read_db, write_all_xml_excel, write_report_excel
import xml.etree.ElementTree as ET

global_step_begin = 2 # skip git clone step 
#global_step_begin = 1
#global_step_begin = 8

############################
#
# collect_dcps 
#
############################
def collect_dcps():

    py_files = {}
    if global_step_begin > 5:
       return(None)
    print("*************************")
    print("* FUNC - collect_dcps() *")
    print("*************************")

    os.chdir('today/cosmic-canary/output')
    for file in glob.glob("*.dcp"):
        words = file.split('.')
        test = words[0] 
        py_files[file] = {'test': test} 

    os.chdir('../../..')

    print (py_files)

    return(py_files)

############################
#
# run unit test 
#
############################
def run_unit_test(env_set):

    if global_step_begin > 4:
       return
    print("**************************")
    print("* FUNC - run_unit_test() *")
    print("**************************")

    try:
        os.chdir('today/cosmic-canary/build')
        subprocess.run(['make', 'unit_test'], env=env_set)
        #output = subprocess.run(['make', 'unit_test'], stdout=subprocess.PIPE)
        os.chdir('../../..')
    except subprocess.CalledProcessError:
        print("ERROR: run_unit_test")

    return


############################
# git clone repo
############################
def make_git_repo(QA_HOME):

    if global_step_begin > 1:
       return
    print("**************************")
    print("* FUNC - make_git_repo() *")
    print("**************************")
    try:
        output = subprocess.run(['rm', '-rf', 'today/cosmic-canary'], stdout=subprocess.PIPE)
        #os.mkdir('today')
        os.chdir('today')
        subprocess.run(['git', 'clone', 'https://tsung-ext@depot.ctisl.gtri.gatech.edu/canary/cosmic-canary.git'])
        os.chdir('cosmic-canary')
        subprocess.run(['git', 'fetch', 'origin'])
        subprocess.run(['git', 'checkout', '-b', 'reduced-instance-canary-checking', 'origin/reduced-instance-canary-checking'])
        os.chdir('..')
        rapid_wr = QA_HOME + '/RapidWright_data'
        subprocess.run(['ln', '-s', rapid_wr, 'cosmic-canary/RapidWright/data'])
        os.chdir('..')
    except subprocess.CalledProcessError:
        print("ERROR: git clone repo")
    

    return

############################
#
# cmake build  
#
############################
def cmake_build_repo(env_set):

    if global_step_begin > 3:
       return

    print("*****************************")
    print("* FUNC - cmake_build_repo() *")
    print("*****************************")
    try:
        os.chdir('today/cosmic-canary')
        if os.path.isdir('build'): 
            shutil.rmtree('build')
        os.mkdir('build')
        os.chdir('build')

        #subprocess.run(['cmake', '..'], env=env_set)
        subprocess.run(['cmake', '-DINSTALL_DIR=USER', '..'], env=env_set)
        subprocess.run(['make', 'install'], env=env_set)
        #subprocess.run(['make', '-B', 'install'], env=env_set)
        os.chdir('../../..')

    except subprocess.CalledProcessError:
        print("ERROR: cmake .. ")
    

    return


############################
# vivado_access 
############################
def vivado_access(dcp_files, env_set):

    if global_step_begin > 6:
       return
    print("**************************")
    print("* FUNC - vivado_access() *")
    print("**************************")

    try:
        os.chdir('today/cosmic-canary/output')
        if os.path.isdir('RESULT'): 
            shutil.rmtree('RESULT')
        os.mkdir('RESULT')
        for file in sorted(dcp_files.keys()):
            print(f'Process file - {file} ')
            subprocess.run(['vivado', '-mode', 'batch', '-source', '../../../report_util.tcl', f'{file}'], env=env_set)
            out_file = 'RESULT/' + dcp_files[file]['test'] + '.report'
            dcp_files[file]['result'] = out_file
            os.rename('vivado_canary.report', out_file)

        os.chdir('../../..')

    except subprocess.CalledProcessError:
        print("ERROR: vivado utilization ")
    

    return


############################
# collect_result 
############################
class Resource:
    luts: int = 0
    regs: int = 0
    carry8: int = 0
    dsps: int = 0
    iob: int = 0
    c_buf: int = 0

    def __init__(self, luts, regs, carry8, dsps, iob, c_buf):
        self.luts = luts
        self.regs = regs 
        self.carry8 = carry8
        self.dsps = dsps 
        self.iob = iob 
        self.c_buf = c_buf 

    def add_luts(self, lut_num):
        self.luts = self.luts + lut_num

    def jsonify(self):
        value = dict(self.__dict__)
        #val_json = json.loads(value)
        val_json = json.dumps(value)
        print(val_json)
        return(val_json)

    def dump(self):
        value = dict(self.__dict__)
        return(value)


def collect_result(dcp_files):

    if global_step_begin > 7:
       return
    print("***************************")
    print("* FUNC - collect_result() *")
    print("***************************")

    #rce = Resource()
    os.chdir('today/cosmic-canary/output')
    for file in sorted(dcp_files.keys()):
        result = dcp_files[file]['result']
        blocks = subprocess.run(['grep', '-n', "^[0-9]", result], stdout=subprocess.PIPE)
        data_1 = blocks.stdout.splitlines()
        data_2 = list(map(lambda it: it.decode(), data_1)) # convert byte to string
        match_l = list(filter(lambda it: re.search('Instantiated Netlists', it), data_2))
        begin = int(match_l[0].split(':')[0])
        end   = int(match_l[1].split(':')[0])
        # collection line number from data_2 and sort it out
        data_3 = list(map(lambda it: it.split(':')[0], data_2))
        data_3 = [int(x) for x in data_3]
        #lines = [line.strip() for line in f=open(result, "r")]
        with open(result, "r") as f:
            lines = f.read().splitlines()
        f.close()
        j = 0
        array1 = []
        #data_3.sort(key=int)
        for i, val in enumerate(data_3):
            if val <= begin: 
                continue

            next_val = data_3[i+1]
            array1.append(lines[val-1:next_val-1])

            if next_val == end:
                break

        #out_f.writelines(newline)
        #out_f.close()
        #
        # grep the number from each array1[] items
        #
        match_l = list(filter(lambda it: re.search('CLB LUTs', it), array1[0]))
        luts = match_l[0].split('|')[2]
        match_l = list(filter(lambda it: re.search('CLB Registers', it), array1[0]))
        regs = match_l[0].split('|')[2]
        match_l = list(filter(lambda it: re.search('CARRY8', it), array1[0]))
        carry8 = match_l[0].split('|')[2]
        match_l = list(filter(lambda it: re.search('DSPs', it), array1[3]))
        dsps = match_l[0].split('|')[2]
        match_l = list(filter(lambda it: re.search('Bonded IOB', it), array1[4]))
        iob = match_l[0].split('|')[2]
        match_l = list(filter(lambda it: re.search('GLOBAL CLOCK BUFFERs', it), array1[5]))
        c_buf = match_l[0].split('|')[2]
        rce = Resource(luts, regs, carry8, dsps, iob, c_buf)
        dcp_files[file]['resource'] = rce.dump()
        #dcp_files[file]['resource'] = rce.jsonify()
        
    os.chdir('../../..')
    # save data in JSON file
    os.chdir("DB")
    with open("all_data.json", "w") as outfile:
        json.dump(dcp_files, outfile, indent = 4)
    outfile.close()
    os.chdir('..')

    return

############################
# setup_xilinx 
############################
def setup_xilinx(XIL_TOOL, CANARY_REPO):

    if global_step_begin > 2:
       return
    print("*************************")
    print("* FUNC - setup_xilinx() *")
    print("*************************")


    def _source(script):
        """
        CIFT:/code/main/ift/utils/xilinx_tools.py
        """

        env = {}
        env.update(os.environ)

        proc = subprocess.Popen(
            ['bash', '-c', 'set -a && source {} && env -0'.format(script)],
            stdout=subprocess.PIPE, shell=False)
        output, err = proc.communicate()
        output = output.decode('utf8')
        sourced_env = dict((line.split("=", 1) for line in output.split('\x00') if line))
        env.update(sourced_env)
        return env


    #def xilrun(*args, env: Optional[Environment] = None, **kwargs):
    #    if env is None:
    #        env = Environment.XILINX_ISE_ENV
    #    penv = XILINX_ENVIRONMENT[env]
    #    return subprocess.run(*args, env=penv, **kwargs)


    settings = os.path.join(XIL_TOOL, 'settings64.sh')
    env = _source(settings)
    env['COSMIC_CANARY_PATH'] = CANARY_REPO
    #print(env)

    return env

def generate_report_db(dcp_files):
    if global_step_begin > 8:
       return
    print("*******************************")
    print("* FUNC - generate_report_db() *")
    print("*******************************")

    if dcp_files == None:
        db_file = 'DB/all_data.json' 
        with open(db_file) as f:
            dcp_files = json.load(f)
        f.close()

    db = {'X_rsce':[], 'Y_name':[], 'Cells':{}}
    db['Y_name'] = sorted(dcp_files.keys())
    for y_name in sorted(dcp_files.keys()):
        rsce = dcp_files[y_name]['resource']
        # fill the X_rsce with any resource obj
        if len(db['X_rsce']) == 0:
            db['X_rsce'] = sorted(rsce.keys())
        db['Cells'][y_name] = rsce

    os.chdir('DB')
    with open("db.json", "w") as outfile:
        json.dump(db, outfile, indent = 4)
    outfile.close()
    os.chdir('..')

def db_group(dcp_files):

    db = {} # key: option_name
    for Y_name in (sorted(dcp_files.keys())):
        m = re.match(r'(.*)\.(synth.dcp)', Y_name)
        name = m.group(1)
        #f_wrapper = -1
        f_wrapper = re.search('wrapper', name)
        if f_wrapper:
            option_name = name[:f_wrapper.start()-1]
            option_vlue = name[f_wrapper.end()+1:]
        else:
            words = re.split("_", name)
            option_name = "_".join(words[:-1])
            option_vlue = "_".join(words[-1:])
        #print(f'option_name = {option_name}, option_vlue = {option_vlue}')
        if option_name not in db:
            db[option_name] = {}
        if Y_name not in db[option_name]:
            db[option_name][Y_name] = {'resource':dcp_files[Y_name]['resource'], 'name': name, 'value':option_vlue, 'wrapper':f_wrapper!=None}

    return(db)



def compare_golden(qa_golden_dir, today_db_f, golden_db_f):
    pwd = os.getcwd()
    os.chdir(qa_golden_dir)

    today_db  = read_db(today_db_f, 'X_rsce')
    golden_db = read_db(golden_db_f, 'X_rsce')
    db = {'Y_name':[], 'Cells':{}}
    db['Y_name'] = list(set(today_db['Y_name'] + golden_db['Y_name']))
    for y_name in db['Y_name']:
        if y_name not in db['Cells']:
            db['Cells'][y_name] = {}
        db['Cells'][y_name] = 'NewNone'

    #if len(today_db['Y_name']) != len(golden_db['Y_name']):
    db['Cells'] = { y_name : db['Cells'][y_name].replace("New", "")  for y_name in golden_db['Y_name'] }
    db['Cells'] = { y_name : db['Cells'][y_name].replace("None", "") for y_name in today_db['Y_name'] }
    #for y_name in today_db['Y_name']:
    #    db['Cells'][y_name][date] = db['Cells'][y_name][date].replace("None", "")

    f_fail = 0
    filtered = filter(lambda Y: Y in today_db['Y_name'] and Y in golden_db['Y_name'], db['Y_name'])
    for y_name in filtered:
        db['Cells'][y_name] = 'Pass'
        for x_rsce in golden_db['X_rsce']:
            if today_db['Cells'][y_name][x_rsce] != golden_db['Cells'][y_name][x_rsce]:
                f_fail = 1
                db['Cells'][y_name] = 'Fail'
                st1 = today_db['Cells'][y_name][x_rsce].strip()
                st2 = golden_db['Cells'][y_name][x_rsce].strip()
                today_db['Cells'][y_name][x_rsce] = "Fail: " + st1 + '(' + st2 + ')'

    # re-write failure data to "db.json"
    if f_fail == 1:
        with open("db.json", "w") as outfile:
            json.dump(today_db, outfile, indent = 4)
        outfile.close()

    os.chdir(pwd)

    return(db)

def read_xml(xml_f):

    db = {} # db[syn_opt][type_opt] similar to db_group
    # JUnit output .xml file
    tree = ET.parse(xml_f)
    root = tree.getroot()
    ts_fail = root.findall('testcase/error')
    for ts in root.findall('testcase'):
        type_opt = ts.get('name')
        syn_opt = ts.get('classname')
        if syn_opt not in db:
            db[syn_opt] = {}
        if type_opt not in db[syn_opt]:
            db[syn_opt][type_opt] = 'Pass'

        for fail in ts.findall('failure'):
            fail_type = fail.get('type')
            fail_msg = fail.get('message')
            db[syn_opt][type_opt] = 'Fail: ' + fail_type

        for error in ts.findall('error'):
            error_type = error.get('type')
            error_msg = error.get('message')
            db[syn_opt][type_opt] = 'Error: ' + error_type

    with open('Golden/db.json', "w") as outfile:
        json.dump(db, outfile, indent = 4)
    outfile.close()

    return(db)



def generate_excel():
    if global_step_begin > 9:
       return()
    print("***************************")
    print("* FUNC - generate_excel() *")
    print("***************************")
    #if dcp_files == None:
    #    db_file = 'DB/all_data.json'
    #    with open(db_file) as f:
    #        dcp_files = json.load(f)
    #    f.close()

    date = datetime.now().strftime("%m-%d-%Y")
    today_excel = date + '_db.xlsx'

    # JUnit output .xml file
    xml_f = 'today/cosmic-canary/logs/TEST-junit-jupiter.xml'
    if os.path.exists(xml_f):
        xml_db = read_xml(xml_f)
        write_all_xml_excel(today_excel, date, xml_db)
    else:
        print(f'ERROR: {xml_f} does not exists !!!  ')



    write_report_excel('./DB', today_excel, "db.json")
    # top level report: fail/pass and failure numbers
    #rpt_db = compare_golden('./DB', "db.json", "golden.json")
    #write_all_excel(dcp_files, today_excel, date, rpt_db)



############################
#
# main program  
#
############################
def main():

    QA_HOME = "/home/tsung/Canary_QA"
    XIL_TOOL = "/opt/Xilinx/Vivado/2019.2"

    os.chdir(QA_HOME)
    make_git_repo(QA_HOME)

    # create environment variable for Vivado run path
    CANARY_REPO = QA_HOME + '/today/cosmic-canary'
    env_set = setup_xilinx(XIL_TOOL, CANARY_REPO)

    cmake_build_repo(env_set)

    run_unit_test(env_set)

    dcp_files = collect_dcps()

    vivado_access(dcp_files, env_set)

    collect_result(dcp_files)

    generate_report_db(dcp_files)

    generate_excel()
    #generate_excel(dcp_files)

    return

if __name__ == '__main__':
    main()

