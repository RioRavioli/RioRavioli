import java.util.*;
import java.awt.*;
import javax.swing.*;

class Man {
	private final int SQUARE_SIZE = 40;
	private final int GRID_SIZE = 20;
	private final int BOARD_SIZE = SQUARE_SIZE * GRID_SIZE;

	private static Image man = new ImageIcon("visuals/man.png").getImage();
	private static int posx = 1;
	private static int posy = 1;

	public static void draw(Graphics g) {
		g.drawImage(man, posx, posy, null);
	}

	public static void move(int up, int down, int right, int left) {
		posy -= up;
		posy += down;
		posx -= right;
		posx += left;
	}
}
