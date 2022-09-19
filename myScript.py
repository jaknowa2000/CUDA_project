#!/usr/bin/python3
import subprocess
import sys
import time
from math import fabs
from random import randint

sys.path.insert(1, '/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts/src/myImplementation')
sys.path.insert(1, '/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts')
import myGeneratorofFiles

path_static="0"+"\n"+"/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts/data/my_random.dat"+"\n"+"0"+"\n"+"000010000000000"+"\n"+"10"+"\n"+"1"
test_failed = 0
test_passed = 0

def stats(nist_X, my_X, used_file, n):
    global test_failed
    global test_passed
    if (test_passed % 100 == 0 and test_passed > 0):
        print("Test passed: ", test_passed)
    if (test_failed % 100 == 0 and test_failed > 0):
        print("Test failed: ", test_failed)
    if fabs(nist_X-my_X) > 0.01:
        test_failed += 1
        print("My_X: ", my_X)
        print("NIST_X: ", nist_X)
        print("File: ", used_file)
        print("N: ", n)
        print("\n")
    else:
        test_passed += 1


def test_every_file_new():
    used_file = "my_random.dat"
    for i in range(1000):
        n = str(randint(128, 100000))
        subprocess.run(["python3", "./myGeneratorofFiles.py"])
        my_X = float(subprocess.run(["./script", n, "../../data/my_random.dat", str(1)], capture_output=True).stdout)
        subprocess.run(["./assess", n], input=path_static.encode(), capture_output=True, cwd="/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts")
        nist_X = float(subprocess.run(["cat ../../experiments/AlgorithmTesting/LongestRun/stats.txt | grep Chi^2 | head -1 | cut -f2 -d'='"], shell=True, capture_output=True).stdout)
        stats(nist_X, my_X, used_file, n)


def test_one_file():
    used_file = "my_random.dat"
    for i in range(1000):
        n = str(randint(128, 1000000))
        my_X = float(subprocess.run(["./script", n, "../../data/my_random.dat", str(1)], capture_output=True).stdout)
        subprocess.run(["./assess", n], input=path_static.encode(), capture_output=True,  cwd="/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts")
        nist_X = float(subprocess.run(["cat ../../experiments/AlgorithmTesting/LongestRun/stats.txt | grep Chi^2 | head -1 | cut -f2 -d'='"], shell=True, capture_output=True).stdout)
        stats(nist_X, my_X, used_file, n)


def test_nist_files():
    nist_files = ["BBS.dat", "data.e", "data.sha1", "data.sqrt3", 
                    "data.bad_rng", "data.pi", "data.sqrt2"]
    for nist_file in nist_files:
        path_dynamic = "0"+"\n"+"/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts/data/"+nist_file+"\n"+"0"+"\n"+"000010000000000"+"\n"+"10"+"\n"+"1"
        for i in range(1000):
            n = str(randint(128, 1000000))
            my_X = float(subprocess.run(["./script", n, "../../data/"+nist_file, str(1)], capture_output=True).stdout)
            subprocess.run(["./assess", n], input=path_dynamic.encode(), capture_output=True, cwd="/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts")
            nist_X = float(subprocess.run(["cat ../../experiments/AlgorithmTesting/LongestRun/stats.txt | grep Chi^2 | head -1 | cut -f2 -d'='"], shell=True, capture_output=True).stdout)
            stats(nist_X, my_X, nist_file, n)


def main():

    subprocess.run(["g++", "./main.cpp", "./files_service.cpp", "./show_data.cpp", "u_tests.cpp", "myLROO.cpp", "-o", "script"])
    start = time.time()

    test_every_file_new()
    test_one_file()
    test_nist_files()

    stop = time.time()

    print("Test passed: ", test_passed)
    print("Test failed: ", test_failed)
    print("Measured time of a working program", stop-start)

main()