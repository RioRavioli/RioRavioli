/**
 * This is part of HW2: Environment Setup and Java Introduction for CSE 331.
 */
package hw2.test;
import hw2.*;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * HolaWorldTest is a simple test of the HolaWorld class that you
 * are to fix.  This test just makes sure that the program
 * does not crash and that the correct greeting is printed.
 */
public class HolaWorldTest {

    /**
     * Tests that HolaWorld does not crash
     */
    @Test
    public void testCrash() {
        /* Any exception thrown will be caught by JUnit. */
        HolaWorld.main(new String[0]);
    }

    /**
     * Tests that the HolaWorld greeting is correct.
     */
    @Test
    public void testGreeting() {
        HolaWorld world = new HolaWorld();
        assertEquals(HolaWorld.spanishGreeting, world.getGreeting());
    }


}
