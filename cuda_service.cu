#include <iostream>   
#include <vector>
#include <stdlib.h>
#include <string>
#include <memory>

#include "files_service.h"
#include "gpuLROO.h"
#include "cuda_service.h"

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <functional>

using namespace std;      
        
vector<double> cuda_service(){
    int n;
    string path = "../../data/";
    string extension = ".txt";
    vector<string> list_names = file_names(path, extension);
    //for (int i=0; i<list_names.size(); i++){
        //cout<<list_names[i]<<endl;
    //}
    vector<vector<int>> list_of_data = read_all_files(list_names, path);
    vector<int> data_a;
    size_t bytes = 0;
    for (int i=0; i<list_of_data.size(); i++){
        data_a.insert(data_a.begin() + i*list_of_data[i].size(), list_of_data[i].begin(), list_of_data[i].end());  
        bytes = bytes + list_of_data[i].size() * sizeof(int);
    }
    int n_files = list_of_data.size();
    n = list_of_data[0].size();
    int *d_a;
    int THREADS = 256;
    double *d_b;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, n_files * sizeof(double));
    cudaMemcpy(d_a, data_a.data(), bytes, cudaMemcpyHostToDevice);
    int BLOCKS = (n_files + THREADS - 1)/THREADS;
    gpu<<<BLOCKS, THREADS>>>(d_a, d_b, n_files, n);
    vector<double> result(n_files * sizeof(double));
    cudaMemcpy(result.data(), d_b, n_files * sizeof(double), cudaMemcpyDeviceToHost);
    cudaFree(d_a);
    cudaFree(d_b);
    return result;
}