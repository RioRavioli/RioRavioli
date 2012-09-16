import java.util.*;

/*
 * Rio Bacon
 * CSE 332
 * May 8th, 2012
 *
 * TimingTestTopK tests the time it takes WordCount to print the top k words, and prints
 * the time.
 */

public class TimingTestTopK {
	public static void main(String[] args) {
		Queue<Integer> times = new LinkedList<Integer>();
		for (int i = 0; i < 5501; i += 500) {
			long start = System.currentTimeMillis();
			WordCount.main(new String[]{"-h", "-k", "" + i, "hamlet.txt"});
			long end = System.currentTimeMillis();
			times.add(i);
			times.add((int) (end - start));
		}	

		System.out.println();
		while (!times.isEmpty()) {
			System.out.print(times.remove() + "     ");
			System.out.println(times.remove());
		}
	}
}
