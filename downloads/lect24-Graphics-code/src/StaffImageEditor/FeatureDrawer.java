package StaffImageEditor;

import java.awt.Polygon;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Double;

public class FeatureDrawer {

	/**
	 * Draw me a new haristyle
	 */
	public static Polygon getHair(Point2D.Double leftEar, Point2D.Double rightEar, Point2D.Double topOfHead){
		int leX = (int)leftEar.x;
		int leY = (int)leftEar.y;
		int reX = (int)rightEar.x;
		int reY = (int)rightEar.y;
		int thY = (int)topOfHead.y;
		int jagged = (40+leX-reX)/4;
		
		//Map out the points of the hair
		int x[] = {leX , leX, reX, reX, reX-20, reX-20, 
				reX-5+jagged, reX-5+jagged, reX-5+jagged*2, 
				reX-5+jagged*3, reX-5+jagged*3, leX+20, leX+20 };
		int y[] = {leY+10, thY+30, thY+30, reY+10, 
				reY+10, thY-50, thY-10, 
				thY-50, thY-10, thY-50, thY-10, thY-50, leY+10};
		int count = 13;
		return new Polygon(x,y,count);
	}

	/**
	 * Draw me a Nose
	 */
	public static Polygon getNoseHair(Double nose) {
		int nx = (int)nose.x;
		int ny = (int)nose.y;	
		
		//Create Corresponding arrays of points
		int x[] = {nx-10, nx-15, nx-12, nx-7, nx-7, nx-4, nx, nx+4, nx+3, nx+3,nx+10, nx+13, nx+10 };
		int y[] = {ny, ny+20, ny+20, ny+5, ny+15, ny +15, ny+5, ny+10, ny+10, ny+5, ny+20, ny+20, ny};
		return new Polygon(x,y,x.length);
	}

	/**
	 * Draw me some Ear hair
	 */
	public static Polygon getMustache(Double nose) {

		int nx = (int)nose.x;
		int ny = (int)nose.y+10;	
		
		//Create Corresponding arrays of points
		int x[] = {nx, nx-20, nx-80, nx, nx+80, nx+20};
		int y[] = {ny, ny+10, ny+40, ny+20, ny+40, ny+10};
		return new Polygon(x,y,x.length);
	}

	/**
	 * Draw me some Ear hair
	 */
	public static Polygon getLeftEarHair(Double leftEar) {
		int x = (int)leftEar.x;
		int y = (int)leftEar.y;	
		int scale = 20;
		
		//Create Corresponding arrays of points
		int xarr[] = {x, x+scale, x+scale*2, x+scale, x, x+scale*5/4, 
				x+scale*9/4, x+scale*5/4, x, x+scale*5/4, x+scale*5/4, x+scale};
		int yarr[] = {y, y-scale, y-scale/4, y-scale/2, y, 
				y-2, y+scale/2, y+scale/4, y, y+scale/2, y+scale*5/4, y+scale*3/4};
		
		return new Polygon(xarr,yarr,xarr.length);
	}

	/**
	 * Draw me some Ear hair
	 */
	public static Polygon getRightEarHair(Double rightEar) {
		int x = (int)rightEar.x;
		int y = (int)rightEar.y;	
		int scale = 20;
		
		//Create Corresponding arrays of points
		int xarr[] = {x, x-scale, x-scale*2, x-scale, x, x-scale*5/4, 
				x-scale*9/4, x-scale*5/4, x, x-scale*5/4, x-scale*5/4, x-scale};
		int yarr[] = {y, y-scale, y-scale/4, y-scale/2, y, y-scale/2, y+scale/2, 
				y+scale/4, y, y+scale/2, y+scale*5/4, y+scale*3/4};
		return new Polygon(xarr,yarr,xarr.length);
	}

	/*
	 * Draw me a Left Eye Brow
	 */
	public static Polygon getLeftEyeBrow(Double leftEye) {
		int x = (int)leftEye.x;
		int y = (int)leftEye.y-30;	
		int scale = 20;
		int xarr[] = {x, x+scale*3/2, x+scale*3/2, x, x-scale, x-scale};
		int yarr[] = {y, y+scale/4, y-scale/4, y-scale/2, y, y+scale/2};
		return new Polygon(xarr,yarr,xarr.length);
	}
	
	/*
	 * Draw me a Right Eye Brow
	 */
	public static Polygon getRightEyeBrow(Double rightEye) {
		int x = (int)rightEye.x;
		int y = (int)rightEye.y-50;
		int scale = 20;
		int xarr[] = {x, x+scale, x+scale, x, x-scale*2, x-scale*2};
		int yarr[] = {y, y+3, y-7, y-10, y+10, y+20};
		return new Polygon(xarr,yarr,xarr.length);
	}

	/*
	 * Draw me a Beard!
	 */
	public static Polygon getBeard(Double nose) {
		int x = (int)nose.x;
		int y = (int)nose.y+60;
		int scale = 40;
		int xarr[] = {x-scale, x+scale, x+scale/2, x-scale/2};
		int yarr[] = {y, y, y+scale*2, y+scale*2};
		return new Polygon(xarr, yarr, xarr.length);	
	}

	/*
	 * Draw me a Hat!
	 */
	public static Polygon getHat(Double topHead, Double leftEar, Double rightEar) {
		int scale = 150;
		int hatBrim = 50;
		int thX = (int)topHead.x;
		int thY = (int)topHead.y;
		int reX = (int)rightEar.x;
		int leX = (int)leftEar.x;
		
		int xarr[] = {leX+20, reX-20, thX};
		int yarr[] = {thY+hatBrim, thY+hatBrim, thY-scale};
		return new Polygon(xarr, yarr, xarr.length);
	}
}

