public class HasherTest {
	public static void main(String[] args) {
		Hashtable<String> table = new Hashtable<String>(new StringComparator(), new StringHasher());
		table.incCount("hello");
		table.incCount("hello");
		table.incCount("hell");
		table.incCount("helli");
		table.incCount("asonetuhaosnetuhaosnetuh");
		for (int i = 0; i < 50; i++) {
			table.incCount("eth " + i);
		}
		SimpleIterator<DataCount<String>> iterator = table.getIterator();
		for (DataCount<String> data : table.hashtable) {
			if (data == null) {
				System.out.println("null");
			} else {
				System.out.println(data.data);
			}
		}
		System.out.println();
		while(iterator.hasNext()) {
			System.out.println(iterator.next().data);
		}

		System.out.println(table.getSize());
	}
}
