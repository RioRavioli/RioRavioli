package hw7;

/**
 * Coordinate of a point. Point is immutable.
 */

//public only to allow junit testing when assignment is turned in
public class Point {
	/*
	 * Specification fields
	 * 	@specfield x : x-coordinate of the point.
	 * 	@specfield y : y-coordinate of the point.
	 *
	 * Abstraction Invariant
	 * 	none
	 *
	 * Abstraction Function
	 * 	AF(r) = Point g, such that
	 * 		g.x = x
	 * 		g.y = y
	 *
	 * Representation Invariant
	 * 	none
	 */
	private double x;
	private double y;

	/**
	 * Creates a new Point.
	 * @param x the x coordinate of the point.
	 * @param y the y coordinate of the point.
	 */
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}

	/**
	 * Returns the x coordinate.
	 * @Return x-coordinate
	 */
	public double getX() {
		return x;
	}
	
	/**
	 * Returns the y coordinate.
	 * @Return y-coordinate
	 */
	public double getY() {
		return y;
	}

	@Override
	//Overridden equals method
	public boolean equals(Object other) {
		if (other == null) 
			return false;
		if (other == this) 
			return true;
		if (!(other instanceof Point)) 
			return false;
		Point otherPoint = (Point) other;
		return new Double(x).equals(otherPoint.x) && new Double(y).equals(otherPoint.y);
	}

	@Override
	//Overridden hashCode method
	public int hashCode() {
		return 300 * new Double(x).hashCode() + new Double(y).hashCode();
	}
}
