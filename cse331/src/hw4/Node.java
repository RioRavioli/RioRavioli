package hw4;

import java.util.*;

/** 
 * Node represents a mutable node in a graph.
 * It contains a name of type N to uniquely identify it, and any edges that
 * point to other nodes with labels of type E.
 */


public class Node<N, E> {
/*
 * Specification fields
 * 	@specfield name : N                   //identifies this
 * 	@specfield edges : list of (N, E)  //edges contains destination and label
 *
 * Abstract Invariant
 * 	A name must not be null
 * 	List of edges must not be null
 *
 * Abstraction Function
 * 	AF(r) = node n, such that
 * 		n.name = r.name
 * 		n.edges = (edges.keySet(), edges.values()) //list of destinations, list of labels
 *
 * Representation Invariant
 * 	name != null
 * 	edges != null
 */
	N name;
	Map<N, List<E>> edges;

	/**
	 * Constructs a new Node with the given name.
	 * @requires name is non-null.
	 * @param name the unique identifier for this node.
	 */
	public Node(N name) {
		this.name = name;
		edges = new HashMap<N, List<E>>();
		checkRep();
	}

	/**
	 * Returns the name of this Node.
	 * @return name
	 */
	public N getName() {
		checkRep();
		return name;
	}

	/**
	 * Returns all edges' labels of the destination Node with the given name.
	 * @requires destName is an existing destination. 
	 * @return list of labels of all edges with the destination 
	 * Node with the given name.
	 */
	public List<E> getEdgesLabels(N destName) {
		checkRep();
		List<E> labels = edges.get(destName);
		//Collections.sort(labels);
		checkRep();
		return Collections.unmodifiableList(labels);
	}

	/**
	 * Returns true if this Node contains an edge with with a destination node with the
	 * given name.
	 * @return true if this Node has edge with given name.
	 */
	public boolean containsEdge(N destName) {
		checkRep();
		return edges.containsKey(destName); 
	}

	/**
	 * Adds an edge with the given destination and label to this Node.
	 * @requires destName and label are non-null.
	 * @param destName the node that the edge points to.
	 * @param label the description attached to the edge.
	 * @modifies this
	 * @effects adds a new edge to this Node.
	 */
	public void addEdge(N destName, E label) {
		checkRep();
		if (containsEdge(destName)) {
			//if new destination node
			List<E> labels = edges.get(destName);
			labels.add(label);
		} else {
			//if existing destination node
			List<E> labels = new ArrayList<E>();
			labels.add(label);
			edges.put(destName, labels);
		}
		checkRep();
	}

	/**
	 * Removes all edges with the given destination.
	 * @requires destName is non-null.
	 * @param destname the Node that the edges that will get removed point to.
	 * @modifies this
	 * @effects removes all edges that contain the given destination.
	 */
	public void removeEdges(N destName) {
		checkRep();
		if (containsEdge(destName)) {
			edges.remove(destName);
		}
		checkRep();
	}	

	/**
	 * Returns the names of all Nodes that edges point to.
	 * @return set of all names of the Nodes that edges point to. If there are no
	 * 			edges, an empty list is returned. 
	 */
	public Set<N> getAllDests() {
		checkRep();
		return Collections.unmodifiableSet(edges.keySet());
	}

	//checks to ensure that representation invariant is held
	private void checkRep() {
		if (name == null) {
			throw new RuntimeException("name should not be null");
		}
		if (edges == null) {
			throw new RuntimeException("edges should not be null");
		}
	}
}
