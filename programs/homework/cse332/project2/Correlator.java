/* 
 * Rio Bacon
 * CSE 332
 * May 8th, 2012
 *
 * Correlator calculates the correlation between two files. One number is printed
 * representing the correlation.
 */
import java.io.IOException;

public class Correlator {
	private static final double UPPER_BOUND = 0.01;
	private static final double LOWER_BOUND = 0.0001;

	public static void main(String[] args) {
		if (args.length != 3) {
			System.err.println("Usage: data counter implementation, filename, filename");
		} else {
			correlate(args[0], args[1], args[2]);
		}
	}

	//calculates and prints the correlation of the two given files
	private static void correlate(String dataCounter, String file1, String file2) {
		DataCounter<String> counter1 = selectCounter(dataCounter);
		int length1 = fillCounter(counter1, file1);
		DataCounter<String> counter2 = selectCounter(dataCounter);
		int length2 = fillCounter(counter2, file2);
		SimpleIterator<DataCount<String>> iterator = counter1.getIterator();

		//calculates correlation
		double correlation = 0;
		while (iterator.hasNext()) {
			DataCount<String> data1 = iterator.next();
			int count2 = counter2.getCount(data1.data);
			double frequency1 = (double) data1.count / length1;
			double frequency2 = (double) count2 / length2;
			if (frequency1 <= UPPER_BOUND && frequency1 >= LOWER_BOUND 
				&& frequency2 <= UPPER_BOUND && frequency2 >= LOWER_BOUND) {
				double difference = frequency1 - frequency2;
				correlation += difference * difference;
			}
		}

		System.out.println((float) correlation);
	}
	
   //fills the counter with words from the given file, and returns the word count
	private static int fillCounter(DataCounter<String> counter, String file) {
		int count = 0;
		try {
			FileWordReader reader = new FileWordReader(file);
			String word = reader.nextWord();
			while (word != null) {
				 counter.incCount(word);
				 word = reader.nextWord();
				 count++;
			}
		} catch (IOException e) {
			System.err.println("Error processing " + file + " " + e);
			System.exit(1);
		}
		return count;
	}

	 //selects the data structure to keep track of counts.
	 private static DataCounter<String> selectCounter(String dataCounter) {
		if (dataCounter.equals("-a")) {
			return new AVLTree<String>(new StringComparator());
		} else if (dataCounter.equals("-b")) {
			return new BinarySearchTree<String>(new StringComparator());
		} else if (dataCounter.equals("-m")) {
			return new MoveToFrontList<String>(new StringComparator());
		} else if (dataCounter.equals("-h")) {
			return new Hashtable<String>(new StringComparator(), new StringHasher());
		} else {
			System.err.println("Data counter usage: -b, -a, -m, or -h");
			System.exit(1);
			return null;
		}
	 }
}
