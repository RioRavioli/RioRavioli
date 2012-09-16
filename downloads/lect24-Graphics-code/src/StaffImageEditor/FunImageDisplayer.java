package StaffImageEditor;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.AdjustmentEvent;
import java.awt.event.AdjustmentListener;
import java.awt.event.MouseEvent;
import java.awt.geom.Point2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.swing.*;
import javax.swing.event.MouseInputListener;

import ImageBank.ImageBank;

//import 
public class FunImageDisplayer {

	//Features of to adjust
	private String[] faceFeaturesStrings = {"Hair", "Ear Hair", "Nose Hair", "New Eyebrows", "Mustache", "Beard", "Hat" };
	private String[] RGB = {"Red", "Green", "Blue"};
	//Lets create a frame to hold components
	private JFrame frame;
	
	//All components to this view
	private JPanel displayPanel, drawOptionsPanel, faceSelectionPanel;
	private JComboBox images_boxitems;
	private JButton selected, clearButton, leftEyeButton, rightEyeButton, noseButton;
	private JButton leftEarButton, rightEarButton, topHeadButton;
	//private JButton[] facialSelect;
	private JLabel nameDisplay;
	private JScrollBar redBar, blueBar, greenBar;
	
	//Color association with feature
	private Color color;
	
	//Maps String names of features to Corresponding text box
	private Map<String,JCheckBox> faceFeatures;
	
	//Maps JButton to Point of feature
	//Value is null if point does not exist
	private Map<JButton, Point2D.Double> feature_points;
	
	//Image arrays
	BufferedImage[] bufImages;
	Image[] images;
	
	//Names of the Images
	String[] image_names;
	
	// Image canvas to hold image
	ImageCanvas img_canvas;
	
	/**
	 * Initialize a Fun Image Displayer for use by the user
	 * Initializes all the necessary components and dispays the window
	 * to use the entire application
	 */
	public FunImageDisplayer(){
		//initialize images from memory bank
		bufImages = ImageBank.getBufferedImages();
		images = ImageBank.getImages();
		image_names = ImageBank.getImageNames();
		
		//Lets have a nice wrapper method to set up these components
		setUpComponents();
		
		//Add Panels to frame
		frame.add(drawOptionsPanel , BorderLayout.WEST);
		frame.add(faceSelectionPanel, BorderLayout.SOUTH);
		frame.add(displayPanel, BorderLayout.NORTH);
		frame.add(img_canvas, BorderLayout.CENTER);
		
		frame.validate(); //Lets make sure frame draws the most up to date components
		frame.pack(); //Lets make sure frame packs everything nice and tight
		frame.setVisible(true); //Finally lets make sure we can see it
	}
	
	
	private void setUpComponents() {
		//Initialize Buttons
		//All JButtons and feature_points
		InitializeButtons();
		
		//Intialize global color and color scrolls
		InitializeColorScrolls(); 
		
		// initialize options Panel with clear button
		// Check boxes
		// Scrollable Color scales
		InitializeOptionsPanel();
		
		//Initialize Display Area
		InitializeDisplayArea();
		
		//Frame set up
		frame = new JFrame("Fun Image Displayer");
		frame.setLayout(new BorderLayout());
		frame.setLocation(200,200); // center frame
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); //Close on exit
		
		img_canvas = new ImageCanvas();
		img_canvas.addMouseListener(new FeatureSelecter());
	}
	
	/**
	 * Reset all the data and the fields of the view to there default value
	 */
	private void resetData(){
		// Zero out features
		nullOutPointsForFeatures();
	
		// Reset the check boxes to Zero 
		resetCheckBox();
		
		// Reset Color
		redBar.setValue(redBar.getMinimum());
		blueBar.setValue(blueBar.getMinimum());
		greenBar.setValue(greenBar.getMinimum());
		color = Color.BLACK;
		
		//Update Selected facial feature boxes
		updateSelectButtons();
		
		frame.repaint();
	}

	/**
	 * Reset all the JCheck box to default state
	 * Default state == not selected
	 */
	private void resetCheckBox() {
		for (JCheckBox box: faceFeatures.values()){
			box.setSelected(false);
		}
	}


	////////////////////////////////////////////////////////////////////////////////////////
	//// Display Area and Supporting Methods
	////////////////////////////////////////////////////////////////////////////////////////	
	
	private void InitializeDisplayArea() {
		//lets instantiate our panels
		displayPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
		nameDisplay = new JLabel("Lets Have Some Fun!");
		
		//Create A combo box
		// Include a default options
		String[] options = new String[image_names.length+1];
		for (int i = 1 ; i < options.length ; i++){
			options[i] = image_names[i-1]; 
		}
		options[0] = "Please Choose an option";
		images_boxitems = new JComboBox(options);
		
		//Add my custom box listener
		//handles change i individual
		images_boxitems.addActionListener(new ComboBoxListener()); //Add action listener
			
		//Add to display panel
		displayPanel.add(nameDisplay);
		displayPanel.add(images_boxitems);
	}
	
	/*
	 * Update title label to display correct output
	 */
	private void updateTitleLabel(int index) {
		if (index == 0)
			nameDisplay.setText("Lets Have Some Fun!");
		else
			nameDisplay.setText(image_names[index-1]);
	}
	
	/**
	 * Listener class for JCombo Box
	 * Updates the canvas and Label appropriately
	 * @author mhotan
	 *
	 */
	private class ComboBoxListener implements ActionListener {

		//Holds last index currently used
		int oldIndex = 0;
		
		@Override
		public void actionPerformed(ActionEvent e) {
			// I as the designer, can ensure this never has
			// invalid type
			JComboBox cb = (JComboBox)e.getSource();
			
			//If check box changed reset the board
			if (cb.getSelectedIndex() != oldIndex) {
				resetData();
			
			}
			//Obtain the index of the selected Combo box
			// Update appropriate view modules
	        int index = cb.getSelectedIndex();
	        updateTitleLabel(index);
	        img_canvas.updateWithIndex(index);
		}
		
	}


	////////////////////////////////////////////////////////////////////////////////////////
	//// Check Box and Supporting Methods
	////////////////////////////////////////////////////////////////////////////////////////
	
	/*
	 * Initializes every component of the Options Panel
	 * 
	 */
	private void InitializeOptionsPanel() {
		//Initialize Options Panel
		drawOptionsPanel = new JPanel();
		drawOptionsPanel.setLayout(new BoxLayout(drawOptionsPanel, BoxLayout.Y_AXIS));
	
		//Add options
		drawOptionsPanel.add(clearButton);
		//Initialize check box
		faceFeatures = new HashMap<String, JCheckBox>();
		
		
		//Create Listener to add
		CheckBoxListener cList = new CheckBoxListener();
		for (int i = 0; i < faceFeaturesStrings.length; i++){
			JCheckBox cbox =  new JCheckBox(faceFeaturesStrings[i]); //Create ne Check Box
			cbox.addActionListener(cList);//Add Listeners
			faceFeatures.put(faceFeaturesStrings[i], cbox); //Store field in Map
			drawOptionsPanel.add(cbox);
		}
		
		//Text fields
		JLabel redText = new JLabel(RGB[0] , SwingConstants.CENTER);
		JLabel greenText = new JLabel(RGB[1] , SwingConstants.CENTER);
		JLabel blueText = new JLabel(RGB[2] , SwingConstants.CENTER);
		
		//Add color scroll bar
		drawOptionsPanel.add(redText);
		drawOptionsPanel.add(redBar);
		drawOptionsPanel.add(greenText);
		drawOptionsPanel.add(greenBar);
		drawOptionsPanel.add(blueText);
		drawOptionsPanel.add(blueBar);
	}

	private class CheckBoxListener implements ActionListener {

		@Override
		public void actionPerformed(ActionEvent e) {
			img_canvas.repaint();
		}
		
	}

	////////////////////////////////////////////////////////////////////////////////////////
	//// JButton and Supporting Methods
	////////////////////////////////////////////////////////////////////////////////////////
	
	/*
	 * Initialize color scroll bar
	 */
	private void InitializeColorScrolls() {
		//Initialize feature color to be black
		color = Color.BLACK;
		
		//Intiial values
		int extent = 10;
		int init_value = 0;
		
		//Initialize values
		redBar = new JScrollBar(JScrollBar.HORIZONTAL, init_value, extent, 0, 255);
		blueBar = new JScrollBar(JScrollBar.HORIZONTAL, init_value, extent, 0, 255);
		greenBar = new JScrollBar(JScrollBar.HORIZONTAL, init_value, extent, 0, 255);
		
		//Make an array to make initializing easy
		JScrollBar[] colors = {redBar, blueBar, greenBar};
		ColorScrollListener cListener = new ColorScrollListener();
		
		// Add Listener to all colors
		for (JScrollBar cbar : colors) {
			cbar.addAdjustmentListener(cListener);
		}
	}

	private class ColorScrollListener implements AdjustmentListener{

		@Override
		public void adjustmentValueChanged(AdjustmentEvent e) {
			JScrollBar sBar = (JScrollBar)e.getSource();
			
			Color orig = color;
			int val = sBar.getValue();
			// Has to be within bounds
			assert(val >= 0 && val <= 255); 
			
			//Assign new color
			if (sBar.equals(redBar)){
				color = new Color(val, orig.getGreen(), orig.getBlue());
			} else if(sBar.equals(blueBar)){
				color = new Color(orig.getRed(), orig.getGreen(), val);
			} else {// sBar.equals(greenBar)
				color = new Color(orig.getRed(), val, orig.getBlue());
			}
			
			frame.repaint();
		}		
	}

	/*
	 * Initializes All buttons and Registers Button with Select point features
	 */
	private void InitializeButtons() {
		
		feature_points = new HashMap<JButton, Point2D.Double>();
		//Seperate Button all on its own
		clearButton = new JButton("Clear");
		clearButton.addActionListener(new ActionListener(){

			@Override
			public void actionPerformed(ActionEvent arg0) {
				selected = null;
				resetData(); //Reset the entire board
				updateSelectButtons();
				frame.repaint();
			}
			
		});
		
		selected = null; //No button is initially selected

		//Initialize JButtons
		leftEyeButton = new JButton("Left Eye"); 
		rightEyeButton = new JButton("Right Eye");
		noseButton = new JButton("Nose");
		leftEarButton = new JButton("Left Ear");
		rightEarButton = new JButton("Right Ear");
		topHeadButton = new JButton("Top of Head");
		
		//Adds all the Buttons to Map
		addButtonsToMap();
		
		//Add JButtons to data structure 
		//Points are null
		//null points == non selected
		nullOutPointsForFeatures();
		
		//Updates the colors of all the buttons
		//Should select all buttons to red
		updateSelectButtons();
		
		//Time to add buttons to the appropiate Panel
		faceSelectionPanel = new JPanel();
		faceSelectionPanel.setLayout(new GridLayout(1,feature_points.size()));	
		SelectedButtonListener sListener = new SelectedButtonListener();
		
		//Add listener to all 
		for (JButton button : feature_points.keySet()){
			button.addActionListener(sListener);
		}
		
		//Set doesn't guarantee any kind of order
		// I'm going to do the long version enter in one by one
		faceSelectionPanel.add(topHeadButton);
		faceSelectionPanel.add(noseButton);
		faceSelectionPanel.add(leftEarButton);
		faceSelectionPanel.add(rightEarButton);
		faceSelectionPanel.add(leftEyeButton);
		faceSelectionPanel.add(rightEyeButton);
		
	}

	/*
	 * Adds button to Map 
	 */
	private void addButtonsToMap() {
		assert(feature_points != null);
		assert(leftEyeButton != null);
		assert(rightEyeButton != null);
		assert(leftEarButton != null);
		assert(rightEarButton != null);
		assert(topHeadButton != null);
		assert(noseButton != null);
		
		feature_points.put(leftEyeButton, null);
		feature_points.put(rightEyeButton, null);
		feature_points.put(leftEarButton, null);
		feature_points.put(rightEarButton, null);
		feature_points.put(topHeadButton, null);
		feature_points.put(noseButton, null);
	}


	/*
	 * Updates the colors of all the buttons
	 * if the button is selected
	 * 
	 * @requires feature_points != null, feature_points contains all buttons
	 */
	private void updateSelectButtons() {
		for (JButton button : feature_points.keySet()){
			button.setOpaque(true); // This is needed for MAC OS
			button.setBorderPainted(false); // This is needed for MAC OS
			button.setFont(new Font("Serif", Font.BOLD, 12));
			
			//Adjust the color respectively to if it selected or it has a point
			if (feature_points.get(button) != null)
				button.setBackground(Color.GREEN);
			else if (button == selected){
				button.setBackground(Color.YELLOW);
			} else 
				button.setBackground(Color.RED);		
		}
	}


	/*
	 * Clears all memory of feature point selection
	 * 
	 *  @requires feature_points != null, All selector buttons != null
	 */
	private void nullOutPointsForFeatures(){
		//null out each Points
		for (JButton button : feature_points.keySet())
			feature_points.put(button, null);
	}
	
	/*
	 * Class that changes the color appropiately and the selection process
	 * of a point on the image per 
	 */
	private class SelectedButtonListener implements ActionListener {
		
		@Override 
		public void actionPerformed(ActionEvent e){
			JButton thisButton = (JButton)e.getSource();
			selected = thisButton;
			updateSelectButtons();
			frame.repaint();
		}
	}
	
	/*
	 * Checks if it is ok to draw on the face
	 */
	private boolean isOKToDraw(){
		boolean valid = true;
		//If everything is ok to draw
		for (Point2D.Double points : feature_points.values()){
			valid &= points != null;
		}
		return valid;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	//// Image Canvas and Supporting Methods
	////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Custom class that is used to display and draw on images that
	 * are defined as the fields of its outer class
	 * 
	 * this.img => Image to be displayed when painted
	 */
	private class ImageCanvas extends JComponent{
		
		/**
		 * Serialized ID
		 */
		private static final long serialVersionUID = 1L;
		BufferedImage img;
		
		/**
		 * default constructor
		 * size is set to maximum size of images
		 */
		public ImageCanvas(){
			setToDefault();
		}

		/**
		 * Update displayed image based off the index of the selected
		 * JComboBox.  
		 */
		public void updateWithIndex(int index) {
			if (index == 0) //Default value where no value is selected
				setToDefault();
			else
				updateImage(bufImages[index-1]);
			this.repaint();
		}
		
		/**
		 * Updates image to user defined images
		 * @param newB Buffered image to be assigned to this canvas
		 */
		public void updateImage(BufferedImage newB){
			img = newB;
			//Set the default size to the size of the image
			//This is dangerous(aesthetically) because what if the image is larger then the screen size???
			this.setPreferredSize(new Dimension(img.getWidth(), img.getHeight()));
		}
		
		/**
		 * Set to default state
		 */
		public void setToDefault(){
			img = null;
			int maxSize = 0;
			BufferedImage maxImg = null;
			
			//Find the maximum sized image
			for (BufferedImage bimg : bufImages){
				int temp = bimg.getWidth() * bimg.getHeight();
				if (temp > maxSize)
					maxImg = bimg;
			}
			//Set preferred size to maximum possible size
			this.setPreferredSize(new Dimension(maxImg.getWidth(), maxImg.getHeight()));
		}
		
		@Override
		public void paintComponent(Graphics g){
			super.paintComponent(g); //Have to call this
			Graphics2D g2d = (Graphics2D)g;
			g2d.setColor(color);
			//Draw the image of our favorite people
			if (img != null){
				g2d.drawImage(img, 
						0, /*1st X coordinate of Destination area*/ 
						0, /*1st Y coordinate of Destination area*/  
						img.getWidth(), /*2nd X coordinate of Destination area*/ 
						img.getHeight(), /*2nd Y coordinate of Destination area*/ 
						0, /*1st X coordinate of Source Image*/ 
						0, /*1st Y coordinate of Source Image*/ 
						img.getWidth(), /*2nd X coordinate of Source Image*/ 
						img.getHeight(), /*2nd Y coordinate of Source Image*/ 
						null); /*No current Image observer*/
			}	
			
			if (isOKToDraw()){ // if All the features are selected
				for (String feat : faceFeatures.keySet()){ //For each feature
					JCheckBox featBox = faceFeatures.get(feat); 
					if (featBox.isSelected()){
						ArrayList<Polygon> tempList = correspondingShape(feat);
						//For every polygon that it takes to compose graphical object
						for (Polygon p: tempList)
							g2d.fillPolygon(p);
					}
				}
			}
		}

		/**
		 * returns shape of corresponding selection
		 * 
		 * @requires that all points are selected
		 * @param feat, string representation of feature to draw
		 * @return List of all Polygons to draw
		 */
		private ArrayList<Polygon> correspondingShape(String feat) {
			//Obtain short names for all points that were selected
			Point2D.Double leftEar = feature_points.get(leftEarButton);
			Point2D.Double rightEar = feature_points.get(rightEarButton);
			Point2D.Double leftEye = feature_points.get(leftEyeButton);
			Point2D.Double rightEye = feature_points.get(rightEyeButton);
			Point2D.Double nose = feature_points.get(noseButton);
			Point2D.Double topHead = feature_points.get(topHeadButton);
			
			//Create a list of polygons
			ArrayList<Polygon> polys = new ArrayList<Polygon>();
			
			//Obtain the the feature from Feature drawer static methods
			if (feat.equals(faceFeaturesStrings[0])){ //Hair
				polys.add(FeatureDrawer.getHair(leftEar, rightEar,topHead));
			} else if (feat.equals(faceFeaturesStrings[1])){ //Ear hair
				polys.add(FeatureDrawer.getLeftEarHair(leftEar));
				polys.add(FeatureDrawer.getRightEarHair(rightEar));
			} else if (feat.equals(faceFeaturesStrings[2])){ //Nose Hair
				polys.add(FeatureDrawer.getNoseHair(nose));
			} else if (feat.equals(faceFeaturesStrings[3])) { //New EyeBrows
				polys.add(FeatureDrawer.getLeftEyeBrow(leftEye));
				polys.add(FeatureDrawer.getRightEyeBrow(rightEye));
			} else if (feat.equals(faceFeaturesStrings[4])) { // Mustache
				polys.add(FeatureDrawer.getMustache(nose));
			} else if (feat.equals(faceFeaturesStrings[5])) { // Beard
				polys.add(FeatureDrawer.getBeard(nose));
			} else if (feat.equals(faceFeaturesStrings[6])) { // Hat
				polys.add(FeatureDrawer.getHat(topHead, leftEar, rightEar));
			}
			
			return polys;
		}
		
	}
	
	/**
	 * Feature selected the points that are associated with facial features
	 */
	private class FeatureSelecter implements MouseInputListener {

		@Override
		public void mouseClicked(MouseEvent e) {
			if (!isOKToDraw()){ // If is not ok to draw add point to selected feature
				Point2D.Double temp = new Point2D.Double(e.getX(), e.getY());
				if (selected != null){
					feature_points.put(selected, temp);
					updateSelectButtons();
				}
			}
		}

		//Ehh so much wasted space
		@Override
		public void mouseEntered(MouseEvent arg0) {}

		@Override
		public void mouseExited(MouseEvent arg0) {}

		@Override
		public void mouseReleased(MouseEvent arg0) {}

		@Override
		public void mouseDragged(MouseEvent e) {}

		@Override
		public void mouseMoved(MouseEvent arg0) {}

		@Override
		public void mousePressed(MouseEvent e) {}
		
	}
}

