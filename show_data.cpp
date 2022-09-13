#include <iostream>
#include <string>

#include "show_data.h"
#include "myLROO.h"

using namespace std;

const int M_c[3] = {8, 128, 10000};

void extract_bits(int n, bool data[], int start, int len){
    cout<<endl<<"FUNKCJA EXTRACT BITS: "<<endl;
    if (start > n){
        cout<<"ERROR";
    }
    if (start+len > n+1){
        len = n-start-1;
    }
    if (start<1){
        start = 1;
    }
    for (int i=start-1; i<start+len-1; i++){
        cout<<data[i];
    }
    cout<<endl;
}

void print_data(int n, bool data[]){
    cout<<endl<<"FUNKCJA PRINT DATA: "<<endl;
    int type = specify_type(n);
    int M = M_c[type];
    int N = n/M;
    for (int i=0; i<N; i++){
        for(int j=0; j<M; j++){
            cout<<data[i*M+j];
        }
        cout<<endl;
    }
}
