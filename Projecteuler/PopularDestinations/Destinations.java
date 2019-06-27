import java.io.*;
import java.util.*;



public class Destinations {

	private static LinkedList ll;
	private static int numOfDest;

    /*
     * Create a linked list with the input from the input.txt
     * put the destination number to numOfDest
     */

	public static void createList() throws Exception{
		ll = new LinkedList();

        String  thisLine = null;

        // open input stream test.txt for reading purpose.
        BufferedReader br = new BufferedReader(new FileReader("input.txt"));
        while ((thisLine = br.readLine()) != null) {
            ll.add(thisLine);
        }
        thisLine = ll.get(0).toString();
        numOfDest = Integer.parseInt(thisLine);
        ll.remove(0);
        if (numOfDest != ll.size()) {
            throw new EmptyStackException();
        }

	}

    /*
     * Find the most popular destinations
     * from the linked list created
     */

    public static void findPopularDestinations() {
        int tophit_counter = 0;
        int new_counter = 0; 
        int i = 0;
        int j = 0;
        
        for(i = 0; i < numOfDest; i++) {

            /* Find the same destination, only keep one and remove others in the linked list */
            /* record the count the destination is searched, and reduce the number of destinations */
        	new_counter = 1;
        	for (j = i + 1; j < numOfDest; j++) {
        		if(ll.get(i).toString().equals(ll.get(j).toString())) {
                    ll.remove(j);
                    j--;
                    numOfDest--;
                    new_counter++;
        		}
        	}

            /* The first destination, no need to compare with anyone */
            /* Compare the new count with the previous top hit count. If equal, don't do anything */
            /* If bigger than new count, then remove the new destination, and number of destination is reduced by one */
            /* If less than new count, then remove all the previous destinations, and number of destination is reduced accordingly */
            /* and save the new count as the top hit count */
        	if (i == 0) {
        		tophit_counter = new_counter;
        	}
        	else {
        		if (tophit_counter > new_counter) {
        			ll.remove(i);
        			i--;
        			numOfDest--;
        		}
        		else if (tophit_counter < new_counter) {

                    for (j = 0; j <= (i - 1); j++) {
                        ll.remove(0);
                        numOfDest--;
                        showResult();
                    }
                    i = 0;
        			tophit_counter = new_counter;
        		}

        	}

        }

    }

    public static void showResult() {

    	System.out.println("The most popular destinations are: " + ll);
    }
}