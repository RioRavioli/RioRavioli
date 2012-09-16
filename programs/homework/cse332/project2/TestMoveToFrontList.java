/*
 * Rio Bacon
 * CSE 332
 * April, 25th, 2012
 *
 * Tests for MoveToFrontList.java
 */
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertArrayEquals;
import java.util.*;
import org.junit.Before;
import org.junit.Test;


public class TestMoveToFrontList {
	MoveToFrontList<Integer> list;

	@Before
	public void setUp() throws Exception {
		list = new MoveToFrontList<Integer>(new Comparator<Integer>() {
			public int compare(Integer e1, Integer e2) {
				return e1 - e2;
			}
		});
	}

	@Test
	public void listHasSize0WhenConstructed() {
		assertEquals("Constructed a list and check its size", list.getSize(), 0);
	}

	private void addAndTestSize(int[] nums, int unique) {
		for (int i = 0; i < nums.length; i++) {
			list.incCount(nums[i]);
		}
		assertEquals("Added " + unique + " numbers to the list", list.getSize(), unique);
	}

	private void add(int[] nums) {
		for (int i = 0; i < nums.length; i++) {
			list.incCount(nums[i]);
		}
	}

	@Test
	public void listHasSize1AfterAdding1() {
		addAndTestSize(new int[]{1}, 1);
	}

	@Test
	public void listHasSize2AfterAdding2Nums() {
		addAndTestSize(new int[]{3, 4}, 2);
	}

	@Test
	public void listHasSize1AfterAddingIdenticalNums() {
		addAndTestSize(new int[]{4, 4}, 1);
	}

	@Test
	public void listHasSize1AfterAddingMoreIdenticalNums() {
		addAndTestSize(new int[]{4, 2, 4}, 2);
	}

	@Test
	public void increasingCountShouldMoveToFront() {
		add(new int[]{2, 3, 4, 4});
		SimpleIterator<DataCount<Integer>> iterator = list.getIterator();
		assertEquals(iterator.next().data.intValue(), 4);
	}
}
