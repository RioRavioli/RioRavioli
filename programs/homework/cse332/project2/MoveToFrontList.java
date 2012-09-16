/*
 * Rio Bacon
 * CSE 332
 * April 25th, 2012
 *
 * MoveToFrontList is a linked list, where newly added elemnts are in front, but elements that
 * are accessed also move to the front. 
 */

public class MoveToFrontList<E> implements DataCounter<E> {
	private Node front;
	private int size;
	private Comparator<? super E> comparator;

	/*
	 * The Node class that MoveToFrontList will use.
	 */
	private class Node {
		public Node next;
		public E data;
		public int count;

		public Node(E d) {
			data = d;
			count = 1;
			next = null;
			size++;
		}
	}

	/*
	 * Contructs a new, empty list. The given comparator is used for sorting elements.
	 */
	public MoveToFrontList(Comparator<? super E> c) {
		front = null;
		size = 0;
		comparator = c;
	}

	/*
	 * Increments the count for the given data element.
	 */
	public void incCount(E data) {
		if (front == null) {
			front = new Node(data);
		} else if (comparator.compare(data, front.data) == 0) {
			front.count++;
		} else { 

			Node current = front;
			while (current.next != null) {
				if (comparator.compare(data, current.next.data) == 0) {
					//increment count, and move the data to the front
					Node temp = current.next.next;
					current.next.next = front;
					front = current.next;
					current.next = temp;
					front.count++;
					return;
				} 
				current = current.next;
			}

			current = front;
			front = new Node(data);
			front.next = current;
		}
	}

	/*
	 * Returns the count of data in the list.
	 */
	public int getCount(E data) {
		Node current = front;
		while (current != null) {
			if (comparator.compare(data, current.data) == 0) {
				return current.count;
			}
			current = current.next;
		}
		return 0;
	}

	/*
	 * Returns the size of the list.
	 */
	public int getSize() {
		return size;
	}

	/*
	 * Returns a simpleIterator of the elements of the list. There is no
	 * guarantee about the order of the elements.
	 */
	public SimpleIterator<DataCount<E>> getIterator() {
		return new SimpleIterator<DataCount<E>>() {
			Node current = front;

			public boolean hasNext() {
				return current != null;
			}

			public DataCount<E> next() {
				if (!hasNext()) {
					throw new java.util.NoSuchElementException();
				}
				DataCount<E> data = new DataCount<E>(current.data, current.count);
				current = current.next;
				return data;
			}
		};
	}
}















