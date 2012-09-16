/*
 * Rio Bacon
 * CSE 332
 * April 4th, 2012
 *
 * ListStack is a stack for double implemented using a linked list. When a value is added,
 * it is added to the top. When a value is removed, it is removed from the top of the list.
 */


import java.util.EmptyStackException;

class ListStack implements DStack {
	doubleNode list;	

	public ListStack() {
		list = null;
	}

	/*
	 * Returns whether the stack is empty or not.
	 */
	public boolean isEmpty() {
		return list == null;
	}	

	/*
	 * Adds the given double to the top of the stack.
	 */
	public void push(double d) {
		doubleNode top = new doubleNode(d); 
		top.next = list;
		list = top;
	}	
	
	/*
	 * Removes and returns the double at the top of the stack.
	 * If the stack is empty, then an EmptyStackException is thrown.
	 */
	public double pop() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		doubleNode top = list;
		list = top.next;
		return top.data;
	}

	/*
	 * Returns the top double of the stack without removing it.
	 * If the stack is empty, then an EmptyStackException is thrown.
	 */
	public double peek() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		return list.data;
	}

	/*
	 * A node class for linked lists. Holds doubles. 
	 */
	class doubleNode {
		public double data;
		public doubleNode next;
		
		/*
		 * Constructs a new node, and sets the data of the node to the given double.
		 */
		public doubleNode(double data) {
			this.data = data;
			next = null;
		}
	}
}
