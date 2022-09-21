#include <iostream> 
#include <fstream>
#include <vector>
#include <string>
#include <memory>

#include "files_service.h"

using namespace std;

vector<char> read_file(string path){
    ifstream infile;
    infile.open(path, ios::binary | ios::in);
    if( infile.good() == true )
    {
        infile.seekg(0, std::ios::end);
        size_t n_bytes = infile.tellg();
        infile.seekg(0, std::ios::beg);
        vector<char> bufor(n_bytes);
        infile.read(bufor.data(), n_bytes);
        if(not infile) cout<<"Error - zabraklo danych do wczytania"<<endl;
        infile.close();
        return bufor;
    } else {
        cout<<"Dostep do pliku zostal zabroniony!"<<endl;
        cout<<"Path: '"<<path<<"'"<<endl;
        vector<char> err(1,0);
        return err;
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

vector<vector<char>> read_all_files(vector<string> list_files, string part_of_path){
    string path;
    vector<vector<char>> list_of_data;
    vector<char> data;
    for (int i=0; i<list_files.size(); i++){
        path = part_of_path + list_files[i];
        data = read_file(path);
        list_of_data.push_back(data);
    }
    return list_of_data;
}


