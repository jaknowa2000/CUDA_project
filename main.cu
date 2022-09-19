#include <iostream>
#include <math.h>   
#include <fstream>
#include <vector>
#include <stdlib.h>
#include <string>
#include <memory>

#include "u_tests.h"
#include "files_service.h"
#include "show_data.h"
#include "myLROO.h"
#include "gpuLROO.h"
#include "cuda_service.h"
#include "../../include/cephes.h" 
#include "../../include/externs.h"

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <functional>

using namespace std;

int main(int argc, char** argv) {
    int objective;
    objective=strtol(argv[1], NULL, 10);
    int n;
    if (objective == 1){
        n=strtol(argv[3], NULL, 10);
        vector<int> data;
        data = read_file(argv[2]);
        double X = myLongestRunOfOnes(n, data);
        printf("%f", X);
    }
    else if (objective == 2){
        tests();
        vector<int> data = read_file(argv[2]);
        n=strtol(argv[3], NULL, 10);
        double X = myLongestRunOfOnes(n, data);
        printf("\nDLA DANYCH WEJSCIOWYCH FUNKCJA X^2 WYNOSI: %f\n", X);
        print_data(n, data);
        extract_bits(n, data, 1, 8);
        string path = "../../data/";
        string extension = ".dat";
        vector<string> list_names = file_names(path, extension);
        cout<<"FUNKCJA READ ALL FILES: (wyswietlam wszystkie pliki o rozszerzeniu: "<<extension<<")"<<endl<<endl;
        for (int i=0; i<list_names.size(); i++){
            cout<<"\t"<<list_names[i]<<endl;
        }
        cout<<endl<<endl;
        vector<vector<int>> list_of_data = read_all_files(list_names, path);
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
        vector<double> result = cuda_service();
        for(int i=0; i<10; i++){
            cout<<"X["<<i<<"] = "<<result[i]<<endl;
        }
    }
    return 0;
}

 