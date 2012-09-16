/*
 * Rio Bacon
 * CSE 332
 * April 25th, 2012
 *
 * Tests for AVLTree.java
 */
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertArrayEquals;
import java.util.*;
import org.junit.Before;
import org.junit.Test;


public class TestHashtable {
	Hashtable<Integer> table;

	@Before
	public void setUp() throws Exception {
		table = new Hashtable<Integer>(new Comparator<Integer>() {
			public int compare(Integer e1, Integer e2) {
				return e1 - e2;
			}
		}, new Hasher<Integer>() {
			public int hash(Integer i) {
				return i;
			}
		});
	}

	@Test
	public void treeHasSize0WhenConstructed() {
		assertEquals("Constructed a table and check its size", table.getSize(), 0);
	}

	private void addAndTestSize(int[] nums, int unique) {
		for (int i = 0; i < nums.length; i++) {
			table.incCount(nums[i]);
		}
		assertEquals("Added " + unique + "numbers to the table", table.getSize(), unique);
	}

	@Test
	public void tableHasSize1AfterAdding1() {
		addAndTestSize(new int[]{1}, 1);
	}

	@Test
	public void tableHasSize2AfterAdding2Nums() {
		addAndTestSize(new int[]{3, 4}, 2);
	}

	@Test
	public void tableHasSize3AfterAdding4Nums2Dups() {
		addAndTestSize(new int[]{3, 4, 5, 5}, 3);
	}

	@Test
	public void tableHasSize20AfterRehashing() {
		addAndTestSize(new int[]{1, 4, 5, 2, 3, 32, 23, 22, 89, 68, 68, 75, 75, 77, 88, 85, 70, 78, 78, 78, 77, 86, 67, 75, 64, 45}, 20);
	}

	@Test
	public void iteratorGetsProperValues() {
		int[] value = {1, 2, 45, 55};
		for (int i = 0; i < value.length; i++) {
			table.incCount(value[i]);
		}	
		SimpleIterator<DataCount<Integer>> iterator = table.getIterator();
		int[] iterated = new int[4];
		int i = 0;
		while(iterator.hasNext()) {
			iterated[i++] = iterator.next().data;
		}
		Arrays.sort(iterated);
		assertArrayEquals(iterated, value);
	}
}

