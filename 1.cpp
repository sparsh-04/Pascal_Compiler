#include <bits/stdc++.h>
using namespace std;

class node
{
public:
    char data;
    node *right;
    node *left;
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
        if (s[i] == 'a' || s[i] == 'b' || s[i] == '#' || s[i] == 'e')
        {
            temp->right = NULL;
            temp->left = NULL;
            temp->data = s[i];
            st.push(temp);
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
// set<int> firstpos(node *root){
//     set<int> s;
//      if(root->left==NULL and root->right==NULL){
//         if(root->data =='e')
//         return s;
//         else return false;
//     }

// }

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
    string s2 = "";
    for(int i=0;i<s1.length();i++){
        if(s1[i]== '?'){
            int count = 1;
            int j = 2;
            while(j<i && count>0){
                if(s1[i-j] == '(')
                    count--;
                else if(s1[i-j] == ')')
                    count++;
                j++;
            }
            s2 += ".(e)";

        }
        else if(s1[i] == '+'){
            int count = 1;
            int j = 2;
            while(j<i && count>0){
                if(s1[i-j] == '(')
                    count--;
                else if(s1[i-j] == ')')
                    count++;
                j++;
            }
            s2 += ".";
            s2 += s1.substr(i-j,j );
            s2 += "*)";
        }
        else{
            s2.push_back(s1[i]);
        }
        //if + dekhay tohh ((xy)+) -> ((xy).((xy)*))
        //if ? dekhay tohh ((xy)?) -> ((xy).(e))
    }
    return s2;
    // (((((b)|((a)(b)))+)|((((b)|((a)(b)))*)(a))).(#))
    // (((((b)|((a).(b))).(((b)|((a).(b)))*))|((((b)|((a).(b)))*).(a))).(#))hello
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