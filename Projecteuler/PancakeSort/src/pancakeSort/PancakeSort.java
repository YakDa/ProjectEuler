/**
 * 
 */
package pancakeSort;
import java.io.*;
import java.util.*;

/**
 * @author mingda.cai
 *
 *[1,5,4,3,2]
 *[2,3,4,5,1]
 *[5,4,3,2,1] 
 *
 *
 */
public class PancakeSort {

	/**
	 * @param args
	 * time complexity: L(L+L+L) => O(n2)
	 */
	static void flip(int[] arr, int k) {
		if(k<2) return;
		for(int i=0;i<k/2;++i) {
			int temp = arr[i];
			arr[i] = arr[k-1-i];
			arr[k-1-i] = temp;
		}
		
	}
	static int[] pancakeSort(int[] arr) {
		for(int i=0;i<arr.length;++i) {
			int min = Integer.MAX_VALUE;
			int minIndex = 0;
			for(int j=0;j<arr.length-i;++j) {
				if(arr[j] <= min) {
					min = arr[j];
					minIndex = j;
				}
			}
			flip(arr, minIndex+1);
			flip(arr, arr.length-i);
		}
		
		flip(arr, arr.length);
		
		return arr;
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int[] arr = {1,5,4,3,2, 6, 9, 8, 11, 7, 3, 9};
		pancakeSort(arr);
		for(int i:arr) {
			System.out.println(i + " ");
		}
		

	}

}
