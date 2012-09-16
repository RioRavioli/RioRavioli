package hw5.test;
import hw5.*;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

import java.util.*;

/*
 * This test is for testing the correct build of a graph given a file. This test
 * is intended for use before finding paths is implemented.
 */

public class MarvelPathsTest {
	MarvelPaths smallPaths;
	MarvelPaths medPaths;

	@Before
	public void setUp() {
		smallPaths = new MarvelPaths();
		smallPaths.createGraph("hw5/test/smallTest.tsv");
		medPaths = new MarvelPaths();
		medPaths.createGraph("hw5/test/medTest.tsv");
	}

	//Small Tests
	@Test
	public void checkSmallNodeCount() {
		assertEquals(3, smallPaths.getCharacters().size());
	}

	@Test
	public void checkSmallGetBooks() {
		List<String> books = smallPaths.getBooks("Rio", "Ocean");
		assertEquals(1, books.size());
	}

	@Test
	public void checkSmallGetCoappearances() {
		List<String> characters = smallPaths.getCoappearances("Rio");
		assertEquals(3, characters.size());
	}


	//Medium Tests
	@Test
	public void checkMedNodeCount() {
		assertEquals(10, medPaths.getCharacters().size());
	}

	@Test
	public void checkMedGetBooks() {
		List<String> books = medPaths.getBooks("Rio", "Ocean");
		assertEquals(3, books.size());
	}

	@Test
	public void checkMedGetBooks2() {
		List<String> books = medPaths.getBooks("Rio", "Kou");
		assertEquals(1, books.size());
	}

	@Test
	public void checkMedGetCoappearances() {
		List<String> characters = medPaths.getCoappearances("Rio");
		assertEquals(10, characters.size());
	}

	@Test
	public void checkMedGetCoappearances2() {
		List<String> characters = medPaths.getCoappearances("Kou");
		assertEquals(8, characters.size());
	}
}
