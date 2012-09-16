/**
 * MarvelPaths2 uses information given from a file and returns a path between two
 * characters based on character occurances throughout the books, where the path
 * with most books relating the characters is selected.
 */

package hw6;
import hw4.*;
import hw5.*;

import java.util.*;

public class MarvelPaths2 {
	/*
	 * Specification fields
	 * 	@specfield marvelGraph : graph of characters linked to other charaters
	 * 		by book appearance.
	 *
	 * Abstraction Invariant
	 * 	the graph cannot be null
	 *
	 * Abstraction Function
	 * 	AF(r) = marvelPaths2 g, such that
	 * 		g.marvelGraph.marvelGraph || g.customGraph = marvelGraph
	 *
	 * Representation Invariant
	 * 	customGraph != null 
	 */
	private MarvelPaths marvelGraph;
	private Graph<String, Double> customGraph;

	/**
	 * Creates a new MarvelPaths2 object. j
	 * @effects creates a new empty graph.
	 */
	public MarvelPaths2() {
		customGraph = new Graph<String, Double>();
		checkRep();
	}

	/**
	 * Adds the given character to the graph.
	 * @param character a node wil be created representing character, if it
	 * already does not exist. Else nothing happens.
	 * @modifies this
	 * @effects a new node may potentially be created.
	 */
	public void addCharacter(String character) {
		checkRep();
		customGraph.createNode(character);
		checkRep();
	}

	/**
	 * Adds a coappearance between two characters to the graph.
	 * @param character1 one character that appears in book.
	 * @param character2 the other character that appears in book.
	 * @param weight the weight of books that character1 and character2 appear in, 
	 * where weight is one over the number of books.
	 * @modifies this
	 * @effects a new relationship between two characters is added, but only
	 * points from character1 to character2.
	 */
	public void addCoappearance(String character1, String character2, double weight) {
		checkRep();
		customGraph.createEdge(character1, character2, weight);
		checkRep();
	}

	/**
	 * Get the list of characters in this graph.
	 * @Return list of characters representing this graph.
	 */
	public List<String> getCharacters() {
		checkRep();
		if (marvelGraph == null) {
			return customGraph.getNodeNames();
		} else {
			return marvelGraph.getCharacters();
		}
	}

	/**
	 * Get the weight of the books between the two characters, where the weight is one
	 * over the number of books that both characters appear in together.
	 * @param character1 one character that exists in a book.
	 * @param character2 the other character that exists in the same book.
	 * @throws IllegalArgumentException if character1 or character2 is null.
	 * @return weight of books in which the two characters appear together in, or
	 * null if neither character is not in the graph.
	 */
	public List<Double> getBookWeight(String character1, String character2) {
		checkRep();
		if (marvelGraph == null) {
			List<Double> weights = customGraph.getEdgesLabels(character1, character2);
			List<Double> toSort = new ArrayList<Double>(weights);
			Collections.sort(toSort);
			return toSort;
		} else {
			double books = marvelGraph.getBooks(character1, character2).size();
			double weight = 1 / books;
			List<Double> weights = new ArrayList<Double>();
			weights.add(weight);
			checkRep();
			return weights;
		}
	}

	/**
	 * Returns all characters that coappear in the books the given character appears in,
	 * or null if the given character is not in the graph.
	 * @param character is not null.
	 * @throws IllegalArgumentException if character is null
	 * @return list of all characters taht appear in the same books as the given charater,
	 * or null if the given charater is not in the graph.
	 */
	public List<String> getCoappearances(String character) {
		checkRep();
		if (marvelGraph == null) {
			return customGraph.getAllDests(character);
		} else {
			return marvelGraph.getCoappearances(character);
		}
	}

	/**
	 * Creates a graph for MarvelPaths2, using the given file.
	 * @requires url to be a vaild file, and that the file is in the correct format.
	 * @param url the file th graph will be built based on.
	 * @modifies this
	 * @effects a graph will be created based on the file.
	 */
	public void createGraph(String url) {
		checkRep();
		marvelGraph = new MarvelPaths();
		marvelGraph.createGraph(url);
		checkRep();
	}

	/**
	 * Returns the path with the most books relating the characters in the path. A path
	 * is represented by a list of characters, where adjacent characters appear in the same
	 * book. A list of one character suggests that no books were needed to link the two characters,
	 * and a null value indicates that there were no paths found between the characters.
	 * @param startChar the starting character of the path.
	 * @param destChar the ending character of the path.
	 * @throws IllegalArgumentException if startChar or destChar is null.
	 * @throws IllegalArgumentException if startChar or destChar is not a character in the graph.
	 * @return list of strings representing the path. Returns null if no path was found.
	 */
	public List<String> getPath(String startChar, String destChar) {
		checkRep();
		if (startChar == null || destChar == null) {
			throw new IllegalArgumentException("startChar or destChar is null!");
		}
		List<String> characters = getCharacters();
		if (!characters.contains(startChar) || !characters.contains(destChar)) {
			throw new IllegalArgumentException("startChar or destChar is not a character in this graph!");
		}
		//set path for startChar, and make it active
		PriorityQueue<Path> active = new PriorityQueue<Path>();
		Set<String> finished = new HashSet<String>();
		List<String> initPath = new ArrayList<String>();
		initPath.add(startChar);
		active.add(new Path(0, initPath));

		while(!active.isEmpty()) {
			//get next minimum path
			Path minPath = active.remove();
			List<String> pathway = minPath.path;
			String currentChar = pathway.get(pathway.size() - 1);

			//return path if destination is found
			if (currentChar.equals(destChar)) {
				checkRep();
				return pathway;
			}
			
			if (finished.contains(currentChar)) {
				continue;
			}

			for (String childChar : getCoappearances(currentChar)) {
				if (!finished.contains(childChar)) {
					//calulate path and cost of child, and make active
					List<String> nextPath = new ArrayList<String>(pathway);
					nextPath.add(childChar);
					double addCost = getBookWeight(currentChar, childChar).get(0);
					double newCost = minPath.cost + addCost;
					active.add(new Path(newCost, nextPath)); 
				}
			}
			finished.add(currentChar);
		}
		checkRep();
		return null;
	}

	private void checkRep() {
		if (customGraph == null) {
			throw new RuntimeException("marvelGraphs should not be null!");
		}
	}

	//Path class to keep track of both pathway and cost, and to allow comparison of
	//two paths.
	private class Path implements Comparable<Path> {
		public double cost;
		public List<String> path;

		public Path(double cost, List<String> path) {
			this.cost = cost;
			this.path = path;
		}

		//compare two Paths
		public int compareTo(Path other) {
			return new Double(this.cost).compareTo(other.cost);
		}
	}
}
