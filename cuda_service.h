#ifndef CUDA_SERVICE_H
#define CUDA_SERVICE_H
#include <iostream>   
#include <vector>

using namespace std;      
        
vector<double> cuda_service();
vector<double> cpu_service();
void comparison();

#endif