public class Test {
	public static void main(String[] args) {
		DataCounter<String> counter = new AVLTree<String>(new StringComparator());

		String[] words = {"hello",
								"yo",
								"sup",
								"asup",
								"easntsup",
								"eesup",
								"bbsup",
								"aasup"/*,
								"no"*/};
		for (int i = 0; i < words.length; i++) {
			counter.incCount(words[i]);
		}
		System.out.println();

		SimpleIterator<DataCount<String>> iterator = counter.getIterator();
		while (iterator.hasNext()) {
			DataCount next = iterator.next();
			System.out.println(next.data);
			System.out.println("                    " + next.count);
		}
	}
}
