/*
 * Rio Bacon
 * CSE 332
 * May 8, 2012
 *
 * A Hasher that returns a hashcode for a string.
 */

public class StringHasher implements Hasher<String> {
	/*
	 * Returns a hash value for the given String.
	 */
	public int hash(String s) {
		int hashValue = 0;
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			hashValue += ((int) c + i * i);
		}
		return hashValue;
	}

	//alternate hash function for experimentation
/*	public int hash(String s) {
		return 0;
	}
*/
}
