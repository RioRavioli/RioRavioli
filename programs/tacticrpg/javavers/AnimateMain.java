import java.lang.Thread;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.sound.sampled.*;
import java.util.*;
import java.io.*;

public class AnimateMain extends JFrame implements KeyListener, Runnable {
	
	private final int SQUARE_SIZE = 40;
	private final int GRID_SIZE = 20;
	private final int BOARD_SIZE = SQUARE_SIZE * GRID_SIZE;
	private final String SQUARE_IMAGE = "visuals/square.png";
	private Graphics g;

	public static void main(String[] args) {
		AnimateMain testMan = new AnimateMain();
		testMan.run();
		new AnimateMain();
	//	new Thread(new AnimateMain()).start();
	}
			
	public AnimateMain() {
		super("Test Man");
	//	Music play = new Music();
//		play.run();
	}
	
	public void run() {
		setBackground(Color.WHITE);
		//MegaMan.loadStart();
		//MegaMan.loadRun();
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(BOARD_SIZE, BOARD_SIZE);
		setVisible(true);
		addKeyListener(this);
		g = getGraphics();
		//MegaMan.start(g);
		//while(true) {
		//	repaint();
		//}
	}
	
	public void paint(Graphics g) {
		//MegaMan.run(g);
		for (int i = 0; i < BOARD_SIZE; i += SQUARE_SIZE) {
			for (int j = 0; j < BOARD_SIZE; j += SQUARE_SIZE) {
				g.drawImage(new ImageIcon(SQUARE_IMAGE).getImage(), i, j, null);
			}
		}	
		Man.draw(g);
	}

	public void keyPressed(KeyEvent event) {
		char key = event.getKeyChar();
		switch(key) {
			case 'u':
				Man.move(0, 0, 0, SQUARE_SIZE);
				repaint();
				break;
			case 'o':
				Man.move(0, 0, SQUARE_SIZE, 0);
				repaint();
				break;
			case 'e':
				Man.move(0, SQUARE_SIZE, 0, 0);
				repaint();
				break;
			case '.':
				Man.move(SQUARE_SIZE, 0, 0, 0);
				repaint();
				break;
		}
	}

	public void keyReleased(KeyEvent event) {
	}

	public void keyTyped(KeyEvent event) {
	}


	class Music extends Thread {
		File track;

		public Music() {
			track = new File("music.wav");
		}

		public void run() {
			try {
				Clip clip = AudioSystem.getClip();
				clip.open(AudioSystem.getAudioInputStream(track));
				System.out.println("raseonuthunning");
				long clipLength = (long) (clip.getFrameLength() / clip.getFormat().getFrameRate() * 1000);
				clip.start();
				System.out.println(track.getName());
				new Scanner(System.in).next();
				//Thread.sleep(clipLength);
				System.out.println(track.getName());

			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
}
