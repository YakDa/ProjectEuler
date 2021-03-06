package com.mingdos.greeter;

public class Greeter {

	public Greeter() {
		// TODO Auto-generated constructor stub
	}

	public void greet(Greeting greeting) {
		greeting.perform();
	}
	
	public static void main(String[] args) {
		
		Greeter greeter = new Greeter();
		
		Greeting helloWorldGreeting = new HelloWorldGreeting();
		greeter.greet(helloWorldGreeting);
		

	}

}
