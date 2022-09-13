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
#include "../../include/cephes.h" 
#include "../../include/externs.h"

using namespace std;

int main(int argc, char** argv){
    int objective;
    objective=strtol(argv[3], NULL, 10);
    int n;
    n=strtol(argv[1], NULL, 10);
    if (objective == 1){
        int n;
        n=strtol(argv[1], NULL, 10);
        bool * data;
        data = read_file(argv[2]);
        double X = myLongestRunOfOnes(n, data);
        printf("%f", X);
    }
    else{
        tests();
        bool * data;
        data = read_file(argv[2]);
        double X = myLongestRunOfOnes(n, data);
        printf("\nX wynosi: %f\n", X);
        //print_data(n, data);
        //extract_bits(n, data, 1, 8);
        cout<<endl;
        string path = "../../data/";
        string extension = ".dat";
        vector<string> list_names = file_names(path, extension);
        for (int i=0; i<list_names.size(); i++){
            cout<<list_names[i]<<endl;
        }
        vector<bool *> list_of_data = read_all_files(list_names, path);
        for (int i=0; i<list_of_data.size(); i++){
            double X = myLongestRunOfOnes(n, list_of_data[i]);
            printf("\nX wynosi: %f\n", X);
            delete[] list_of_data[i];
        }
        delete[] data;
    }
    return 0;
}