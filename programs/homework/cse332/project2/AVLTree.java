/*
 * Rio Bacon
 * CSE 332
 * April 25th, 2012
 * 
 * AVLTree is a special type of binary tree that has a property where the left and right
 * children of each node only differs its height by 1. Elements added are sorted like
 * a binary search tree.
 */

public class AVLTree<E> extends BinarySearchTree<E> implements DataCounter<E> {

	/*
	 * The Node class that AVLTree will use.
	 * Keeps track of height in addition to BSTNode functionality.
	 */
	private class AVLNode extends BSTNode {
		public int height;

		public AVLNode(E d) {
			super(d);
			height = 0;
		}
	}

	/*
	 * Constructs a new empty AVLTree. The given comparator is used for sorting the elements. 
	 */
	public AVLTree(Comparator<? super E> c) {
		super(c);
	}

	/*
	 * Increments the count for the given data element.
	 */
	public void incCount(E data) {
		if (overallRoot == null) {
			overallRoot = new AVLNode(data);
		} else {
			overallRoot = incCount((AVLNode) overallRoot, data);
		}
	}

		// traverse the tree
	private AVLNode incCount(AVLNode currentNode, E data) {
		// compare the new data with the data at the current node
		int cmp = comparator.compare(data, currentNode.data);

		if (cmp == 0) {
			// current node is a match
			currentNode.count++;
		} else if (cmp < 0) {
			// new data goes to the left of the current node
			if (currentNode.left == null) {
				currentNode.left = new AVLNode(data);
			} else {
				currentNode.left = incCount((AVLNode) currentNode.left, data);
			}
		} else {
			// new data goes to the right of the current node
			if (currentNode.right == null) {
				currentNode.right = new AVLNode(data);
			} else {
				currentNode.right = incCount((AVLNode) currentNode.right, data);
			}
		}

		// check for imbalance
		int leftHeight = getHeight((AVLNode) currentNode.left);
		int rightHeight = getHeight((AVLNode) currentNode.right);;
		if (leftHeight - rightHeight > 1) {

			// case left child height is greater than right child height by more than 1
			int leftLeftHeight = getHeight((AVLNode) currentNode.left.left);
			int leftRightHeight = getHeight((AVLNode) currentNode.left.right);
			if (leftLeftHeight > leftRightHeight) {
				// case left left grandchild causing disbalance
				currentNode = balanceLeftLeft(currentNode);
			} else {
				// case left right grandchild causing disbalance
				currentNode = balanceLeftRight(currentNode);
			}	
		} else if (rightHeight - leftHeight > 1) {

			//case right child height is greater than left child height by more than 1
			int rightRightHeight = getHeight((AVLNode) currentNode.right.right);
			int rightLeftHeight = getHeight((AVLNode) currentNode.right.left);
			if (rightRightHeight > rightLeftHeight) {
				// case right right grandchild causing disbalance
				currentNode = balanceRightRight(currentNode);
			} else {
				// case right left grandchild causing disbalance
				currentNode = balanceRightLeft(currentNode);
			}	
		}

		setNewHeight(currentNode);
		return currentNode;
	}

	// Rebalances the tree at the given node, if left left grandchild is causing disbalance.
	private AVLNode balanceLeftLeft(AVLNode currentNode) {
		AVLNode newTopNode = (AVLNode) currentNode.left;
		currentNode.left = newTopNode.right;
		newTopNode.right = currentNode;
		setNewHeight(currentNode);
		return newTopNode;
	}

	// Rebalances the tree at the given node, if right right grandchild is causing disbalance.
	private AVLNode balanceRightRight(AVLNode currentNode) {
		AVLNode newTopNode = (AVLNode) currentNode.right;
		currentNode.right = newTopNode.left;
		newTopNode.left = currentNode;
		setNewHeight(currentNode);
		return newTopNode;
	}

	// Rebalances the tree at the given node, if left right grandchild is causing disbalance.
	private AVLNode balanceLeftRight(AVLNode currentNode) {
		AVLNode futureTopNode = (AVLNode) currentNode.left.right;
		currentNode.left.right = futureTopNode.left;
		futureTopNode.left = currentNode.left; 
		currentNode.left = futureTopNode;
		AVLNode newTopNode = balanceLeftLeft(currentNode);
		setNewHeight((AVLNode) newTopNode.left);
		return newTopNode;
	}

	// Rebalances the tree at the given node, if right left grandchild is causing disbalance.
	private AVLNode balanceRightLeft(AVLNode currentNode) {
		AVLNode futureTopNode = (AVLNode) currentNode.right.left;
		currentNode.right.left = futureTopNode.right;
		futureTopNode.right = currentNode.right; 
		currentNode.right = futureTopNode;
		AVLNode newTopNode = balanceRightRight(currentNode);
		setNewHeight((AVLNode) newTopNode.right);
		return newTopNode;
	}

	// Sets the new height of the given node.
	private void setNewHeight(AVLNode node) {
		int leftHeight = getHeight((AVLNode) node.left);
		int rightHeight = getHeight((AVLNode) node.right);;
		node.height = Math.max(leftHeight, rightHeight) + 1;
	}

	// Returns the height of the given node, returning -1 if null.
	private int getHeight(AVLNode node) {
		if (node == null) {
			return -1;
		} else {
			return node.height;
		}
	}
}
