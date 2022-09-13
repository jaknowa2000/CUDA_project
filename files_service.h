#ifndef FILES_SERVICE_H
#define FILES_SERVICE_H
#include <iostream> 
#include <fstream>
#include <vector>
#include <stdlib.h>
#include <string>
#include <memory>

using namespace std;

bool * read_file(string path);
vector<string> exec(string cmd);
vector<string> file_names(string path, string extension);
vector<bool *> read_all_files(vector<string> list_files, string part_of_path);

#endif