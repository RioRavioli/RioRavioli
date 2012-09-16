package ImageLoader;

import java.awt.Image;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URI;

import javax.imageio.ImageIO;

/**
 * Wrapper class to implement Image loading procedures
 * @author mhotan
 *
 */
public class ImageLoader {

	/**
	 * Loads image stored at imgPathName
	 * 
	 * @param imgPathName path including name of BufferedImage to load
	 * @return BufferedImage found at imgPathName
	 */
	public static BufferedImage loadBufferedImage(String imgPathName){
		//Lets return a Buffered Image
		// Image data that can be directly manipulated
		// Including being drawn on
		BufferedImage img = null;
		try {
			File f = new File(imgPathName); 
			URI uri = f.toURI(); /* to URI Uniform Resource Identifier */
		    img = ImageIO.read(uri.toURL()); /*Complete URL(Uniform Resource Locator) path as argument*/
		} catch (IOException e) {
			e.printStackTrace(); /* Lazy exception handling */
			return null;
		}
		return img;
	}
	
	/**
	 * Reutrns Image stores at imgPathName
	 * 
	 * @param imgPathName path including name of Image to load
	 * @return Image found at imgPathName
	 */
	public static Image loadImage(String imgPathName){
		//Lets return a regular Image 
		Image img = Toolkit.getDefaultToolkit().getImage(imgPathName);
		return img;
	}
}
