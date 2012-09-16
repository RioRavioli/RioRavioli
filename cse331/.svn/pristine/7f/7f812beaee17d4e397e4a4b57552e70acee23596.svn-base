package hw7.test;
import hw7.*;

import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

public class PathTest {
	Path path;

	@Test
	public void testStart() {
		Point p = new Point(3.0, 2.0);
		path = new Path(p, new Point(2.0, 5.3), 3.2);
		assertEquals(path.getStart(), p);
	}

	@Test
	public void testEnd() {
		Point p = new Point(3.0, 2.0);
		path = new Path(new Point(2.0, 5.3), p, 3.2);
		assertEquals(path.getEnd(), p);
	}

	@Test
	public void testDistance() {
		double d = 3.00;
		Point p = new Point(3.0, 2.0);
		path = new Path(new Point(2.0, 5.3), p, d);
		assertEquals(path.getDistance(), d, 0.00001);
	}
}
