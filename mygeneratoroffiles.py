import random
import os

def generator(path, number_of_numbers):
    o_file = open(path, "wb")
    o_file.write(os.urandom(number_of_numbers))
    o_file.close()

def main():
    for i in range(1000000):
        generator("../NIST-Statistical-Test-Suite/sts/data/random"+str(i)+".txt", 1000)

main()