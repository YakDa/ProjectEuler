#include <stdio.h>
#include <string.h>
#include "BinaryTree.h"

struct TreeNode treeNode[6000];

int main(int argc, char const *argv[])
{
	FILE* fp;
	long len = 0;
	long cusor = 0;
	char fileName[20];
	if (argc != 2)
	{
		printf("Please enter file name: ");
		scanf("%s", fileName);
		// remove new line
		int slen = strlen(fileName);
		if(slen>0 && fileName[slen-1] == '\n')
			fileName[slen-1] = '\0';
	}
	else
	{
		for (int i = 0; i < strlen(argv[1]); ++i)
		{
			fileName[i] = argv[1][i];
		}
		
	}

    // open data file
	fp = fopen("data.txt", "r");

	sum = 0;
	max = 0;

    // read data file to all nodes
	while(fscanf(fp, "%d ", &treeNode[len].data) != EOF) {
        len++;
    }

    // build binary tree
    for (int i = 1; i <= 100; ++i)
    {
    	for (int j = 1; j <= i; ++j)
    	{
    		treeNode[cusor].lchild = &treeNode[cusor+i];
    		treeNode[cusor].rchild = &treeNode[cusor+i+1];
    		cusor++;
    		if (cusor+i+1 == len)
    		{
    			goto StartTranversal;
    		}
    	}
    }

StartTranversal:

    // tranversal the binary tree
    binary_tree_tranversal(&treeNode[0]);

    printf("First node = %d\n", treeNode[0].data);
    printf("Left child of first node = %d\n", treeNode[0].lchild->data);
    printf("Right child of first node = %d\n", treeNode[0].rchild->data);
    printf("Max number = %ld\n", max);

	return 0;
}