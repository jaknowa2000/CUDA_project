import random
import os

def generator(sciezka, liczba_liczb):
    plik = open(sciezka, "wb")
    plik.write(os.urandom(liczba_liczb))
    plik.close()

def main():
    for i in range(100):
        generator("/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts/data/random"+str(i)+".txt", 1000)

main()