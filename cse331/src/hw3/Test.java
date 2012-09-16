package hw3;
import java.util.*;
class Test {
	public static void main(String[] args) {
		List<RatTerm> list = new ArrayList<RatTerm>();
		RatPoly test = new RatPoly(1, 2);
		RatPoly test2 = new RatPoly(-2, 1);
		RatPoly test3 = test.add(test2);
		System.out.println(test3.eval(1));
	}
}
