# CUDA_project
Statistical test on the GPU.

It's an implementation of the Longest Run of Ones (LROO) statistical test.
There is implementation of LROO in C++ and also on CUDA platform.
Parallelization is at the file level, i.e. many files are tested at once.

The implementation is tested by unit tests and python script where the reference implementation is  
https://github.com/terrillmoore/NIST-Statistical-Test-Suite.

If you want to use this repository you must have installed CUDA platform, make gitclode of NIST repository and 
put this repo inside main folder of NIST-Statistical-Test-Suite. The NIST repository is required, because python
script calls their implementation to test this implementation.
