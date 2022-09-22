#include <iostream>   
#include <vector>
#include <string>
#include <chrono>
#include <cmath>

#include "helper_cuda.h"

#include "files_service.h"
#include "gpu_LROO.h"
#include "my_LROO.h"
#include "cuda_service.h"


using namespace std;    

const string path = "../NIST-Statistical-Test-Suite/sts/data/";
const string extension = ".txt";
        
vector<double> cuda_service(){
    int n, n_files, THREADS = 256, BLOCKS;
    char *d_a;
    double *d_b;
    float milliseconds = 0;
    vector<string> list_names = file_names(path, extension);
    vector<vector<char>> list_of_data = read_all_files(list_names, path);
    vector<char> data_a;
    size_t bytes = 0;
    cudaEvent_t start , stop ; 

    for (int i=0; i<list_of_data.size(); i++){
        data_a.insert(data_a.begin() + i*list_of_data[i].size(), list_of_data[i].begin(), list_of_data[i].end());  
        bytes = bytes + list_of_data[i].size() * sizeof(char);
    }
    n_files = list_of_data.size();
    n = list_of_data[0].size();
    BLOCKS = (n_files + THREADS - 1)/THREADS;
    vector<double> result(n_files * sizeof(double));
    checkCudaErrors(cudaMalloc(&d_a, bytes));
    checkCudaErrors(cudaMalloc(&d_b, n_files * sizeof(double)));
    checkCudaErrors(cudaMemcpy(d_a, data_a.data(), bytes, cudaMemcpyHostToDevice));
    checkCudaErrors(cudaEventCreate (& start )); 
    checkCudaErrors(cudaEventCreate (& stop ));
    checkCudaErrors(cudaEventRecord(start));  
    gpu<<<BLOCKS, THREADS>>>(d_a, d_b, n_files, n);
    checkCudaErrors(cudaEventRecord(stop));
    checkCudaErrors(cudaMemcpy(result.data(), d_b, n_files * sizeof(double), cudaMemcpyDeviceToHost));
    checkCudaErrors(cudaEventSynchronize(stop));
    checkCudaErrors(cudaEventElapsedTime(&milliseconds, start, stop));
    checkCudaErrors(cudaEventDestroy(start));
    checkCudaErrors(cudaEventDestroy(stop));
    cout << "Time of tests on the GPU: "<<milliseconds<<" ms" << endl;
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
    cout << "Time of tests on the CPU: "<< chrono::duration_cast<chrono::milliseconds>(end - start).count()
         << " ms" << endl;
    return result;
}

void comparison(){
    cout<<"----------------------------------------"<<endl;
    vector<double> result1 = cuda_service();
    vector<double> result2 = cpu_service();
    cout<<"----------------------------------------"<<endl<<endl;
    cout<<"----------------------------------------";
    int test_passed=0, test_failed=0;
    for(int i=0; i<result2.size(); i++){
        if(fabs(result1[i] - result2[i]) < 0.000001) test_passed++;
        else test_failed++;
    }
    cout<<endl<<"TEST PASSED: "<<test_passed<<endl;
    cout<<"TEST FAILED: "<<test_failed<<endl;
    cout<<"----------------------------------------"<<endl<<endl;
}
