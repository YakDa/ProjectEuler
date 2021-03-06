package findFactorialRecursive;

public class FindFactorialRecursive {

	public FindFactorialRecursive() {
		// TODO Auto-generated constructor stub
	}
	
	// Write two functions that finds the factorial of any number. 
	//One should use recursive, the other should just use a for loop
	//Example: 5!=5*4*3*2*1
	
	static Long findFactorialLoop(Integer num) {
		Long result=(long)1;
		
		for(int i=num;i>0;--i) {
			result=result*i;
		}
		return result;
	}
	
	static Long findFactorialRecursive(Integer num) {
		if(num == 1) return (long)1;
		return num*findFactorialRecursive(--num);
	}

	public static void main(String[] args) {

		int testNum = 6;
		
		System.out.println("The factorial number of " + testNum + " is " + findFactorialRecursive(testNum));
		

	}

}
