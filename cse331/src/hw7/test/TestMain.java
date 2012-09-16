package hw7.test;

import java.io.*;

public class TestMain {
	public static void main(String[] args) throws FileNotFoundException {
		HW7TestDriver a = new HW7TestDriver(new File("hw7/test/myTest.test"), new File("hw7/test/myTest.actual"));
		a.runTests();
	}
}
