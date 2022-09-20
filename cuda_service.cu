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
    vector<vector<uint8_t>> list_of_data = read_all_files(list_names, path);
    vector<uint8_t> data_a;
    size_t bytes = 0;
    for (int i=0; i<list_of_data.size(); i++){
        data_a.insert(data_a.begin() + i*list_of_data[i].size(), list_of_data[i].begin(), list_of_data[i].end());  
        bytes = bytes + list_of_data[i].size() * sizeof(uint8_t);
    }
    cout<<"DATA A SIZE: "<<data_a.size()<<endl;
    int n_files = list_of_data.size();
    n = list_of_data[0].size();
    cout<<"N: "<<n<<endl;
    uint8_t *d_a;
    int THREADS = 256;
    double *d_b;
    cout<<"BYTES: "<<bytes<<endl;
    what = cudaMalloc(&d_a, bytes);
    cout<<"WHAT1: "<<what<<endl;
    what = cudaMalloc(&d_b, n_files * sizeof(double));
    cout<<"WHAT2: "<<what<<endl;
    what = cudaMemcpy(d_a, data_a.data(), bytes, cudaMemcpyHostToDevice);
    cout<<"WHAT3: "<<what<<endl;
    int BLOCKS = (n_files + THREADS - 1)/THREADS;
    cudaEvent_t start , stop ; 
    what = cudaEventCreate (& start ); 
    cout<<"WHAT4: "<<what<<endl;
    what = cudaEventCreate (& stop );
    cout<<"WHAT5: "<<what<<endl;
    what = cudaEventRecord(start);  
    cout<<"WHAT6: "<<what<<endl;
    gpu<<<BLOCKS, THREADS>>>(d_a, d_b, n_files, n);
    what = cudaEventRecord(stop);
    cout<<"WHAT7: "<<what<<endl;
    vector<double> result(n_files * sizeof(double));
    cout<<"RESULTSIZE: "<<result.size()<<endl;
    what = cudaMemcpy(result.data(), d_b, n_files * sizeof(double), cudaMemcpyDeviceToHost);
    cout<<"WHAT8: "<<what<<endl;
    what = cudaDeviceSynchronize();
    cout<<"WHAT9: "<<what<<endl;
    what = cudaEventSynchronize(stop);
    cout<<"WHAT10: "<<what<<endl;
    float milliseconds = 0;
    what = cudaEventElapsedTime(&milliseconds, start, stop);
    cout<<"WHAT!: "<<what;
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cout << "Czas testow na GPU: "<<milliseconds<<" ms" << endl;
    cudaFree(d_a);
    cudaFree(d_b);
    return result;
}

vector<double> cpu_service(){
    vector<string> list_names = file_names(path, extension);
    vector<vector<uint8_t>> list_of_data = read_all_files(list_names, path);
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
    vector<double> result1 = cuda_service();
    vector<double> result2 = cpu_service();
    int test_passed=0, test_failed=0;
    for(int i=0; i<result2.size(); i++){
        if(fabs(result1[i] - result2[i]) < 0.01) test_passed++;
        else test_failed++;
    }
    cout<<"RESULT1: "<<result1[99999]<<endl;
    cout<<"RESULT2: "<<result2[99999]<<endl;
    cout<<"RESULT1: "<<result1[999999]<<endl;
    cout<<"RESULT2: "<<result2[999999]<<endl;
    cout<<endl<<"TEST PASSED: "<<test_passed<<endl;
    cout<<"TEST FAILED: "<<test_failed<<endl<<endl;

}
