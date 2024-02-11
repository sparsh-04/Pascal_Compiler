#include <bits/stdc++.h>
using namespace std;

typedef struct node {
    char data;
    struct tree *left;
    struct tree *right;
} node;

vector<string> getInput(){
    string s;
    vector<string> inp;
    ifstream name;
    name.open("input.txt");
    bool firstline=true;
    while(!name.eof()){
        getline(name,s);
        if(firstline){
            firstline=false;
            s+='\n';
            inp.push_back(s);
            continue;
        }
        s+="(#)";
        s+='\n';
        inp.push_back(s);
        // cout<<s;
    }
    // cout<<s;
    name.close();
    return inp;
}
int main(){
    vector<string> inp = getInput();
    for(auto i:inp){
        cout<<i;
    }

    return 0;
}