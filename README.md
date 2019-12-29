# 10810CS_410000_Arch
黃婷婷計算機結構作業

## Final Project

### Server Demo
nthucad.cs.nthu.edu.tw

port: 22

ssh -X ic21  (這行每次登入進去後都要打一下，驗證用)

CA063 

shawn2000

### Report

本次期末作業需模擬NRU replacement的Cache機制 (Direct map, 2-way... fully-way...)

![](https://github.com/shawn2000100/10810CS_410000/blob/master/Algo_Flow.jpg)

資料結構設計:

- 我主要使用C++的String來儲存Input資料 (一行就是一個string)，並用另一個一樣大小的String Array來儲存快取結果 (但後來想到，其實可以用Bool值儲存即可，節省空間...)

string reference_list[10001];
string hit_or_miss[10001];

- Cache我直接使用String來做模擬，因為運算上比二維的Char Array方便許多，接著每一個Block都有對應的NRU值，使用Bool紀錄即可

string cache\[cache_sets][associativity];
bool NRU_list\[cache_sets][associativity];

演算法步驟:

```c++
// 迴圈依序針對每一筆Reference Address進行處理
for(int i = 1; i < ref_num - 1; ++i){
    1. Calculate the "Tag" and ""Index Address"
    2. 利用計算出來的index及tag，到cache去比對Block是否Hit
        for(int a = 0; a < associativity; ++a){
        2.1. 若Hit，將NRU bit設為0 (被用過)
            if(cache[idx][a] == tag){
                hit_or_miss[i] = " hit";
                NRU_list[idx][a] = 0;
       }
       if(Hit) Continue; // (若上一步Hit，則下面不用再繼續執行了，GOTO 1.)
       
        2.2. 掃過某index的所有Blocks (Associativity) 了，Cache Miss
        hit_or_miss[i] = " miss";
        miss_count++;
		
        2.3. 依序到NRU List中找最近沒被使用過的Block來做Replace
        for(int a = 0; a < associativity; ++a){
            if(NRU_list[idx][a] == 1){
                NRU_list[idx][a] = 0;
                cache[idx][a] = tag;
                break;    
            }
            // flush
        2.4. 若掃過一輪發現所有的NRU bits都是0 (之前都被用過)，則Flush，並抓第一格Block做Replace
            else if(a == associativity - 1 && NRU_list[idx][a] == 0){
                for(int a = 0; a < associativity; ++a){
                    NRU_list[idx][a] = 1;
                }
                cache[idx][0] = tag;
                NRU_list[idx][0] = 0;
            }
        }
}
```



### Demo注意事項 (坑)

1. 如果程式無法執行或是沒反應，記得chmod a+x

2. file.open(config_file_name.c_str(), ios::in);
這邊要加上.c_str()，因為Demo Server不支援新的語法

3. Compuler指令 (坑!!!)
```g++44 project.cpp -std=c++0x -o project```

4. Demo指令範例:
```./project cache2.org reference2.lst index2.rpt```

```./verify cache2.org reference2.lst index2.rpt```
