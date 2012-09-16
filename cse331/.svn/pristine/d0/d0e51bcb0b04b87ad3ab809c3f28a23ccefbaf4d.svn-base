package hw8;
import hw7.*;

import java.util.*;
import java.io.*;
import javax.swing.*;
import javax.imageio.*;
import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;

/**
 * Displays a map of the campus of University of Washington. Two buildings may be selected
 * to find the shortest path between them. The route will also be displayed on the map.
 */
public class CampusPathsMain {
	private JFrame frame;
	private CampusMapManager manager;
	
	private final int FRAME_SIZE_X = 1024;
	private final int FRAME_SIZE_Y = 768;

	//Creates the GUI
	public static void main(String[] args) {
		CampusPathsMain main = new CampusPathsMain();
	}

	/**
	 * Constructs a new instance of CampusPathsMain; creates and dispalays
	 * all initial components.
	 * @effects sets up and launches the CampusPathsMain GUI.
	 */
	public CampusPathsMain() {
		frame = new JFrame("Campus Paths");
		manager = new CampusMapManager();

		//sets up frame
		frame.setFocusable(true);
		frame.setSize(FRAME_SIZE_X, FRAME_SIZE_Y);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setLayout(new FlowLayout());
		setComponents(frame);
		frame.setVisible(true);
	}

	//Creates and adds all initial components to frame.
	private void setComponents(JFrame frame) {
		//create an array of building names
		java.util.List<Building> buildings = manager.getBuildings();
		String[] buildingList = new String[buildings.size()];
		for (int i = 0; i < buildings.size(); i++) {
			String longName = buildings.get(i).getLongName(); 
			buildingList[i] = longName;
		}

		//create labels
		Component startLabel = new JLabel("Start:");
		Component endLabel = new JLabel("Destination:");
		JLabel buttonDirections = new JLabel("Map Scrolling:: [K: up] [J: down] [H: left] [L: right]");
		
		//create components and add action listeners
		MapCanvas campus = new MapCanvas();
		JComboBox startList = new JComboBox(buildingList);
		JComboBox endList = new JComboBox(buildingList);
		startList.addActionListener(new SelectionListener(startList, endList, buildings, campus));
		endList.addActionListener(new SelectionListener(startList, endList, buildings, campus));
		JButton resetButton = new JButton("Reset");
		resetButton.addActionListener(new ResetListener(campus, startList, endList));
		JButton searchButton = new JButton("Search");	
		searchButton.addActionListener(new SearchListener(startList, endList, buildings, campus));
		
		//add components to frame
		frame.add(buttonDirections);
		frame.add(resetButton);
		frame.add(startLabel);
		frame.add(startList);
		frame.add(endLabel);
		frame.add(endList);
		frame.add(searchButton);
		frame.add(campus);

		//add map navigation keys
		KeyListener imageListener = new ImageListener(campus);
		resetButton.addKeyListener(imageListener);
		startList.addKeyListener(imageListener);
		endList.addKeyListener(imageListener);
		searchButton.addKeyListener(imageListener);
		frame.addKeyListener(imageListener);

		campus.updateImage();
	}


	/**
	 * Upon user request, resets the state of the application.
	 */
	private class ResetListener implements ActionListener {
		private MapCanvas map;
		private JComboBox startList;
		private JComboBox endList;

		/**
		 * Constructs a new instance of ResetListener.
		 * @requires map is not null
		 * @param map the MapCanvas that reset will reset.
		 * @param startList the start list that gets reset.
		 * @param endList the end list that gets reset.
		 */
		public ResetListener(MapCanvas map, JComboBox startList, JComboBox endList) {
			this.map = map;
			this.startList = startList;
			this.endList = endList;
		}

		/**
		 * Resets map.
		 * @modifies map
		 * @effects the GUI is returned to its initial state. 
		 */
		public void actionPerformed(ActionEvent e) {
			startList.setSelectedIndex(0);
			endList.setSelectedIndex(0);
			map.reset();
			map.updateImage();
		}
	}


	/**
	 * Draws a marker on a building that gets selected.
	 */
	private class SelectionListener implements ActionListener {
		private JComboBox startList;
		private JComboBox endList;
		private java.util.List<Building> buildings;
		private MapCanvas map;

		/**
		 * Constructs a new instace of SelectionListener.
		 */
		public SelectionListener(JComboBox startList, JComboBox endList, java.util.List<Building> buildings, MapCanvas map) {
			this.startList = startList;
			this.endList = endList;
			this.buildings = buildings;
			this.map = map;
		}

		/**
		 * When a building is selected, a marker is drawn on top of the building.
		 */
		public void actionPerformed(ActionEvent e) {
			String start = (String) startList.getSelectedItem();
			String end = (String) endList.getSelectedItem();

			//get start and end buildings
			Building startBuilding = null;
			Building endBuilding = null;
			for (Building building : buildings) {
				if (start.equals(building.getLongName())) {
					startBuilding = building;
				}
				if (end.equals(building.getLongName())) {
					endBuilding = building;
				}
			}

			map.setPoints(startBuilding.getPoint(), endBuilding.getPoint());
			map.updateImage();
		}
	}


	/**
	 * Upon user request, finds and displays the shortest path between two buildings.
	 */
	private class SearchListener implements ActionListener {
		private JComboBox startList;
		private JComboBox endList;
		private java.util.List<Building> buildings;
		private MapCanvas map;

		/**
		 * Constructs a new instance of SearchListener.
		 * @requires startList has same buildings as endList and buildings.
		 * @requires map is not null.
		 * @param startList the list on which the user has made a start selection on.
		 * @param endList the list on which the user has made an end selection on.
		 * @param buildings the list of buildings to match the user selections with.
		 * @param map the map that the shortest path will be drawn on.
		 */
		public SearchListener(JComboBox startList, JComboBox endList,
			  					  	 java.util.List<Building> buildings, MapCanvas map) {
			this.startList = startList;
			this.endList = endList;
			this.buildings = buildings;
			this.map = map;
		}

		@Override
		/**
		 * Computes then draws the shortest path between the two currently selected
		 * buildings from the two lists of buildings.
		 * @modifies map
		 * @effects draws the shortest path between two selected buildings, and moves
		 * position of the image on map.
		 */
		public void actionPerformed(ActionEvent e) {
			String start = (String) startList.getSelectedItem();
			String end = (String) endList.getSelectedItem();

			//get start and end buildings
			Building startBuilding = null;
			Building endBuilding = null;
			for (Building building : buildings) {
				if (start.equals(building.getLongName())) {
					startBuilding = building;
				}
				if (end.equals(building.getLongName())) {
					endBuilding = building;
				}
			}

			//neither building should ever be null, because user selection comes from the same list
			java.util.List<Path> route = manager.getShortestPath(startBuilding, endBuilding);

			//sets the map to show the beginning of the route
			if (route.size() > 0) {
				hw7.Point startPoint = route.get(0).getStart();
				map.centerMap(startPoint);
			}

			map.setRoute(route);
			map.updateImage();
		}
	}


	/**
	 * MapCanvas draws the campus map and any requested routes according to its current position.
	 */
	private class MapCanvas extends JComponent {
		private BufferedImage campusMap;
		private int xShift;
		private int yShift;
		private java.util.List<Path> route;
		private hw7.Point startPoint;
		private hw7.Point endPoint;

		private final int CANVAS_SIZE_X = 1000;
		private final int CANVAS_SIZE_Y = 600;
		private final int START_X = -500;
		private final int START_Y = -350;
		private final int MIN_X = -1170;
		private final int MAX_X = 0;
		private final int MIN_Y = -880;
		private final int MAX_Y = 0;
		private final double ZOOM_VALUE = .5;

		/**
		 * Creates a new MapCanvas object.
		 */
		public MapCanvas() {
			try {
				campusMap = ImageIO.read(new File("hw7/data/campus_map.jpg"));
			} catch (Exception e) {
				e.printStackTrace();
			}

			xShift = START_X;
			yShift = START_Y;
			route = null;
			startPoint = null;
			endPoint = null;
			this.setPreferredSize(new Dimension(CANVAS_SIZE_X, CANVAS_SIZE_Y));
		}

		/**
		 * Modifies the coordinates of the images drawn on the campus by dx and dy.
		 * @param dx changes xShift by dx.
		 * @param dy changes yShift by dy.
		 * @modifies this
		 * @effects dx and dy are increased or decreased by the given values.
		 */
		public void moveImage(int dx, int dy) {
			xShift += dx;
			yShift += dy;
			checkPos();
		}

		/**
		 * Realigns map so that the given point is in the center.
		 * @param point the point that the map centers to.
		 * @modifies this
		 * @effects xShift and yShift are repositioned so point is in the center.
		 */
		public void centerMap(hw7.Point point) {
			//reposition map
			int pointPixelX = (int) (point.getX() * ZOOM_VALUE);
			int pointPixelY = (int) (point.getY() * ZOOM_VALUE);
			int mapPosX = -1 * (pointPixelX - CANVAS_SIZE_X / 2);
			int mapPosY = -1 * (pointPixelY - CANVAS_SIZE_Y / 2);
			xShift = mapPosX;
			yShift = mapPosY;
			checkPos();
		}

		//Ensures image of map does not move beyond its borders.
		private void checkPos() {
			if (xShift > MAX_X)
				xShift = MAX_X;
			else if (xShift < MIN_X)
				xShift = MIN_X;

			if (yShift > MAX_Y)
				yShift = MAX_Y;
			else if (yShift < MIN_Y)
				yShift = MIN_Y;
		}

		/**
		 * Sets startPoint and endPoint. These will be marked on the map if they are not null.
		 * @param startPoint one point that could be drawn.
		 * @param endPoint another point that could be drawn.
		 * @modifies this
		 * @effects startPoint and endPoint will be set. They will be drawn on the map.
		 */
		public void setPoints(hw7.Point startPoint, hw7.Point endPoint) {
			this.startPoint = startPoint;
			this.endPoint = endPoint;
		}

		/**
		 * Sets the route.
		 * @param route sets this.route to route.
		 * @modifies this
		 * @effects this.route is set to route.
		 */
		public void setRoute(java.util.List<Path> route) {
			this.route = route;
		}

		/**
		 * Draws a mark at the given point.
		 */
		private void drawPoint(Graphics g, hw7.Point point) {
			double pointX = point.getX();
			double pointY = point.getY();
			int xPos = (int) (pointX * ZOOM_VALUE + xShift);
			int yPos = (int) (pointY * ZOOM_VALUE + yShift);

			g.fillRect(xPos - 5, yPos - 5, 10, 10);
		}

		//Draws the path according to route.
		private void drawRoute(Graphics g) {
			for (Path path : route) {
				double startX = path.getStart().getX();
				double startY = path.getStart().getY();
				double endX = path.getEnd().getX();
				double endY = path.getEnd().getY();

				//convert path points to pixel positions
				int startPixelX = (int) (startX * ZOOM_VALUE + xShift);
				int startPixelY = (int) (startY * ZOOM_VALUE + yShift);
				int endPixelX = (int) (endX * ZOOM_VALUE + xShift);
				int endPixelY = (int) (endY * ZOOM_VALUE + yShift);

				g.drawLine(startPixelX, startPixelY, endPixelX, endPixelY);
			}
		}

		/**
		 * Resets this to its initial state.
		 * @effects resets the state of this to its initial state.
		 */
		public void reset() {
			xShift = START_X;
			yShift = START_Y;
			route = null;
			startPoint = null;
			endPoint = null;
		}

		/**
		 * Redraws g.
		 */
		public void updateImage() {
			this.repaint();
		}

		@Override
		/**
		 * Draws the campus map at the current position, and any paths over it if route is set.
		 * @param g the graphics that the map and route gets drawn on.
		 * @effects draws the map and the currently set route, if set.
		 */
		public void paintComponent(Graphics g) {
			g.setColor(Color.RED);
			super.paintComponent(g);
			int xZoom = (int) (campusMap.getWidth() * ZOOM_VALUE + xShift);
			int yZoom = (int) (campusMap.getHeight() * ZOOM_VALUE + yShift);
			g.drawImage(campusMap, xShift, yShift, xZoom, yZoom,
				  	0, 0, campusMap.getWidth(), campusMap.getHeight(), null);

			//draw additional marks if set
			if (route != null) 
				drawRoute(g);
			if (startPoint != null)
			  drawPoint(g, startPoint);	
			if (endPoint != null)
			  drawPoint(g, endPoint);	
		}
	}


	/**
	 * Moves the map upon keyboard input.
	 */
	private class ImageListener implements KeyListener {
		/*
		 * Specificiation fields
		 * 	@specfield map canvas : the canvas which contains the map
		 * 
		 * Abstraction Invariant
		 * 	map canvas must not be null
		 *
		 * Abstraction function
		 * 	AF(r) = reset listener g, such that
		 * 		g.map canvas = map
		 *
		 * Representation Invariant
		 * 	map != null
		 */	 
		 
		private MapCanvas map;
		private final int MOVE_SPEED = 40;

		/**
		 * Constructs a new instance of ImageListener.
		 * @param map the map that ImageListener moves.
		 */
		public ImageListener(MapCanvas map) {
			this.map = map;
		}

		/**
		 * Moves map down when j is pressed, up when k is pressed, left when h is
		 * pressed, and right when l is pressed. 
		 * @modifies map
		 * @effects changes the position of the image displayed through map.
		 */
		public void keyPressed(KeyEvent event) {
			char key = event.getKeyChar();
			switch (key) {
				case 'j':
					map.moveImage(0, -1 * MOVE_SPEED);
					break;
				case 'k':
					map.moveImage(0, MOVE_SPEED);
					break;
				case 'h':
					map.moveImage(MOVE_SPEED, 0);
					break;
				case 'l':
					map.moveImage(-1 * MOVE_SPEED, 0);
					break;
			}
			map.updateImage();
		}

		//No action taken when keys are released or typed.
		public void keyReleased(KeyEvent event) {}
		public void keyTyped(KeyEvent event) {}
	}
}
