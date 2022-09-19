#ifndef GPULROO_H
#define GPULROO_H
#include <iostream>
#include <math.h>   
#include <string>
#include <vector>

using namespace std;

__device__ int gpu_specify_type(int n);
__device__ double gpuLongestRunOfOnes(int n, int data[]);
__global__ void gpu(int *a, double *b, int z, int n);


#endif