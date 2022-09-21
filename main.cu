#include <iostream>  
#include <vector>
#include <string>

#include "u_tests.h"
#include "files_service.h"
#include "show_data.h"
#include "cuda_service.h"

using namespace std;

int main(int argc, char** argv) {
    int objective;
    objective=strtol(argv[1], NULL, 10);
    int n;
    if (objective == 1){
        n=strtol(argv[3], NULL, 10);
        vector<char> data = read_file(argv[2]);
        double X = myLongestRunOfOnes(n, data);
        printf("%f", X);
    }
    else if (objective == 2){
        tests();
        vector<char> data = read_file(argv[2]);
        n = strtol(argv[3], NULL, 10);
        double X = myLongestRunOfOnes(n, data);
        printf("\nDLA DANYCH WEJSCIOWYCH FUNKCJA X^2 WYNOSI: %f\n", X);
        print_data(n, data);
        extract_bits(n, data, 1, 10);
        string path = "../NIST-Statistical-Test-Suite/sts/data/";
        string extension = ".dat";
        vector<string> list_names = file_names(path, extension);
        cout<<"FUNKCJA READ ALL FILES: (wyswietlam wszystkie pliki o rozszerzeniu: "<<extension<<")"<<endl<<endl;
        for (int i=0; i<list_names.size(); i++){
            cout<<"\t"<<list_names[i]<<endl;
        }
        cout<<endl<<endl;
        vector<vector<char>> list_of_data = read_all_files(list_names, path);
        for (int i=0; i<list_of_data.size(); i++){
            double X = myLongestRunOfOnes(n, list_of_data[i]);
            cout<<"DLA PLIKU: "<<list_names[i]<<" ORAZ N = "<<n<<" X^2 WYNOSI: ";
            printf("%f\n", X);
            list_of_data[i].clear();
        }
        cout<<endl;
        data.clear();
    }
    else {
        comparison();
    }
    return 0;
}

 