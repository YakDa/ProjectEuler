/*
 * Class for the Node in the two directional binary tree
 * Members:
 *     left node
 *     right node
 *     parent node
 */

public class Node {
	public String name;
	public Node left;
	public Node right;
	public Node parent;

	public Node(String name) {
		this.name = name;
		this.left = null;
		this.right = null;
		this.parent = null;
	}
}