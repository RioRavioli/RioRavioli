/*
 * Rio Bacon
 * CSE 332
 * April 25th, 2012
 *
 * Tests for FourHeap.java
 */

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertArrayEquals;
import java.util.*;
import org.junit.Before;
import org.junit.Test;

public class TestFourHeap {
	FourHeap<Integer> heap;

	@Before
	public void setUp() throws Exception {
		heap = new FourHeap<Integer>(10, new Comparator<Integer>() {
			public int compare(Integer e1, Integer e2) {
				return e1 - e2;
			}
		});
	}

	@Test
	public void canAddAndRemoveOne() {
		heap.add(1);
		int value = heap.remove();
		assertEquals("Added 1 then removed it", value, 1);
	}

	@Test
	public void sortTwoElements() {
		int[] array = {8, 1};
		for (int i = 0; i < array.length; i++) {
			heap.add(array[i]);
		}
		for (int i = 0; i < array.length; i++) {
			array[i] = heap.remove();
		}
		assertArrayEquals(array, new int[]{1, 8});
	}

	@Test
	public void sortManyElements() {
		int[] array = {8, 1, 3, 7, 9, 6, 0};
		for (int i = 0; i < array.length; i++) {
			heap.add(array[i]);
		}
		for (int i = 0; i < array.length; i++) {
			array[i] = heap.remove();
		}
		assertArrayEquals(array, new int[]{0, 1, 3, 6, 7, 8, 9});
	}
}
