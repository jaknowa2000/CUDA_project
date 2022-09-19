#include <iostream>
#include <string>

#include "u_tests.h"
#include "files_service.h"
#include "myLROO.h"

using namespace std;


void test(int n, string path, double exp_val, int number){
    vector<int> data;
    data = read_file(path);
    double X = myLongestRunOfOnes(n, data);
    data.clear();
    if (abs(X-exp_val)<0.1) cout<<"TEST-"<<number<<" PASSED"<<endl;
    else cout<<"TEST-"<<number<<" NOT PASSED!!!!!!!!!!!"<<endl;
}

void tests(){
    test(7000, "../../data/BBS.dat", 2.615045, 1);
    test(1750000, "../../data/BBS.dat", 7.617348, 2);
    test(749999, "../../data/BBS.dat", 3.081818, 3);
    test(250, "../../data/BBS.dat", 0.039187, 4);
    test(123456, "../../data/data.bad_rng", 6.120316, 5);
    test(10000, "../../data/data.e", 586.374977, 6);
    test(100000, "../../data/data.pi", 5871.267400, 7);
    test(1024, "../../data/data.sha1", 2.858668, 8);
    test(8193, "../../data/data.sqrt2", 481.128186, 9);
    test(193284, "../../data/data.sqrt3", 11351.618148, 10);
}
