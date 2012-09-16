/*
 * Rio Bacon
 * CSE 332
 * April 4th, 2012
 *
 * GListStack is a stack for a given data type, implemented using a linked list. When a value is added,
 * it is added to the top. When a value is removed, it is removed from the top of the list.
 */


import java.util.EmptyStackException;

class GListStack<T> implements GStack<T> {
	Node<T> list;	

	public GListStack() {
		list = null;
	}

	/*
	 * Returns whether the stack is empty or not.
	 */
	public boolean isEmpty() {
		return list == null;
	}	

	/*
	 * Adds the given object to the top of the stack.
	 */
	public void push(T d) {
		Node<T> top = new Node<T>(d); 
		top.next = list;
		list = top;
	}	
	
	/*
	 * Removes and returns the element at the top of the stack.
	 * If the stack is empty, then an EmptyStackException is thrown.
	 */
	public T pop() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		Node<T> top = list;
		list = top.next;
		return top.data;
	}

	/*
	 * Returns the top element of the stack without removing it.
	 * If the stack is empty, then an EmptyStackException is thrown.
	 */
	public T peek() {
		if (isEmpty()) {
			throw new EmptyStackException();
		}

		return list.data;
	}

	/*
	 * A node class for linked lists. Holds objects of the given type. 
	 */
	class Node<T> {
		public T data;
		public Node next;
		
		/*
		 * Constructs a new node, and sets the data of the node to the given object.
		 */
		public Node(T data) {
			this.data = data;
			next = null;
		}
	}
}
