#include <iostream>
#include <fstream>
#include <cmath>
using namespace std;
#define DEBUG 0

string reference_list[10001];
string hit_or_miss[10001];


int main(int argc, char *argv[]) {
    if (argc != 4) {
        cout << "Please Input: project cache1.org reference1.lst index.rpt" << endl;
        return 0;
    }
    string config_file_name = argv[1];
    string input_file_name = argv[2];
    string ootput_file_name = argv[3];
    fstream file;

/********************* cache1.org **************************/
    file.open(config_file_name, ios::in);
    if (!file) {
        cerr << "Cannot Open File: " << config_file_name << endl;
        exit(1);
    }

    string header;
    int data;
    int data_num = 0;
    int data_list[4] = {0};
    while(file >> header >> data) {
        data_list[data_num++] = data;
    }
    file.close();

    int address_bits = data_list[0];
    int block_size = data_list[1];
    int cache_sets = data_list[2];
    int associativity = data_list[3];
    int offset_bit_count = log2(block_size);
    int index_bit_count = log2(cache_sets);
    int index_bit[128] = {0}; // just give larger size
    int tag_bit_count = address_bits - index_bit_count - offset_bit_count; // self-define
#if(DEBUG)
    cout << "tag_count = " << tag_bit_count << endl;
#endif
    for(int i = offset_bit_count, j = 0; j < index_bit_count; ++i, ++j){
         index_bit[j] = i;
    }

#if(DEBUG)
    cout << "address_bits: " << address_bits << endl;
    cout << "block_size: " << block_size << endl;
    cout << "cache_sets: " << cache_sets << endl;
    cout << "associativity: " << associativity << endl;
    cout << "offset_bit_count: " << offset_bit_count << endl;
    cout << "index_bit_count: " << index_bit_count << endl;
#endif


/********************* reference1.lst **************************/
    file.open(input_file_name, ios::in);
    if (!file) {
        cerr << "Cannot Open File: " << input_file_name << endl;
        exit(1);
    }

    int ref_num = 0;
    //string reference_list[512]; // change to global def
    bool already_cout_header = false;
    while(file >> header) {
        reference_list[ref_num] = header;
        if(!already_cout_header){
            file >> header;
            reference_list[ref_num] += " " + header;
            already_cout_header = true;
        }
#if(DEBUG)
        cout << "reference_list[" << ref_num << "] " << reference_list[ref_num] << endl;
#endif
        ++ref_num;
    }
    file.close();


/********************* cache simulation **************************/
    //string hit_or_miss[512]; global
    int miss_count = 0;
    string cache[cache_sets][associativity];
    bool NRU_list[cache_sets][associativity];
    for(int i = 0; i < cache_sets; ++i)
    	for(int j = 0; j < associativity; ++j)
            NRU_list[i][j] = 1;

    for(int i = 1; i < ref_num - 1; ++i){
        string idxS;
        string tag;
        
        int j = 0;
        for(int k = 0; k < tag_bit_count; ++j, ++k){
            tag += reference_list[i][j];
#if(DEBUG)
            cout << "---------" << endl;
            cout << "ref:" << i << " = " << reference_list[i] << endl;
            cout << " j = " << j << endl;
            cout << " tag = " << tag << endl;
            cout << "---------" << endl;
#endif
        }
        for(int k = 0; k < index_bit_count; ++j, ++k){
            idxS += reference_list[i][j];
#if(DEBUG)
            cout << "---------" << endl;
            cout << "ref:" << i << " = " << reference_list[i] << endl;
            cout << " j = " << j << endl;
            cout << " idxS = " << idxS << endl;
            cout << "---------" << endl;
#endif
        }
#if(DEBUG)
        cout << "idxS = " << idxS << endl;
        cout << "tag = " << tag << endl;
#endif
        int idx = stoi(idxS, 0, 2);
#if(DEBUG)
        cout << "idx = " << idx << endl;
        cout << "---------" << endl;
#endif

        bool hit = false;
        for(int a = 0; a < associativity; ++a){
            if(cache[idx][a] == tag){
                hit_or_miss[i] = " hit";
                NRU_list[idx][a] = 0;
                hit = true;
                break;
            }
        }
        if(hit){
            continue;
        }

        hit_or_miss[i] = " miss";
        miss_count++;

        for(int a = 0; a < associativity; ++a){
            if(NRU_list[idx][a] == 1){
                NRU_list[idx][a] = 0;
                cache[idx][a] = tag;
                break;    
            }
            // flush
            else if(a == associativity - 1 && NRU_list[idx][a] == 0){
                for(int a = 0; a < associativity; ++a){
                    NRU_list[idx][a] = 1;
                }
                cache[idx][0] = tag;
                NRU_list[idx][0] = 0;
            }
        }
    }
    
    
/********************* index.rpt **************************/
    file.open(ootput_file_name, ios::out);
    if(!file) {
        cerr << "Cannot Open File: " << ootput_file_name << endl;
        exit(1);
    }

    file << "Address bits: " << address_bits << endl;
    file << "Block size: " << block_size << endl;
    file << "Cache sets: " << cache_sets << endl;
    file << "Associativity: " << associativity << endl;
    file << endl;
    file << "Offset bit count: " << offset_bit_count << endl;
    file << "Indexing bit count: " << index_bit_count << endl;
    file << "Indexing bits:";
    for(int i = index_bit_count - 1; i >= 0; --i){
        file << " " << index_bit[i];
    }
    file << endl << endl;

    for(int i = 0; i < ref_num; ++i){
        file << reference_list[i] << hit_or_miss[i] << endl;
    }
    file << endl;
    file << "Total cache miss count: " << miss_count << endl;
    file.close();
    return 0;
}
