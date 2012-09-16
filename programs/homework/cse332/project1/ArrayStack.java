/*
 * Rio Bacon
 * CSE 332
 * April 4th, 2012
 *
 * ArrayStack is a stack for doubles implemented using an array. Values added to the
 * stack are put on top, and when a value is removed, the top value is removed.
 */


import java.util.EmptyStackException;

class ArrayStack implements DStack {
	private double[] data;
	private int size;

	private final int EMPTY_SIZE = 0;
	private final int INITIAL_SIZE = 10;

	//The value the current array size is multiplied by when more room is needed.
	private final int EXPAND = 2;

	/*
	 * Constructs an empty stack.
	 */
	public ArrayStack() {
		data = new double[INITIAL_SIZE];
		size = EMPTY_SIZE;
	}

	/*
	 * Returns whether the stack is empty or not.
	 */ 
	public boolean isEmpty() {
		return size == EMPTY_SIZE;
	}

	/*
	 * Adds the given double to the top of the stack.
	 */
	public void push(double d) {
		size++;

		//If the current array runs out of room, a larger array is created and used. 
		if (size > data.length) {
			int largerSize = data.length * EXPAND;
			double[] largerData = new double[largerSize];
			for (int i = 0; i < data.length; i++) {
				largerData[i] = data[i];
			}
			data = largerData;
		}

		data[size - 1] = d;
	}

	/*
	 * Removes and returns the double at the top of the stack.
	 * If the stack is empty, an EmptyStackException is thrown.
	 */
	public double pop() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		size--;
		return data[size];
	}

	/*
	 * Returns the double at the top of the stack without removing it.
	 * If the stack is empty, an EmptyStackException is thrown.
	 */	
	public double peek() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		return data[size - 1];
	}
}
