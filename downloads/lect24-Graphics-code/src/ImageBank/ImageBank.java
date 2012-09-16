package ImageBank;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;

import ImageLoader.ImageLoader;

public class ImageBank {
	private final String[] names = {"mernst.jpg" , 
		"krystay.jpg", "jcwr.jpg", "aeding.jpg", "mhotan.jpg"};
	
	//Lets keep an array of buffered images;
	private BufferedImage[] buf_images;
	
	//Lets keep an array of regular images
	private Image[] images;
	
	private static ImageBank instance;
	
	/*
	 * Private constructor for image bank
	 */
	private ImageBank(){
		images = new Image[names.length];
		buf_images = new BufferedImage[names.length];
		
		for (int i = 0; i < images.length; i++){
			images[i] = ImageLoader.loadImage(names[i]);
			buf_images[i] = ImageLoader.loadBufferedImage(names[i]);
		}
	}
	
	/**
	 * @return String array of image names
	 */
	public static String[] getImageNames(){
		return instance.names.clone();
	}
	
	/**
	 * @return returns array of Buffered Images that are defined within this class
	 */
	public static BufferedImage[] getBufferedImages(){
		updateInstance();
		return instance.buf_images.clone();
	}
	
	/**
	 * @return returns array of Images that are defined within this class
	 */
	public static Image[] getImages(){
		updateInstance();
		return instance.images.clone();
	}
	
	/**
	 * 
	 */
	private static void updateInstance(){
		if (instance == null)
			instance = new ImageBank();
	}
}
