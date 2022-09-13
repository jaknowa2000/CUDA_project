#include <iostream> 
#include <fstream>
#include <vector>
#include <stdlib.h>
#include <string>
#include <memory>

#include "files_service.h"

using namespace std;

bool * read_file(string path){
    ifstream infile;
    infile.open(path, ios::binary | ios::in);
    if( infile.good() == true )
    {
        infile.seekg(0, std::ios::end);
        size_t n_bytes = infile.tellg();
        infile.seekg(0, std::ios::beg);
        char * bufor = new char[n_bytes];
        bool * data = new bool[n_bytes*8];
        infile.read(bufor, n_bytes);
        if(not infile) cout<<"Error - zabraklo danych do wczytania"<<endl;
        for (int i=0; i<n_bytes; i++){
            for(int j = 0; j < 8; j++) {
                data[i*8+7-j] = ((bufor[i] >> j) & 0x01);
            }
        }
        infile.close();
        delete[] bufor;
        return data;
    } else {
        cout<<"Dostep do pliku zostal zabroniony!"<<endl;
        cout<<"Path: '"<<path<<"'"<<endl;
        return 0;
    }
}

vector<string> exec(string cmd) {
    array<char, 128> buffer;
    vector<string> result;
    unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd.c_str(), "r"), pclose);
    if (!pipe) {
        throw runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result.push_back(buffer.data());
    }
    return result;
}

vector<string> file_names(string path, string extension){
    vector<string> names = exec("ls "+ path + " | grep " + extension);
    for (int i=0; i<names.size(); i++){
        names[i].pop_back();
    }
    return names;
}

vector<bool *> read_all_files(vector<string> list_files, string part_of_path){
    string path;
    vector<bool *> list_of_data;
    bool * data = new bool;
    for (int i=0; i<list_files.size(); i++){
        path = part_of_path + list_files[i];
        data = read_file(path);
        list_of_data.push_back(data);
    }
    return list_of_data;
}


