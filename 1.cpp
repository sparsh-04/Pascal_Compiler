#include <bits/stdc++.h>
using namespace std;

class node
{
public:
    char data;
    int pos;
    vector<int> first;
    vector<int> last;
    node *right;
    node *left;
    bool null;

};

string postfix(string s)
{
    stack<char> st;
    int n = s.size();
    string pos = "";
    for (int i = 0; i < n; i++)
    {
        if (s[i] == '(')
        {
            st.push(s[i]);
        }
        else if (s[i] == ')')
        {
            if (st.top() == '(')
            {
                st.pop();
            }
            else
            {
                pos += st.top();
                st.pop();
                st.pop();
            }
        }
        else if (s[i] == '*' || s[i] == '.' || s[i] == '+' || s[i] == '|')
        {
            st.push(s[i]);
        }
        else
        {
            pos += s[i];
        }
    }
    return pos;
}

node *create(string s)
{
    stack<node *> st;
    int n = s.size();
    for (int i = 0; i < n; i++)
    {
        node *temp = new node();
        int j=1;
        if (s[i] == 'a' || s[i] == 'b' || s[i] == '#' || s[i] == 'e')
        {
            temp->right = NULL;
            temp->left = NULL;
            temp->data = s[i];
            temp->pos = j;
            st.push(temp);
            j++;
        }
        else if (s[i] == '*' || s[i] == '+' || s[i] == '?')
        {
            temp->right = NULL;
            temp->left = st.top();
            temp->data = s[i];
            st.pop();
            st.push(temp);
        }
        else if (s[i] == '|' || s[i] == '.')
        {
            temp->right = st.top();
            st.pop();
            temp->left = st.top();
            st.pop();
            temp->data = s[i];
            st.push(temp);
        }
        temp->null = nullable(temp);
        temp->first = firstpos(temp);
        temp->last = lastpos(temp);
        
    }
    cout << "\n";
    return st.top();
}

// just for checking
void print(node *root)
{
    if (root == NULL)
    {
        return;
    }
    print(root->left);
    cout << root->data;
    print(root->right);
}

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
            root->first.push_back(root->pos);
        }
    }
    else if((root->data == '|')){
            vector<int> v(10000);
        vector<int>::iterator it, st;

    sort(root->left->first.begin(), root->left->first.end());
    sort(root->right->first.begin(), root->right->first.end());
 
    // Using default operator<
    it = set_union(root->left->first.begin(), root->left->first.end(), root->right->first.begin(), root->right->first.end(),
                   v.begin());
    for (st = v.begin(); st != it; ++st)
        root->first.push_back( *st);
    }
    else if((root->data == '.')){
        if(root->left->null){
              vector<int> v(10000);
            vector<int>::iterator it, st;
            sort(root->left->first.begin(), root->left->first.end());
            sort(root->right->first.begin(), root->right->first.end());
        
            // Using default operator<
            it = set_union(root->left->first.begin(), root->left->first.end(), root->right->first.begin(), root->right->first.end(),
                        v.begin());
            for (st = v.begin(); st != it; ++st)
                root->first.push_back( *st);
            
        }
        else {
            root->first= root->left->first;
        }
    }
    else if((root->data == '*')){
        root->first= root->left->first;
    }


}

vector<int> lastpos(node *root){
    vector<int> s;
     if(root->left==NULL and root->right==NULL){
        if(root->data =='e')
        return s;
        else {
            root->last.push_back(root->pos);
        }
    }
    else if((root->data == '|')){
            vector<int> v(10000);
        vector<int>::iterator it, st;

    sort(root->left->last.begin(), root->left->last.end());
    sort(root->right->last.begin(), root->right->last.end());
 
    // Using default operator<
    it = set_union(root->left->last.begin(), root->left->last.end(), root->right->last.begin(), root->right->last.end(),
                   v.begin());
    for (st = v.begin(); st != it; ++st)
        root->last.push_back( *st);
    }
    else if((root->data == '.')){
        if(root->right->null){
            vector<int> v(10000);
            vector<int>::iterator it, st;
            sort(root->left->last.begin(), root->left->last.end());
            sort(root->right->last.begin(), root->right->last.end());
        
            // Using default operator<
            it = set_union(root->left->last.begin(), root->left->last.end(), root->right->last.begin(), root->right->last.end(),
                        v.begin());
            for (st = v.begin(); st != it; ++st)
                root->last.push_back( *st);
            
        }
        else {
            root->last= root->right->last;
        }
    }
    else if((root->data == '*')){
        root->last= root->left->last;
    }

}


string modified(string s)
{
    string s1 = "";
    if (s.size() > 0)
        s1.push_back(s[0]);
    for (int i = 1; i < s.length(); i++)
    {
        if (s[i - 1] == ')' && s[i] == '(')
        {
            s1.push_back('.');
        }
        s1.push_back(s[i]);
    }
    return s1;
}

int main()
{
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