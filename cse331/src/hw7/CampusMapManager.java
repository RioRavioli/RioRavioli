package hw7;
import hw4.*;

import java.util.*;

/**
 * Creates a map of a campus according to given .dat files, and gives
 * certain information about the campus inculding shortest path between
 * two buildings.
 */

//public only to allow junit testing when assignment is turned in
public class CampusMapManager {
	/*
	 * Specification fields
	 * 	@specfield buildings : list of buildings
	 * 	@specfield campus map : graph representing paths throughout campus
	 *
	 * Abstarction Invariant
	 * 	buildings must not be null
	 * 	campus map must not be null
	 *
	 * Abstraction function
	 * 	AF(r) = campus map manager g, such that
	 * 		g.buildings = r.buildings
	 * 		g.campus map = r.campusMap
	 *
	 * Representation Invariant
	 * 	buildings != null
	 * 	campusMap != null
	 */

	private List<Building> buildings;
	private Graph<Point, Double> campusMap; 

	/**
	 * Constructs a new instance of CampusMapManager, with information
	 * from the two given files.
	 * @requires buildingsFile and pathsFile to be in correct format.
	 * @param buildingsFile file containing buildings
	 * @param pathsFile file containing paths
	 * @modifies this
	 * @effects creates an incstance for buildings and campusMap.
	 */
	public CampusMapManager() {
		buildings = CampusParser.parseBuildings("hw7/data/campus_buildings.dat");
		campusMap = new Graph<Point, Double>();
		Map<Point, List<Path>> map = CampusParser.parsePaths("hw7/data/campus_paths.dat");

		//create graph of campus
		for (Point endpoint : map.keySet()) {
			campusMap.createNode(endpoint);
			for (Path path : map.get(endpoint)) {
				//create edge
				Point otherPoint = path.getEnd();
				double distance = path.getDistance();
				if (!campusMap.containsNode(otherPoint)) {
					campusMap.createNode(otherPoint);
				}
				campusMap.createEdge(endpoint, otherPoint, distance);
			}
		}	
	}

	/**
	 * Returns a list of Buildings.
	 * @return a list of Buildings.
	 */
	public List<Building> getBuildings() {
		List<Building> newBuildingList= new ArrayList<Building>(buildings);
		return newBuildingList;
	}

	/**
	 * Returns the shortest path from startBuilding to endBuilding.
	 * The path is represented by a list of Paths, where the paths to take
	 * start at the beginning of the list and ends at the end of the list.
	 * @param startBuilding the start of the total path
	 * @param endBuilding the end of the total path
	 * @throws IllegalArgumentException if startBuilding or endBuilding is null.
	 * @throws IllegalArgumentException if startBuilding or endBuilding is is not a valid building.
	 * @return list of paths that represent the total shortest path from startBuilding to endBuilding.
	 */
	public List<Path> getShortestPath(Building startBuilding, Building endBuilding) {
		if (startBuilding == null || endBuilding == null) {
			throw new IllegalArgumentException("startBuilding or endBuilding is null!");
		}
		if (!buildings.contains(startBuilding) || !buildings.contains(endBuilding)) {
			throw new IllegalArgumentException("startBuilding or endBuilding is not a valid building!");
		}
		Point start = startBuilding.getPoint();
		Point end = endBuilding.getPoint();
		List<Point> pathDirections = getShortestPath(start, end);

		//return null if no path found
		if (pathDirections == null) {
			return null;
		}

		//convert list of points to list of paths
		List<Path> shortestPath = new ArrayList<Path>();
		Point current = pathDirections.get(0);
		for (int i = 1; i < pathDirections.size(); i++) {
			Point next = pathDirections.get(i);
			double distance = campusMap.getEdgesLabels(current, next).get(0);
			shortestPath.add(new Path(current, next, distance));
			current = next;
		}
		return shortestPath;
	}

	//Returns a list of points repesenting the shortest path.
	private List<Point> getShortestPath(Point start, Point end) {
		PriorityQueue<List<Point>> active = new PriorityQueue<List<Point>>(
				campusMap.getNodeCount(), new PathComparator());
		Set<Point> finished = new HashSet<Point>();
		List<Point> initPath = new ArrayList<Point>();
		initPath.add(start);
		active.add(initPath);

		while(!active.isEmpty()) {
			//get next minimum path
			List<Point> minPath = active.remove();
			Point currentPoint = minPath.get(minPath.size() - 1);

			//return path if destination is found
			if (currentPoint.equals(end)) {
				return minPath;
			}

			if (finished.contains(currentPoint)) {
				continue;
			}

			for (Point childPoint : campusMap.getAllDests(currentPoint)) {
				if (!finished.contains(childPoint)) {
					//add child to path
					List<Point> nextPath = new ArrayList<Point>(minPath);
					nextPath.add(childPoint);
					active.add(nextPath);
				}
			}
			finished.add(currentPoint);
		}
		return null;
	}

	//Returns the total weight of the given path.
	private double getTotalWeight(List<Point> list) {
		double total = 0;
		if (list.size() > 0) {
			Point current = list.get(0);
			for (int i = 1; i < list.size(); i++) {
				Point next = list.get(i);
				total += campusMap.getEdgesLabels(current, next).get(0);
				current = next;
			}
		}
		return total;
	}

	//Compares the length of two paths.
	private class PathComparator implements Comparator<List<Point>> {
		@Override
		public int compare(List<Point> list1, List<Point> list2) {
			return Double.compare(getTotalWeight(list1), getTotalWeight(list2));
		}

		public boolean equals(Object other) {
			return this == other; 
		}
	}	

	private void checkRep() {
		if (buildings == null) {
			throw new RuntimeException("buildings should not be null!");
		}
		if (campusMap == null) {
			throw new RuntimeException("campusMap should not be null!");
		}
	}
}
