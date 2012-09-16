/*
 * Rio Bacon
 * CSE 332
 * April 25th, 2012
 *
 * FourHeap is a priority queue that is constructed with a 4-heap.
 */
public class FourHeap<E> implements PriorityQueue<E> {
	private E[] heap;
	private int size;
	private Comparator<E> comparator;

	private final int CHILD_OFFSET = 2;
	private final int CHILD_COUNT = 4;
	//The value the current heap size is multiplied by when more room is needed.
	private final int EXPAND = 2;

	/*
	 * Creates a heap with an initial size of initSize.
	 */
	public FourHeap(int initSize, Comparator<E> comparator) {
		heap = (E[]) new Object[initSize];
		this.comparator = comparator;
		size = 0;
	}

	/*
	 * Adds the given data to the heap.
	 */
	public void insert(E item) {
		size++;
		//resizes heap
		if (size == heap.length) {
			E[] newHeap = (E[]) new Object[size * EXPAND];
			for (int i = 0; i < heap.length; i++) {
				newHeap[i] = heap[i];
			}
			heap = newHeap;
		}

		heap[size] = item;
		percolateUp(size);
	}

	/*
	 * Returns the first element of the heap.
	 */
	public E findMin() {
		return heap[1];
	}
	
	/*
	 * Removes and returns the first element of the heap.
	 */
	public E deleteMin() {
		E data = heap[1];
		heap[1] = heap[size];
		percolateDown(1);
		size--;
		return data;
	}

	/*
	 * Returns whether the heap is empty.
	 */
	public boolean isEmpty() {
		return size == 0;
	}

	//Percolate up the data at the given index.
	private void percolateUp(int index) {
		if (index != 1) {
			int parentIndex = (index + CHILD_OFFSET) / CHILD_COUNT;
			if (comparator.compare(heap[index], heap[parentIndex]) < 0) {
				E currentData = heap[index];
				heap[index] = heap[parentIndex];
				heap[parentIndex] = currentData;
				percolateUp(parentIndex);
			}
		}
	}

	//Percolate down the data at the given index.
	private void percolateDown(int index) {
		for (int i = 0; i < CHILD_COUNT; i++) {
			int childIndex = index * CHILD_COUNT - CHILD_OFFSET + i; 
			if (childIndex < size && comparator.compare(heap[index], heap[childIndex]) > 0) {
				E currentData = heap[index];
				heap[index] = heap[childIndex];
				heap[childIndex] = currentData;
				percolateDown(childIndex);
			}
		}
	}
}
