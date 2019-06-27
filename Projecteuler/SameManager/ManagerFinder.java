import java.io.*;
import java.util.*;


public class ManagerFinder {
	public Node root;
	public String targetX;
	public String targetY;
	public int numOfEmp;
	private Node[] employees;
	private int counter;

	public void ManagerFinder(){
		root = null;
	}

    /*
     * Create a two directional binary tree from the input.txt file 
     */

	public void create() throws Exception {
		String[] temp = new String[2];
		String thisLine;
		int indexX;
		int indexY;

	    BufferedReader br = new BufferedReader(new FileReader("input.txt"));

	    if ((thisLine = br.readLine()) != null) {
	    	numOfEmp = Integer.parseInt(thisLine);
	    	System.out.println(numOfEmp);
	    }

	    employees = new Node[numOfEmp];

        if ((thisLine = br.readLine()) != null) {
	    	targetX = thisLine;
	    	System.out.println(targetX);
	    }

        if ((thisLine = br.readLine()) != null) {
	    	targetY = thisLine;
	    	System.out.println(targetY);
	    }

        if ((thisLine = br.readLine()) != null) {
	    	temp = thisLine.split(" ");
	    	System.out.println(temp[0] + " " + temp[1]);
	    }

	    employees[0] = new Node(temp[0]);
	    employees[1] = new Node(temp[1]);
	    root = employees[0];

	    counter = 1;
	    employees[0].left = employees[1];
	    employees[1].parent = employees[0];

        while ((thisLine = br.readLine()) != null) {
            temp = thisLine.split(" ");
            System.out.println(temp[0] + " " + temp[1]);
            indexX = findEmp(temp[0]);
            indexY = findEmp(temp[1]);

            if (indexX == -1) {
            	counter++;
                indexX = counter;
            	employees[indexX] = new Node(temp[0]);
            }
            if (indexY == -1) {
            	counter++;
            	indexY = counter;
            	employees[indexY] = new Node(temp[1]);
            }

            if (employees[indexX].left == null) {

            	employees[indexX].left = employees[indexY];
            	employees[indexY].parent = employees[indexX];
            }
            else if (employees[indexX].right == null) {

            	employees[indexX].right = employees[indexY];
            	employees[indexY].parent = employees[indexX];
            }
            else {
            	throw new EmptyStackException();
            }

        }


        
	}

    /*
     * Find the node in the employee list and return the index of the desired employee in the list
     * return: index of the employee in the list
     *         -1 employee not found
     */

	private int findEmp(String name) {
        int i;
        for (i = 0; i <= counter; i++) {
        	if(employees[i].name.equals(name))
        		return i;
        }
        return -1;
	}

    /*
     * Find the direct common manager of the two employees
     */
	public void findSameManager() {
        String[] manageLineX = new String[numOfEmp];
        String[] manageLineY = new String[numOfEmp];
        String commonManager = null;
        Node current;
        int index;
        int counterX = 0;
        int counterY = 0;
        int i;


        index = findEmp(targetX);
        current = employees[index];

        manageLineX[0] = targetX;
        while(current != root) {
            counterX++;
            current = current.parent;
            manageLineX[counterX] = current.name;

        }

        index = findEmp(targetY);
        current = employees[index];

        manageLineY[0] = targetY;
        while(current != root) {
            counterY++;
            current = current.parent;
            manageLineY[counterY] = current.name;

        }

        for (i = 0; i < numOfEmp; i++) {
        	if (((counterX - i) >= 0) && ((counterY - i) >= 0)
        		  && (manageLineX[counterX - i].equals(manageLineY[counterY - i]))) {
        		commonManager = manageLineX[counterX - i];
        	}
        	else
        		break;
        }

        System.out.println("The common manager is: " + commonManager);
        
	}

}