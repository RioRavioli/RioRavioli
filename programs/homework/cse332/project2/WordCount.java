import java.io.IOException;

/**
 * An executable that counts the words in a files and prints out the counts in
 * descending order. You will need to modify this file.
 */
public class WordCount {

	/*
	 * Creates and returns an array of DataCounts of the contents of counter.
	 */
	public static <E> DataCount<E>[] getCountsArray(DataCounter<E> counter) {
		DataCount<E> countsArray[] = new DataCount[counter.getSize()];
		SimpleIterator<DataCount<E>> iterator = counter.getIterator();

		int index = 0;
		while (iterator.hasNext()) {
			countsArray[index] = iterator.next();
			index++;
		}

		return countsArray;
	}
	
    private static void countWords(String dataCounter, String sorting, String file) {
		  DataCounter<String> counter = selectCounter(dataCounter);
		  fillCounter(counter, file);
        DataCount<String>[] counts = getCountsArray(counter);

		  if (sorting.equals("-is")) {
			  insertionSort(counts, new DataCountStringComparator());
		  } else if (sorting.equals("-hs")) {
			  heapSort(counts, new DataCountStringComparator());
		  } else if (sorting.equals("-os")) {
			  mergeSort(counts, new DataCountStringComparator());
		  } else {
            System.err.println("Sorting usage: -is, -hs, -os, or -k <number>");
            System.exit(1);
		  }

        for (DataCount<String> c : counts)
            System.out.println(c.count + " \t" + c.data);
    }

	 //Prints top k most prequently used words by sorting the entire set of words
	 //first. This nlog(n) approach is for experimental purposes.
	 private static void printTopKExperimental(String dataCounter, int k, String file) {
		 DataCounter<String> counter = selectCounter(dataCounter);
		 fillCounter(counter, file);
		 DataCount<String>[] counts = getCountsArray(counter);
		 mergeSort(counts, new DataCountStringComparator());
	 	 if (counts.length < k) {
		    k = counts.length;
		 }

		 for (int i = 0; i < k; i++) {
			 System.out.println(counts[i].count + "\t" + counts[i].data);
		 }
	 }

	 /*
	  * Prints the top k most frequently used words in the given file.
	  * (nlog(k) approach)
	  */
	 private static void printTopK(String dataCounter, int k, String file) {
		  DataCounter<String> counter = selectCounter(dataCounter);
		  fillCounter(counter, file);
        DataCount<String>[] counts = getCountsArray(counter);
		  if (counts.length < k) {
			  k = counts.length;
		  }

		  //create new priority queue with min count at front
		  PriorityQueue<DataCount<String>> heap = 
			  new FourHeap<DataCount<String>>(k, new Comparator<DataCount<String>>() {
				  DataCountStringComparator comp = new DataCountStringComparator();
				  public int compare(DataCount<String> c1, DataCount<String> c2) {
					  return -1 * comp.compare(c1, c2);
				  }
			  }); 

		  //add all elements to the queue, but store only up to k elements
		  for (int i = 0; i < counts.length; i++) {
			  heap.insert(counts[i]);
			  if (i >= k) {
				  heap.deleteMin();
			  }
		  }

		  //move all elements from queue to a stack
		  GArrayStack<DataCount<String>> stack = new GArrayStack<DataCount<String>>();
		  while (!heap.isEmpty()) {
			  stack.push(heap.deleteMin());
		  }

		  //print contents of the stack
		  while (!stack.isEmpty()) {
			   DataCount<String> c = stack.pop();
            System.out.println(c.count + " \t" + c.data);
		  }
	 } 

	 //fills the counter with words from the given file
	 private static void fillCounter(DataCounter<String> counter, String file) {
        try {
            FileWordReader reader = new FileWordReader(file);
            String word = reader.nextWord();
            while (word != null) {
                counter.incCount(word);
                word = reader.nextWord();
            }
        } catch (IOException e) {
            System.err.println("Error processing " + file + " " + e);
            System.exit(1);
        }
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
    
    /**
     * Sort the count array in descending order of count. If two elements have
     * the same count, they should be in ordered according to the comparator,
     * but the code below does not do this. 
     * 
     * This code uses insertion sort. The code is generic, but in this project
     * we use it with DataCount<String> and DataCountStringComparator.
     * 
     * @param counts array to be sorted.
	 * @param comparator for comparing elements.
     */
    public static <E> void insertionSort(E[] array, Comparator<E> comparator) {
        for (int i = 1; i < array.length; i++) {
            E x = array[i];
            int j;
            for (j = i - 1; j >= 0; j--) {
                if (comparator.compare(x,array[j]) >= 0) {
                    break;
                }
                array[j + 1] = array[j];
            }
            array[j + 1] = x;
        }
    }

	 /*
	  * Sorts the elements of the array using the given comparator.
	  */
	 public static <E> void heapSort(E[] array, Comparator<E> comparator) {
		 PriorityQueue<E> heap = new FourHeap<E>(array.length, comparator);
		 for (int i = 0; i < array.length; i++) {
			 heap.insert(array[i]);
		 }
		 for (int i = 0; i < array.length; i++) {
			 array[i] = heap.deleteMin();
		 }
	 }

	 /*
	  * Sorts the elements of the array using the given comparator.
	  */
	 public static <E> void mergeSort(E[] array, Comparator<E> comparator) {
		 if (array.length > 1) {
			 //split array into two halves
			 int middle = array.length / 2;
			 E[] leftSide = (E[]) new Object[middle];
			 E[] rightSide = (E[]) new Object[array.length - middle];
			 for (int i = 0; i < middle; i++) {
				 leftSide[i] = array[i];
			 }
			 for (int i = middle; i < array.length; i++) {
				 rightSide[i - middle] = array[i];
			 }	 

			 //sort arrays
			 mergeSort(leftSide, comparator);
			 mergeSort(rightSide, comparator);

			 //merge arrays
			 int mergedIndex = 0;
			 int leftIndex = 0;
			 int rightIndex = 0;
			 while (mergedIndex < array.length) {
				 if (leftIndex < leftSide.length && rightIndex < rightSide.length) {
					 int comparison = comparator.compare(leftSide[leftIndex], rightSide[rightIndex]);
					 if (comparison <= 0) {
						 array[mergedIndex] = leftSide[leftIndex]; 
						 leftIndex++;
					 } else {
						 array[mergedIndex] = rightSide[rightIndex]; 
						 rightIndex++;
					 }
				 } else if (leftIndex < leftSide.length) {
					 array[mergedIndex] = leftSide[leftIndex];
					 leftIndex++;
				 } else {
					 array[mergedIndex] = rightSide[rightIndex];
					 rightIndex++;
				 }
				 mergedIndex++;
			 }
		 }
	 }
    
    public static void main(String[] args) {
		  if (args.length == 4 && args[1].equals("-k")) {
			  printTopK(args[0], Integer.parseInt(args[2]), args[3]);
			  //printTopKExperimental(args[0], Integer.parseInt(args[2]), args[3]);
		  } else if (args.length != 3) {
            System.err.println("Usage: data counter implementation, sorting implmentation, and filename of document to analyze");
            System.exit(1);
        } else {
			  countWords(args[0], args[1], args[2]);
		  }
    }
}









