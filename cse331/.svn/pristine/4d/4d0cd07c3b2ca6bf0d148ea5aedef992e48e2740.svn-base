package hw7.test;
import hw7.*;

import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

public class BuildingTest {
	Building b;

	@Test
	public void testShortName() {
		b = new Building("Test test test", "Test", new Point(3.0, 2.0));
		assertEquals(b.getShortName(), "Test test test");
	}

	@Test
	public void testLongName() {
		b = new Building("Test test test", "Test", new Point(3.0, 2.0));
		assertEquals(b.getLongName(), "Test");
	}

	@Test
	public void testPoint() {
		Point p = new Point(3.0, 2.0);
		b = new Building("Test test test", "Test", p);
		assertEquals(b.getPoint(), p);
	}

	@Test
	public void testComparison() {
		Point p = new Point(3.0, 2.0);
		b = new Building("Test test test", "Test", p);
		Building c = new Building("AAAA", "Test", p);
		assertEquals(b.compareTo(c), 19);
	}

	@Test
	public void testComparisonEqual() {
		Point p = new Point(3.0, 2.0);
		b = new Building("AAAA", "Tt", p);
		Building c = new Building("AAAA", "Test", p);
		assertEquals(b.compareTo(c), 0);
	}	
}
