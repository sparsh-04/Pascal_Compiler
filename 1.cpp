#include <bits/stdc++.h>
using namespace std;

typedef struct node {
    char data;
    int val;    
    struct node *left;
    struct node *right;
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
    }
    name.close();
    return inp;
}
bool nullable(node *root){

    if(root->left==NULL and root->right==NULL){
        if(root->data =='e')
        return true;
        else return false;
    }
    else {
        if(root->data=='|')
        return nullable(root->left) or  nullable(root->right);
        else if(root->data=='.')
        return nullable(root->left) and  nullable(root->right);
        else if(root->data=='*')
        return true;
    }
}
// set<int> firstpos(node *root){
//     set<int> s;
//      if(root->left==NULL and root->right==NULL){
//         if(root->data =='e')
//         return s;
//         else return false;
//     }

// }
int main(){
    vector<string> inp = getInput();
    for(auto i:inp){
        cout<<i;
    }

    return 0;
}