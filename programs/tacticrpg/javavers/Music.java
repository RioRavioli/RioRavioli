import java.util.*;
import java.io.*;
import javax.sound.sampled.*;

class Music extends Thread {
	File track;

	public Music() {
		track = new File("music.wav");
	}

	public void run() {
		try {
			Clip clip = AudioSystem.getClip();
			clip.open(AudioSystem.getAudioInputStream(track));
			System.out.println("running");
			long clipLength = (long) (clip.getFrameLength() / clip.getFormat().getFrameRate() * 1000);
			clip.start();
			new Scanner(System.in).next();
			//Thread.sleep(clipLength);
			System.out.println("running");

		} catch(Exception e) {
			System.out.println("saenotuhaoens");
		}
	}
}
