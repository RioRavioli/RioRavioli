/*
 * Rio Bacon
 * CSE 332
 * April 25, 2012
 *
 * A Comparator that sorts two DataCounts in alphabetical order.
 */

public class StringComparator implements Comparator<String> {
	/*
	 * Sorts s1 and s2. If s1 come first alphabetically, a negative number is returned.
	 * Otherwise, a positive number is returned.
	 */
	public int compare(String s1, String s2) {
		int shorterLength = 0;
		if (s1.length() < s2.length()) {
			shorterLength = s1.length();
		} else {
			shorterLength = s2.length();
		}

		for (int i = 0; i < shorterLength; i++) {
			if (s1.charAt(i) != s2.charAt(i)) {
				return s1.charAt(i) - s2.charAt(i); 
			}
		}
		return s1.length() - s2.length();
	}
}
