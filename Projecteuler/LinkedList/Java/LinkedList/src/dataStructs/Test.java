/**
 * 
 */
package dataStructs;

import java.util.concurrent.Semaphore;

/**
 * @author mingda.cai
 *
 */
public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		LinkedList<Integer> intLinkedList = new LinkedList<Integer>();
		
		intLinkedList.append(1);
		intLinkedList.append(2);
		intLinkedList.append(3);
		intLinkedList.append(4);
		intLinkedList.append(5);
		intLinkedList.append(6);
		intLinkedList.append(7);
		intLinkedList.append(8);
		intLinkedList.append(9);
		intLinkedList.append(10);
		intLinkedList.insert(0, 0);
		intLinkedList.insert(1, 1);
		intLinkedList.insert(1, 1);
		intLinkedList.delete(1);
		intLinkedList.delete(1);
		
		LinkedList<Integer>.Node currNode = intLinkedList.head;
		
		while(currNode != null) {
			System.out.print(currNode.data + " ");
			currNode = currNode.next;
		}
		System.out.print("Size=" + intLinkedList.size());
		
		System.out.print("\n");
		
		intLinkedList.reverse();
		currNode = intLinkedList.head;
		while(currNode != null) {
			System.out.print(currNode.data + " ");
			currNode = currNode.next;
		}
		System.out.print("Size=" + intLinkedList.size());
		
		
		

	}

}
