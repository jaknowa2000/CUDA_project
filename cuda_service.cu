#include <iostream>   
#include <vector>
#include <stdlib.h>
#include <string>
#include <memory>
#include <chrono>
#include <cuda_runtime.h>
#include <cmath>

#include "files_service.h"
#include "gpuLROO.h"
#include "myLROO.h"
#include "cuda_service.h"

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <functional>

using namespace std;    

const string path = "../NIST-Statistical-Test-Suite/sts/data3/";
const string extension = ".txt";
        
vector<double> cuda_service(){
    cudaError_t what;
    int n;
    vector<string> list_names = file_names(path, extension);
    vector<vector<char>> list_of_data = read_all_files(list_names, path);
    vector<char> data_a;
    size_t bytes = 0;
    for (int i=0; i<list_of_data.size(); i++){
        data_a.insert(data_a.begin() + i*list_of_data[i].size(), list_of_data[i].begin(), list_of_data[i].end());  
        bytes = bytes + list_of_data[i].size() * sizeof(char);
    }
    int n_files = list_of_data.size();
    n = list_of_data[0].size();
    char *d_a;
    int THREADS = 256;
    double *d_b;
    what = cudaMalloc(&d_a, bytes);
    what = cudaMalloc(&d_b, n_files * sizeof(double));
    what = cudaMemcpy(d_a, data_a.data(), bytes, cudaMemcpyHostToDevice);
    int BLOCKS = (n_files + THREADS - 1)/THREADS;
    cudaEvent_t start , stop ; 
    what = cudaEventCreate (& start ); 
    what = cudaEventCreate (& stop );
    what = cudaEventRecord(start);  
    gpu<<<BLOCKS, THREADS>>>(d_a, d_b, n_files, n);
    what = cudaEventRecord(stop);
    vector<double> result(n_files * sizeof(double));
    what = cudaMemcpy(result.data(), d_b, n_files * sizeof(double), cudaMemcpyDeviceToHost);
    what = cudaDeviceSynchronize();
    what = cudaEventSynchronize(stop);
    float milliseconds = 0;
    what = cudaEventElapsedTime(&milliseconds, start, stop);
    cout<<"WHAT!: "<<what<<endl;
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cout << "Czas testow na GPU: "<<milliseconds<<" ms" << endl;
    cudaFree(d_a);
    cudaFree(d_b);
    return result;
}

vector<double> cpu_service(){
    vector<string> list_names = file_names(path, extension);
    vector<vector<char>> list_of_data = read_all_files(list_names, path);
    vector<double> result;
    auto start = chrono::steady_clock::now();
    for (int i=0; i<list_of_data.size(); i++){
        result.push_back(myLongestRunOfOnes(list_of_data[i].size(), list_of_data[i]));
    }
    auto end = chrono::steady_clock::now();
    cout << "Czas testow na CPU: "<< chrono::duration_cast<chrono::milliseconds>(end - start).count()
         << " ms" << endl;
    return result;
}

void comparison(){
    cout<<"----------------------------------------"<<endl;
    vector<double> result1 = cuda_service();
    vector<double> result2 = cpu_service();
    cout<<endl<<"----------------------------------------"<<endl;
    int test_passed=0, test_failed=0;
    for(int i=0; i<result2.size(); i++){
        if(fabs(result1[i] - result2[i]) < 0.000001) test_passed++;
        else test_failed++;
    }
    cout<<endl<<"TEST PASSED: "<<test_passed<<endl;
    cout<<"TEST FAILED: "<<test_failed<<endl<<endl;
    cout<<"----------------------------------------"<<endl;
}
