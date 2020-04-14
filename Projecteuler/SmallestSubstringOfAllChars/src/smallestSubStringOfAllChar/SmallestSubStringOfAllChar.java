/**
 * 
 */
package smallestSubStringOfAllChar;
import java.io.*;
import java.util.*;

/**
 * @author mingda.cai
 * 
 */

/*
 *  [x, y, z] "xyyzyzyx"
 *  list = x, y, z
 * */
public class SmallestSubStringOfAllChar {

	static String getShortestUniqueSubstring(char[] arr, String str) {
		int start = 0;
		int end = 0;
		int min = str.length();

		ArrayList<Character> charList = new ArrayList<>();
		
		for(int i=0;i<str.length();++i) {
			for(char c: arr) {
				charList.add(c);
			}

			for(int j=i;j<str.length();++j ) {
				if(charList.contains(str.charAt(j))) {
					charList.remove(charList.indexOf(str.charAt(j)));
					if(charList.isEmpty()) {
						if(j-i<min) {
							min = j-i;
							start = i;
							end = j;
						}
					}
				}
			}
		}
		
		return str.substring(start, end+1);
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		char[] arr = {'x', 'y', 'z'};
		String str = "xyyzyzyx";
		
		System.out.println(getShortestUniqueSubstring(arr, str));
	}

}
