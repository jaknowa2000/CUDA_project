#ifndef SHOW_DATA_H
#define SHOW_DATA_H
#include <iostream>
#include <string>
#include <vector>

using namespace std;

void extract_bits(int n, vector<uint8_t> data, int start, int len);
void print_data(int n, vector<uint8_t> data);

#endif