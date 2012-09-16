package hw7;

/**
 * Holds infromation about a specific path. Path is immutable.
 */

//public only to allow junit testing when assignment is turned in
public class Path {
	/*
	 * Specificaition fields
	 * 	@specfield startPoint : the starting point of the path
	 * 	@specfield endPoint : the ending point of the path
	 * 	@specfield distance : the distance from startPoint to endPoint
	 *
	 * Abstraction Invariant
	 * 	startPoint, endPoint must all exist
	 *
	 * Abstraction Function
	 * 	AF(r) = Building p, such that
	 * 	g.startPoint = start
	 * 	g.endPoint = end
	 * 	g.distance = distance
	 *
	 * Representation Invariant
	 * 	start != null
	 * 	end != null
	 */
	private Point start;
	private Point end;
	private double distance;

	/**
	 * Creates a new point instance.
	 * @requires start, end != null
	 * @param start start point
	 * @param end end point
	 * @param distance distance between the two points
	 */
	public Path(Point start, Point end, double distance) {
		this.start = new Point(start.getX(), start.getY());
		this.end = new Point(end.getX(), end.getY());;
		this.distance = distance;
		checkRep();
	}

	/**
	 * Returns start point of the path
	 * @return start point
	 */
	public Point getStart() {
		checkRep();
		return new Point(start.getX(), start.getY());
	}

	/**
	 * Returns end point of the path
	 * @return end point
	 */
	public Point getEnd() {
		checkRep();
		return new Point(end.getX(), end.getY());
	}

	/**
	 * Returns distance between the two points
	 * @return distance
	 */
	public double getDistance() {
		checkRep();
		return distance;
	}

	private void checkRep() {
		if (start == null) {
			throw new RuntimeException("start must not be null!");
		}
		if (end == null) {
			throw new RuntimeException("end must not be null!");
		}
	}
}
