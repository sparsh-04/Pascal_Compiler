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

int main()
{
    string s;
    cin >> s;
    string y = postfix(s);
    cout << y << " this is postfix" << endl;
    node *temp = create(y);
    cout << temp->data << " this is first node\n";
    print(temp);
    return 0;
}