import random
import os

def generator(path, number_of_numbers):
    o_file = open(path, "wb")
    o_file.write(os.urandom(number_of_numbers))
    o_file.close()

def main():
        generator("../NIST-Statistical-Test-Suite/sts/data/my_random.dat", 200000)

main()