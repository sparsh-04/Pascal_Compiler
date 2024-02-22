#include <bits/stdc++.h>
using namespace std;
class CreateDFA{
public:

map<string, pair<char, vector<int> > > states;
map<char, pair<char, char> > dfa;
unordered_set<int> pos_a, pos_b;
int destination_marker;
unordered_set<char> final_states;

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

map<int, vector<int> > follow;

int insertPos(node *root, int count)
{
    if (root == nullptr)
    {
        return count;
    }
    if (root->left == nullptr && root->right == nullptr)
    {
        root->pos = count;
        count++;
        if (root->data == 'a')
        {
            pos_a.insert(root->pos);
        }
        if (root->data == 'b')
        {
            pos_b.insert(root->pos);
        }
        if (root->data == '#')
        {
            destination_marker = root->pos;
        }
    }
    int l = insertPos(root->left, count);
    int r = insertPos(root->right, l);
    return r;
}

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
        int j = 1;
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
    }
    return st.top();
}

void print(node *root)
{
    if (root == NULL)
    {
        return;
    }
    print(root->left);
    cout << root->data << " ";
    for (auto i : root->last)
        cout << i << " ";
    cout << endl;
    print(root->right);
}

void nullable(node *root)
{

    if (root->left == NULL and root->right == NULL)
    {
        if (root->data == 'e')
            root->null = true;
        else
            root->null = false;
    }
    else
    {
        if (root->data == '|')
            root->null = root->left->null or root->right->null;
        else if (root->data == '.')
            root->null = root->left->null and root->right->null;
        else if (root->data == '*')
            root->null = true;
    }
}
void firstpos(node *root)
{
    vector<int> s;
    if (root->left == NULL and root->right == NULL)
    {
        if (root->data == 'e')
            root->first.push_back(-1);
        else
        {
            root->first.push_back(root->pos);
        }
    }
    else if (root->data == '|')
    {
        vector<int> v(10000);
        vector<int>::iterator it, st;

        sort(root->left->first.begin(), root->left->first.end());
        sort(root->right->first.begin(), root->right->first.end());
        it = set_union(root->left->first.begin(), root->left->first.end(), root->right->first.begin(), root->right->first.end(),
                       v.begin());
        for (st = v.begin(); st != it; ++st)
            root->first.push_back(*st);
    }
    else if (root->data == '.')
    {
        if (root->left->null)
        {
            vector<int> v(10000);
            vector<int>::iterator it, st;
            sort(root->left->first.begin(), root->left->first.end());
            sort(root->right->first.begin(), root->right->first.end());
            it = set_union(root->left->first.begin(), root->left->first.end(), root->right->first.begin(), root->right->first.end(),
                           v.begin());
            for (st = v.begin(); st != it; ++st)
                root->first.push_back(*st);
        }
        else
        {
            root->first = root->left->first;
        }
    }
    else if (root->data == '*')
    {
        root->first = root->left->first;
    }
}

void lastpos(node *root)
{
    vector<int> s;
    if (root->left == NULL and root->right == NULL)
    {
        if (root->data == 'e')
            root->last.push_back(-1);
        else
        {
            root->last.push_back(root->pos);
        }
    }
    else if (root->data == '|')
    {
        vector<int> v(10000);
        vector<int>::iterator it, st;

        sort(root->left->last.begin(), root->left->last.end());
        sort(root->right->last.begin(), root->right->last.end());
        it = set_union(root->left->last.begin(), root->left->last.end(), root->right->last.begin(), root->right->last.end(),
                       v.begin());
        for (st = v.begin(); st != it; ++st)
            root->last.push_back(*st);
    }
    else if (root->data == '.')
    {
        if (root->right->null)
        {
            vector<int> v(10000);
            vector<int>::iterator it, st;
            sort(root->left->last.begin(), root->left->last.end());
            sort(root->right->last.begin(), root->right->last.end());
            it = set_union(root->left->last.begin(), root->left->last.end(), root->right->last.begin(), root->right->last.end(),
                           v.begin());
            for (st = v.begin(); st != it; ++st)
                root->last.push_back(*st);
        }
        else
        {
            root->last = root->right->last;
        }
    }
    else if (root->data == '*')
    {
        root->last = root->left->last;
    }
}

void followpos(node *root)
{
    if (root->data == '.')
    {
        for (auto i : root->left->last)
        {
            for (auto j : root->right->first)
                follow[i].push_back(j);
        }
    }
    else if (root->data == '*')
    {
        for (auto i : root->last)
        {
            for (auto j : root->first)
            {
                follow[i].push_back(j);
            }
        }
    }
    return;
}

void computeTreeValues(node *root)
{
    if (root == NULL)
        return;
    if (root->left)
        computeTreeValues(root->left);
    if (root->right)
        computeTreeValues(root->right);
    nullable(root);
    firstpos(root);
    lastpos(root);
    followpos(root);
}

string modifyString(string s)
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
    for (int i = 0; i < s1.length(); i++){
        if(s1[i]=='?'){
            s2+="|(e)";
        }
        else s2+=s1[i];
    }
    s1 = s2;
    s2 = "";    
    for (int i = 0; i < s1.length(); i++)
    {
        if (s1[i] == '+')
        {
            int count = 1;
            int j = 2;
            while (j < i && count > 0)
            {
                if (s1[i - j] == '(')
                    count--;
                else if (s1[i - j] == ')')
                    count++;
                j++;
            }
            s2 += ".";
            s2 += s1.substr(i - j, j);
            s2 += "*)";
        }
        else
        {
            s2.push_back(s1[i]);
        }
    }
    return s2;
}

void create_dfa(node *root)
{
    queue<string> q;
    char sta = 'A';
    vector<int> ini = root->first;
    string s = "";
    for (int i = 0; i < ini.size(); i++)
    {
        if (ini[i] == destination_marker)
        {
            final_states.insert(sta);
        }
        s += to_string(ini[i]);
        s += '*';
    }
    q.push(s);
    states[s] = {sta, root->first};
    while (!q.empty())
    {
        bool flag_a = false;
        bool flag_b = false;
        string top = q.front();
        q.pop();
        unordered_set<int> a, b;
        for (int i = 0; i < states[top].second.size(); i++)
        {
            int temp = states[top].second[i];
            if (pos_a.find(temp) != pos_a.end())
            {
                for (int j = 0; j < follow[temp].size(); j++)
                {
                    a.insert(follow[temp][j]);
                }
            }
            if (pos_b.find(temp) != pos_b.end())
            {
                for (int j = 0; j < follow[temp].size(); j++)
                {
                    b.insert(follow[temp][j]);
                }
            }
        }
        vector<int> a_, b_;
        for (auto it : a)
        {
            if (it == destination_marker)
            {
                flag_a = true;
            }
            a_.push_back(it);
        }
        for (auto it : b)
        {
            if (it == destination_marker)
            {
                flag_b = true;
            }
            b_.push_back(it);
        }
        sort(b_.begin(), b_.end());
        sort(a_.begin(), a_.end());
        string temp_a = "";
        string temp_b = "";
        for (int i = 0; i < a_.size(); i++)
        {
            temp_a += to_string(a_[i]);
            temp_a += '*';
        }
        for (int i = 0; i < b_.size(); i++)
        {
            temp_b += to_string(b_[i]);
            temp_b += '*';
        }
        if (states.find(temp_a) == states.end())
        {
            sta++;
            states[temp_a] = {sta, a_};
            q.push(temp_a);
            if (flag_a)
            {
                final_states.insert(sta);
            }
        }
        dfa[states[top].first].first = states[temp_a].first;
        if (states.find(temp_b) == states.end())
        {
            sta++;
            states[temp_b] = {sta, b_};
            q.push(temp_b);
            if (flag_b)
            {
                final_states.insert(sta);
            }
        }
        dfa[states[top].first].second = states[temp_b].first;
    }
}

bool check(map<char, pair<char, char> > &dfa, unordered_set<char> &final_states,string w){
    
    int nu=dfa.size();
   if(w.size()==0)return false;
   
    char curr='A';
    for(int i=0;i<w.size();i++){
        if(w[i]=='a'){
            curr=dfa[curr].first;
        }
        else if(w[i]=='b')curr=dfa[curr].second;
    }
    if(final_states.find(curr)!=final_states.end()) return true;

    
    return false;
    
}

};
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

        inp.push_back(t);
    }
    name.close();

    return inp;
}

void create_output(vector<string> inp,vector<CreateDFA> obj){
    ofstream Output("output.txt");
    string w=inp[0];
    bool flag=0;
    bool flag2=0;
    bool flag3=0;
    for(int i=0;i<w.size();){
        for(int j=w.size()-i;j>0;j--){
            for(int k=1;k<inp.size();k++){
                if(obj[k].check(obj[k].dfa,obj[k].final_states,w.substr(i,j))){
                    if(w[i+j-1]=='\n'){
                        string x="";
                            for(int p=i;p<i+j-1;p++){
                                x+=w[p];
                            }
                            Output<<"<"<<x<<","<<k<<">";
                            flag=1;
                        flag2=1;
                    break;
                    }
                    Output<<"<"<<w.substr(i,j)<<","<<k<<">";
                        flag=1;
                        flag2=1;
                    break;
                }
                
            }
             if(j==1 && !flag){
                if(w.substr(i,1)!="\n"){
                Output<<"<"<<w.substr(i,1)<<","<<0<<">";
                i++;
                break;
                }
                else{
                    // goto end;
                    flag3=1;
                    break;
                }   
            }
            if(flag){
                i=i+j;
                flag=0;
                break;
            }           
        }
        if(flag3)
        break;
    }
    //end:
    Output.close();
    return ;
}

vector<CreateDFA> operations(vector<string> &inp){
    int n = inp.size();
    vector<CreateDFA> obj(n);
    string w = inp[0];
    w.erase(std::remove(w.begin(), w.end(), '\n'), w.cend());
    inp[0] = w;
    for(int i=1;i<=inp.size()-1;i++){
    string s = obj[i].modifyString(inp[i].substr(0, inp[i].size()-1 ));
    string y = obj[i].postfix(s);
    CreateDFA::node *temp = obj[i].create(y);
    int leaf_nodes = obj[i].insertPos(temp, 1);
    obj[i].computeTreeValues(temp);
    obj[i].create_dfa(temp);
    }
    return obj;
}
int main()
{   
    
    vector<string> inp = getInput();

    vector<CreateDFA> obj = operations(inp);

    create_output(inp,obj);
    
    return 0;
}
