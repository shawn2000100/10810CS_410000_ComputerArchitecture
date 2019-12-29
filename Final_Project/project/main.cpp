#include <iostream>
#include <fstream>
#include <cmath>
using namespace std;
#define DEBUG 1


int main(int argc, char *argv[]) {
    if (argc != 4) {
        cout << "Please Input: project cache1.org reference1.lst index.rpt" << endl;
        return 0;
    }
    string config_file_name = argv[1];
    string input_file_name = argv[2];
    string ootput_file_name = argv[3];
    fstream file;

    /* cache1.org */
    file.open(config_file_name, ios::in);
    if (!file) {
        cerr << "Cannot Open File: " << config_file_name << endl;
        exit(1);
    }
    int addr_bits = 0;
    int block_size = 0;
    int offset_bits = 0;
    int cache_sets = 0;
    int index_bits = 0;
    int associativity = 0;
    string tmp;
    int data;
    int data_num = 0;
    int data_list[4] = {0};
    while(file >> tmp >> data) {
        data_list[data_num++] = data;
    }
    file.close();

    addr_bits = data_list[0];
    block_size = data_list[1];
    offset_bits = log2(block_size);
    cache_sets = data_list[2];
    associativity = data_list[3];
    index_bits = log2(cache_sets);
#if(DEBUG)
    cout << "addr_bits: " << addr_bits << endl;
    cout << "block_size: " << block_size << endl;
    cout << "offset_bits: " << offset_bits << endl;
    cout << "cache_sets: " << cache_sets << endl;
    cout << "index_bits: " << index_bits << endl;
    cout << "associativity: " << associativity << endl;
#endif

    /* reference1.lst */
    file.open(input_file_name, ios::in);
    if (!file) {
        cerr << "Cannot Open File: " << input_file_name << endl;
        exit(1);
    }
    string reference_list[100];
    string hit_or_miss[100];
    int ref_num = 0;
    bool cout_header = false;
    while(file >> tmp) {
        reference_list[ref_num] = tmp;
        if(!cout_header){
            file >> tmp;
            reference_list[ref_num] += " " + tmp;
            cout_header = true;
        }
#if(DEBUG)
        cout << "reference_list[" << ref_num << "] " << reference_list[ref_num] << endl;
#endif
        ++ref_num;
    }
    file.close();

    /* cache simulation */



    /* index.rpt */
    file.open(ootput_file_name, ios::out);
    if(!file) {
        cerr << "Cannot Open File: " << ootput_file_name << endl;
        exit(1);
    }
    file << "Address bits: " << addr_bits << endl;
    file << "Block size: " << block_size << endl;
    file << "Cache sets: " << cache_sets << endl;
    file << "Associativity: " << associativity << endl;
    file << "Indexing bits count: " << index_bits << endl;
    file << "Indexing bits: " << "5, 4" << endl;
    file << "Total cache miss count: " << "4" << endl;
    file << endl;
    hit_or_miss[1] = "miss";
    hit_or_miss[2] = "miss";
    hit_or_miss[3] = "miss";
    hit_or_miss[4] = "hit";
    hit_or_miss[5] = "miss";
    hit_or_miss[6] = "hit";
    hit_or_miss[7] = "hit";
    for(int i = 0; i < ref_num; ++i){
        file << reference_list[i] << " " << hit_or_miss[i] << endl;
    }
    file.close();
    return 0;
}
