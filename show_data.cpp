#include <iostream>
#include <math.h>
#include <vector>

#include "show_data.h"
#include "myLROO.h"

using namespace std;

const int M_c[3] = {8, 128, 10000};

void extract_bits(int n, vector<char> bufor, int start, int len){
    cout<<endl<<"FUNCTION EXTRACT BITS: (displaying bits from "
        <<start<<" to "<<start+len-1<<")"<<endl<<endl;
    if (start > n){
        cout<<"ERROR";
    }
    if (start+len > n+1){
        len = n-start-1;
    }
    if (start<1){
        start = 1;
    }
    bool *data =  new bool[8 * sizeof(bool)];
    for (int i=(start-1)/8; i<ceil((start+len-1)/8.0); i++){
        for(int j = 0; j < 8; j++) {
                data[7-j] = ((bufor[i] >> j) & 0x01);
        }
        if (i == (start-1)/8){
            for(int j = (start-1)%8; j < 8; j++) {
                    cout<<data[j];
            }
        }
        else if (i == ceil((start+len-1)/8.0) - 1){
            for(int j = 0; j <= (start+len-2)%8; j++) {
                    cout<<data[j];
            }
        }
        else{
            for(int j = 0; j < 8; j++) {
                    cout<<data[j];
            }
        }
    }
    delete[] data;
    cout<<endl;
}

void print_data(int n, vector<char> bufor){
    cout<<endl<<"FUNCTION PRINT DATA: "<<endl<<endl;
    int type = specify_type(n);
    int M = M_c[type];
    int N = n/M;
    bool *data =  new bool[M * sizeof(bool)];
    for (int i=0; i<N; i++){
        for (int k=0; k<M/8; k++){
            for(int j = 0; j < 8; j++) {
                data[k*8+7-j] = ((bufor[(i*M)/8 + k] >> j) & 0x01);
            }
        }
        for(int j=0; j<M; j++){
            cout<<data[j];
        }
        cout<<endl;
    }
    delete[] data;
}
