package MergeSort;
import java.util.*;


public class MergeSort {

	public MergeSort() {
		// TODO Auto-generated constructor stub
	}


	ArrayList<Integer> mergeSortedArrays(ArrayList<Integer> array1, ArrayList<Integer> array2) {
		
		array1.addAll(array2);
		
		for(int i=0;i<array1.size();i++) {
			for(int j=0;j<array1.size()-1;j++) {
				Integer temp;
				if(array1.get(j) > array1.get(j+1)) {
					temp = array1.get(j);
					array1.set(j, array1.get(j+1));
					array1.set(j+1, temp);
				}
			}
		}
		
		return array1;
	}
	  
	public static void main(String[] args) {
		System.out.println("Hello world!");
		//[0, 3, 4, 31]. [4,6,30]
		ArrayList<Integer> result = new ArrayList<>(Arrays.asList(0, 3, 4, 31));
		result = new MergeSort().mergeSortedArrays(new ArrayList<>(Arrays.asList(0, 3, 4, 31)), new ArrayList<>(Arrays.asList(4,6,30)));
		System.out.println(result);
	}

}
