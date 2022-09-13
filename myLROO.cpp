#include <iostream>
#include <math.h>   
#include <string>

#include "myLROO.h"

using namespace std;

const double pi[3][7] = {{0.21484375, 0.3671875, 0.23046875, 0.1875},
                         {0.1174035788, 0.242955959, 0.249363483,
                          0.17517706, 0.102701071, 0.112398847},
                         {0.0882, 0.2092, 0.2483, 0.1933, 0.1208,
                          0.0675, 0.0727}};

const int v[3][7] = {{1, 2, 3, 4}, {4, 5, 6, 7, 8, 9}, 
                     {10, 11, 12, 13, 14, 15, 16}};

const int M_c[3] = {8, 128, 10000};
const int K_c[3] = {3, 5, 6};

int specify_type(int n){
    int type;
    if (n < 128){
        cout<<"Too short stream of bits"<<endl;
        return -1;
    }
    else if (n < 6272){
        type = 0;
    }
    else if (n < 750000){
        type = 1;
    }
    else {
        type = 2;
    }
    return type;
}

double myLongestRunOfOnes(int n, bool data[]){
    int K, M, N,type;
    double v_measured[7] = {0}, X = 0; 
    type = specify_type(n);
    M = M_c[type];
    K = K_c[type];
    N = n/M;
    int run, longest_run;
    for (int i=0; i<N; i++){
        run = 0;
        longest_run = 0;
        for (int j=0; j<M; j++){
            if (data[i*M+j] == 1){
                run++;
            }
            if (longest_run < run){
                longest_run = run;
            }
            if (data[i*M+j] == 0){
                run = 0;
            }
        }
        if (longest_run<=v[type][0]){
            v_measured[0]++;
        }
        else if(longest_run>=v[type][K]){
            v_measured[K]++;
        }
        else{
            for (int j=1; j<K; j++){
                if( v[type][j] == longest_run){
                    v_measured[j]++;
                    break;
                }
            }
        }
    }
    int sum_control = 0;
    for (int i=0; i<K+1; i++){
        sum_control += v_measured[i];
    }
    if (sum_control != N) cout<<"Error - sum control incorrect";
    for (int i=0; i<K+1; i++){
        X+= pow(v_measured[i] - N*pi[type][i], 2)/(N*pi[type][i]);
    }
    return X;
}
