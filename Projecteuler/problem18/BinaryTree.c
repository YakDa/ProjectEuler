#include <stdio.h>
#include "BinaryTree.h"

void binary_tree_tranversal(struct TreeNode* node)
{
	// sum all the tranversed node data
	sum = sum + node->data;
	if (node->lchild != NULL)
		binary_tree_tranversal(node->lchild);
	else
	{
		// reached the end of tree, and calculate the max number
		if(sum >= max)
			max = sum;
	}
	if (node->rchild != NULL)
		binary_tree_tranversal(node->rchild);
	else
	{
		// reached the end of tree, and calculate the max number
		if (sum >= max)
			max = sum;
	}

	// if the node is already tranversed, then remove the data from sum, otherwise it will impact the next calculation.
	sum = sum - node->data;
	return;
}