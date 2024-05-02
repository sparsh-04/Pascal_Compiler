struct ast_node
{
    char *node_type;
    // char *value;
    struct ast_node *left;
    struct ast_node *right;
};
struct node
{
    char name[100];
    struct ast_node *nd;
};
struct var_name
{
    char name[100];
    struct node *nd;
    char if_body[5];
    char else_body[5];
    char type[5];
};
struct var_name2
{
    char name[100];
    struct node *nd;
    char type[5];
};