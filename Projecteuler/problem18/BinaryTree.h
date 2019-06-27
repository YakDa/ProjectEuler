#ifndef BINARY_TREE_
#define BINARY_TREE_

// binary tree node structure
struct TreeNode
{
	int data;
	struct TreeNode* lchild;
	struct TreeNode* rchild;
};

long sum;
long max;

// binary tree tranversal function
// inpout: the address of root node
void binary_tree_tranversal(struct TreeNode* node);

#endif
