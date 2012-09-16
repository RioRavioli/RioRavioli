package hw7.test;
import hw7.*;

import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

public class PointTest {
	Point p;

	@Test
	public void testX() {
		double a = 3.0;
		double b = 3.2;
		p = new Point(a, b);
		assertEquals(p.getX(), a, 0.0001);
	}

	@Test
	public void testY() {
		double a = 3.0;
		double b = 3.2;
		p = new Point(a, b);
		assertEquals(p.getY(), b, 0.0001);
	}

	@Test
	public void testEquals() {
		Point p = new Point(3.0, 4.0);
		Point p2 = new Point(3.0, 4.0);
		assertEquals(p, p2);
	}

	@Test
	public void testEqualsBigDouble() {
		Point p = new Point(3.352563, 4.555455);
		Point p2 = new Point(3.352563, 4.555455);
		assertEquals(p, p2);
	}

	@Test
	public void testNotEqualsDifferentClass() {
		Point p = new Point(3.352563, 4.555455);
		Point p2 = new Point(3.352563, 4.555455);
		assertTrue(!p.equals(new Object()));
	}

	@Test
	public void testHashCode() {
		Point p = new Point(3.352563, 4.555455);
		Point p2 = new Point(3.352563, 4.555455);
		assertEquals(p.hashCode(), p2.hashCode());
	}
}
