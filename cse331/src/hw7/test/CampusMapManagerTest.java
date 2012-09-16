package hw7.test;
import hw7.*;

import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.*;

import java.util.*;

public class CampusMapManagerTest {
	CampusMapManager manager;

	@Test
	public void testGetBuildings() {
		manager = new CampusMapManager();
//		manager = new CampusMapManager(
	//			"src/hw7/data/campus_buildings.dat", "src/hw7/data/campus_paths.dat");
		List<Building> buildings = manager.getBuildings();
		assertEquals(51, buildings.size()); 
	}

	@Test
	public void testGetBuildingsContainsCorrect() {
		manager = new CampusMapManager();
		//manager = new CampusMapManager(
		//		"src/hw7/data/campus_buildings.dat", "src/hw7/data/campus_paths.dat");
		List<Building> buildings = manager.getBuildings();
		String name = buildings.get(0).getShortName();
		assertEquals(name, "BAG");
	}

	@Test
	public void testGetShortestPathSelf() {
		manager = new CampusMapManager();
		//manager = new CampusMapManager(
		//		"src/hw7/data/campus_buildings.dat", "src/hw7/data/campus_paths.dat");
		List<Building> buildings = manager.getBuildings();
		Building bagley = buildings.get(0);
		List<Path> path = manager.getShortestPath(bagley, bagley);
		assertEquals(0, path.size());
	}

/*	@Test
	public void testGetShortestPath() {
		CampusMapManager manager2 = new CampusMapManager();
		//CampusMapManager manager2 = new CampusMapManager(
		//		"src/hw7/data/campus_buildings_test.dat", "src/hw7/data/campus_paths_test.dat");
		List<Building> buildings = manager2.getBuildings();
		Building a = buildings.get(0);
		Building b = buildings.get(2);
		List<Path> path = manager2.getShortestPath(a, b);
		assertEquals(2, path.size());
	}

	@Test
	public void testCannotFindPath() {
		CampusMapManager manager2 = new CampusMapManager();
//		CampusMapManager manager2 = new CampusMapManager(
//				"src/hw7/data/campus_buildings_test.dat", "src/hw7/data/campus_paths_test.dat");
		List<Building> buildings = manager2.getBuildings();
		Building a = buildings.get(0);
		Building b = buildings.get(1);
		List<Path> path = manager2.getShortestPath(a, b);
		assertEquals(null, path);
	}*/
}