import random
import os

def generator(sciezka, liczba_liczb):
    plik = open(sciezka, "wb")
    plik.write(os.urandom(liczba_liczb))
    plik.close()

def main():
        generator("../NIST-Statistical-Test-Suite/sts/data/my_random.dat", 200000)

main()