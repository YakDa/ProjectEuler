package Fabonacci;

import java.util.HashMap;
import java.util.Map;

public class Fabonacci {

	public Fabonacci() {
		// TODO Auto-generated constructor stub
	}
	
	public int count=0;
	
	private int fabonacciCalc(int n) {
		count++;
		if(n<=2) return n-1;
		
		return fabonacciCalc(n-1) + fabonacciCalc(n-2);
	}
	
	private int fabonacciCalcDynamicProgramming(Map<Integer,Integer> cache, int n) {
		if(cache.containsKey(n)) {
			return cache.get(n);
		}
		else {
			count++;
			if(n<=2) return n-1;
			cache.put(n, fabonacciCalcDynamicProgramming(cache, n-1) + fabonacciCalcDynamicProgramming(cache, n-2));
			return cache.get(n);
		}	
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Fabonacci fab = new Fabonacci();
		Map<Integer, Integer> cache = new HashMap<>();
		//System.out.println(fab.fabonacciCalc(9));
		System.out.println(fab.fabonacciCalcDynamicProgramming(cache, 9));
		System.out.println("Number of calculation: " + fab.count);
	}

}
