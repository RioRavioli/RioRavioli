package hw2;

import java.util.Random;

public class RandomHello {
	private static final String[] GREETINGS = { "Hello World", "Hola Mundo", "Bonjour Monde", "Hallo Welt", "Cian Mondo" };

	public static void main(String[] args) {
		RandomHello world = new RandomHello();
		System.out.println(world.getGreeting());
	}

	public String getGreeting() {
		Random rng = new Random();
		int choice = rng.nextInt(5);
		return GREETINGS[choice];
	}
}
