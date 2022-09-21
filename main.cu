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
        cout<<endl<<"****************************************"<<endl;
        cout<<"THIS PROGRAM PRESENTS THE FUNCTIONALITIES AT THE GPU"<<endl;
        cout<<"****************************************"<<endl<<endl;
        cout<<"----------------------------------------"<<endl;
        cout<<"UNIT TESTS: "<<endl<<endl;
        tests();
        cout<<"----------------------------------------"<<endl<<endl;
        vector<char> data = read_file(argv[2]);
        n = strtol(argv[3], NULL, 10);
        double X = myLongestRunOfOnes(n, data);
        cout<<"----------------------------------------";
        printf("\nFOR INPUT VALUES X^2 (LROO test) IS: %f\n", X);
        cout<<"----------------------------------------"<<endl<<endl;
        cout<<"----------------------------------------";
        print_data(n, data);
        cout<<"----------------------------------------"<<endl<<endl;
        cout<<"----------------------------------------";
        extract_bits(n, data, 1, 11);
        cout<<"----------------------------------------"<<endl<<endl;
        string path = "../NIST-Statistical-Test-Suite/sts/data/";
        string extension = ".dat";
        vector<string> list_names = file_names(path, extension);
        cout<<"----------------------------------------"<<endl;
        cout<<"FUNCTION READ ALL FILES: (displaying all files with the extension: "<<extension<<")"<<endl<<endl;
        for (int i=0; i<list_names.size(); i++){
            cout<<"\t"<<i+1<<". "<<list_names[i]<<endl;
        }
        cout<<"----------------------------------------"<<endl<<endl;
        cout<<"----------------------------------------"<<endl;
        vector<vector<char>> list_of_data = read_all_files(list_names, path);
        for (int i=0; i<list_of_data.size(); i++){
            double X = myLongestRunOfOnes(n, list_of_data[i]);
            cout<<"FOR FILE: "<<list_names[i]<<" AND N = "<<n<<" X^2 (LROO test) IS: ";
            printf("%f\n", X);
            list_of_data[i].clear();
        }
        cout<<"----------------------------------------"<<endl;
        cout<<endl;
        data.clear();
    }
    else {
        cout<<endl<<"****************************************"<<endl;
        cout<<"THIS PROGRAM COMPARE LROO TEST INPLEMENTED ON THE GPU AND CPU "<<endl;
        cout<<"****************************************"<<endl<<endl;
        comparison();
    }
    return 0;
}