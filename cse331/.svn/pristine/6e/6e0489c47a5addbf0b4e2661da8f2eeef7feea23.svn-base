package hw7;

/**
 * Holds information about a specific building. Building is immutable. 
 */

//public only to allyw junit testing when assigment is turned in
public class Building implements Comparable<Building> {
	/*
	 * Specificaition fields
	 * 	@specfield shortName : the abbreviated name of the building
	 * 	@specfield longName : the full name of the building
	 * 	@specfield point : the coordinate point of the building
	 *
	 * Abstraction Invariant
	 * 	shartName, longName, point must all exist
	 *
	 * Abstraction Function
	 * 	AF(r) = Building p, such that
	 * 	g.shortName = shortName
	 * 	g.longName = longName
	 * 	g.p = point
	 *
	 * Representation Invariant
	 * 	shortName != null
	 * 	longName != null
	 * 	p != null
	 */
	private String shortName;
	private String longName;
	private Point p;

	/**
	 * Creates a building instance.
	 * @requires shortName, longName, p != null
	 * @param shortName short name of building
	 * @param longName long name of building
	 * @param p coordinate point of the building
	 */
	public Building(String shortName, String longName, Point p) {
		this.shortName = shortName;
		this.longName = longName;
		this.p = new Point(p.getX(), p.getY());;
		checkRep();
	}

	/**
	 * Returns short name of the building.
	 * @return short name
	 */
	public String getShortName() {
		checkRep();
		return shortName;
	}

	/**
	 * Returns long name of the building.
	 * @return long name
	 */
	public String getLongName() {
		checkRep();
		return longName;
	}

	/**
	 * Returns the coordinate point of the building.
	 * @return coordinate point
	 */
	public Point getPoint() {
		checkRep();
		return new Point(p.getX(), p.getY());
	}

	/**
	 * Returns an integer that represents the comparison with the given block.
	 * The two are compared by their abbreviated name in alphabetical order.
	 * @param other the building to compare this to.
	 * @return the resulting int of the comparison.
	 */
	public int compareTo(Building other) {
		return shortName.compareTo(other.shortName); 
	}

	private void checkRep() {
		if (shortName == null) {
			throw new RuntimeException("shortName must not be null!");
		}
		if (longName == null) {
			throw new RuntimeException("longName must not be null!");
		}
		if (p == null) {
			throw new RuntimeException("p must not be null!");
		}
	}
}
