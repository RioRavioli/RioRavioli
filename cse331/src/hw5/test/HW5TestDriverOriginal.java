package hw5.test;

import java.io.*;
import java.net.URISyntaxException;
import java.util.*;

import hw4.*;
import hw5.*;


/**
 * This class implements a testing driver which reads test scripts
 * from files for testing Graph, the Marvel parser, and your BFS
 * algorithm.
 **/
public class HW5TestDriver {


    public static void main(String args[]) {
    }

    public HW5TestDriver(Reader r, Writer w) {
    }

    public void runTests() {
    }

    /**
     * Get the absolute path to a file in the bin/hw5/test directory of the
     * project. (Files placed in src/hw5/test are automatically copied to this
     * location when the project is compiled.)
     * 
     * For example, getAbsoluteFilename("foo.tsv") would return something like
     * (on attu):
     * "homes/iws/YourCSENetID/cse331/bin/hw5/test/foo.tsv"
     * 
     * Call this method in your LoadGraph command.
     * 
     * @param filename
     *              The simple filename for which to return the full path
     * @return The absolute path to filename
     */
    private String getAbsoluteFilename(String filename) {
        try {
            File testDir = new File(HW5TestDriver.class.getResource("HW5TestDriver.class").toURI()).getParentFile();
            File dataFile = new File(testDir, filename);
            return dataFile.getAbsolutePath();
        } catch (URISyntaxException e) {
            return null;
        }
    }
}
