import random

def generator(sciezka, liczba_liczb):
    plik = open(sciezka, "w")
    for i in range(liczba_liczb):
        plik.write(chr(random.randrange(0,257,1)))
    plik.close()

def main():
    generator("/home/jnowakowski/domowy/NIST-Statistical-Test-Suite/sts/data/my_random.dat", 1000000)

main()