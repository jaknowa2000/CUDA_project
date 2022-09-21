#ifndef FILES_SERVICE_H
#define FILES_SERVICE_H
#include <iostream> 
#include <vector>
#include <string>

using namespace std;

vector<char> read_file(string path);
vector<string> exec(string cmd);
vector<string> file_names(string path, string extension);
vector<vector<char>> read_all_files(vector<string> list_files, string part_of_path);

#endif