#include <bits/stdc++.h>
using namespace std;

class node
{
public:
    char data;
    vector<int> num;
    int pos;
    struct node *left;
    struct node *right;
} node;

vector<string> getInput()
{
    string s;
    vector<string> inp;
    ifstream name;
    name.open("input.txt");
    bool firstline = true;
    while (!name.eof())
    {
        getline(name, s);
        if (firstline)
        {
            firstline = false;
            s += '\n';
            inp.push_back(s);
            continue;
        }
        string t = '(' + s + ".(#))\n";
        // s += "(#)";
        // s += '\n';

        inp.push_back(t);
    }
    name.close();
    return inp;
}
bool nullable(node *root)
{

    if (root->left == NULL and root->right == NULL)
    {
        if (root->data == 'e')
            return true;
        else
            return false;
    }
    else
    {
        if (root->data == '|')
            return nullable(root->left) or nullable(root->right);
        else if (root->data == '.')
            return nullable(root->left) and nullable(root->right);
        else if (root->data == '*')
            return true;
    }
}
vector<int> firstpos(node *root){
    vector<int> s;
     if(root->left==NULL and root->right==NULL){
        if(root->data =='e')
        return s;
        else {
            s.push_back(root->num[0]);
            return s;
        } 
    }

}
int main(){
    vector<string> inp = getInput();
    for (auto i : inp)
    {
        cout << i;
    }
    string s = modified(inp[1].substr(0, inp[1].size() - 1));
    cout << s << "hello\n";
    string y = postfix(s);
    cout << "\n";
    cout << y << " this is postfix" << endl;
    node *temp = create(y);
    cout << temp->data << " this is first node\n";
    print(temp);
    return 0;
    return 0;
}