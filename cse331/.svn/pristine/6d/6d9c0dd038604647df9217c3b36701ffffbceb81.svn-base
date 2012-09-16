package hw7;

import java.io.*;
import java.util.*;

/**
 * Parser utility to load the campus datasets. 
 */

//public only to allow junit testing when assignment is turned in
public class CampusParser {
	/*
	 * This class only has static methods, therefore does not contain representation
	 * invariants/abstraction invariants.
	 */

	/**
	 * Reads the campus buildings dataset and creates a list of buildings.
	 * Each line will represent a shortname, longname, x-coordinate, and y-coordinate
	 *
	 * @requires file with 4 tokens per line, each seperated by a tab.	
	 * @param filename the file to parse
	 * @return a list of buildings
	 */
	public static List<Building> parseBuildings(String filename) {
		List<Building> buildings = new ArrayList<Building>();
		try {
			BufferedReader reader = new BufferedReader(new FileReader(filename));

			String inputLine;
			while ((inputLine = reader.readLine()) != null) {
				 
				//Ignore comment lines
				if (inputLine.startsWith("#")) {
					continue;
				}

				// Parse data, throwing an exception for incorrectly formatted
				// lines.
				String[] tokens = inputLine.split("\t");
				// Extract information about the building and add to list.
				String shortName = tokens[0];
				String longName = tokens[1];
				double x = Double.parseDouble(tokens[2]);
				double y = Double.parseDouble(tokens[3]);
				buildings.add(new Building(shortName, longName, new Point(x, y)));
			}
			reader.close();
		} catch (IOException e) {
			System.err.println(e.toString());
			e.printStackTrace(System.err);
		}
		return buildings;
	}

	/**
	 * Reads the campus paths dataset and creates a map of endpoints to paths.
	 * All endpoints are listed, where each endpoint is followed by another list of
	 * endpoints that paths go to and their distances.
	 *
	 * @requires file with coordinate pairs in the format of 'x,y' on seperate
	 * lines, and each pair followed at least one tab indented coordinate and 
	 * distance in the format of 'x,y: distance'.
	 * @param filename the file to parse 
	 * @return a map of points mapping to a list of paths branching out.
	 */
	public static Map<Point, List<Path>> parsePaths(String filename) {
		Map<Point, List<Path>> paths = new HashMap<Point, List<Path>>();
		try {
			BufferedReader reader = new BufferedReader(new FileReader(filename));

			String inputLine = reader.readLine();
			while (inputLine != null) {
				//Ignore comment lines
				if (inputLine.startsWith("#")) {
					continue;
				}
				Point endpoint = createPoint(inputLine);

				List<Path> pathList = new ArrayList<Path>();
				String path = reader.readLine();
				while (path != null && path.startsWith("\t")) {
					//get individual paths going from the endpoint
					String[] tokens = path.split(" ");
					double distance = Double.parseDouble(tokens[1]);
					Point otherEnd = createPoint(tokens[0]);
					pathList.add(new Path(endpoint, otherEnd, distance));
					path = reader.readLine();
				}
				inputLine = path;

				paths.put(endpoint, pathList);
			}
		} catch (IOException e) {
			System.err.println(e.toString()); 
			e.printStackTrace(System.err);
		}
		return paths;
	}

	//converts string to Point.
	private static Point createPoint(String point) {
		if (point.charAt(point.length() - 1) == ':') {
			point = point.substring(0, point.length() - 1);
		}
		String[] coordinate = point.split(",");
		double x = Double.parseDouble(coordinate[0]);
		double y = Double.parseDouble(coordinate[1]);
		return new Point(x, y);
	}
}
