/**
 * 
 */
package dataStructs;

/**
 * @author mingda.cai
 *
 */
public class LinkedList<T> {

	public Node head;
	public Node tail;
	
	public class Node {
		T data;
		Node next;
		
		Node(T value) {
			data = value;
			next = null;
		}
	}
	
	public void append(T data) {
		Node newNode = new Node(data);
		newNode.next = null;
		
		if(head == null) {
			head = newNode;
			tail = head;
		}
		else {
			while(tail.next != null) {
				tail = tail.next;
			}
			tail.next = newNode;			
			tail = newNode;
		}
	}
	
	public boolean insert(int index, T data) {
		Node newNode = new Node(data);
		if(index == 0) {
			newNode.next = head;
			head = newNode;
		}
		else {
			Node iteratorNode = head;
			Node tempNode;
			while(index != 1) {
				if(iteratorNode.next != null) {
					iteratorNode = iteratorNode.next;
					index --;
				}
				else {
					return false;
				}
			}
			tempNode = iteratorNode.next;
			iteratorNode.next = newNode;
			newNode.next = tempNode;
		}
		return true;
	}
	
	public boolean delete(int index) {
		Node iteratorNode = head;
		if(index == 0) {
			head = head.next;
		}
		else {
			while(index != 1) {
				if(iteratorNode.next != null) {
					iteratorNode = iteratorNode.next;
					index --;
				}
				else {
					return false;
				}
			}
			iteratorNode.next = iteratorNode.next.next;
		}
		return true;
	}
	
	public int size() {
		int i=1;
		Node iteratorNode = head;
		while(iteratorNode != tail) {
			iteratorNode = iteratorNode.next;
			i++;
		}
		return i;
	}
	
	public void reverse() {
		Node currNode = head;
		Node tempHead;
		Node prevNode = null;
		
		while(currNode.next != null) {
			prevNode = currNode;
			currNode = currNode.next;
		}
		prevNode.next = null;
		currNode.next = prevNode;
		tempHead = currNode;
		
		while(head.next != null) {
			currNode = head;
			while(currNode.next != null) {
				prevNode = currNode;
				currNode = currNode.next;
			}
			prevNode.next = null;
			currNode.next = prevNode;
		}
		tail = prevNode;
		head = tempHead;
	}
	
}
