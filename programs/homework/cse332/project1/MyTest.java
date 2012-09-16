class MyTest {
	public static void main(String[] args) {
		GListStack<Double> s = new GListStack<Double>();
		System.out.println(s.isEmpty());
		s.push(3.0);
		System.out.println(s.pop());
		s.push(4.0);
		s.push(5.0);
		System.out.println(s.pop());
		System.out.println(s.pop());
		System.out.println(s.isEmpty());
		for (int i = 0; i < 100; i++) {
			s.push((double) i);
		}	
		System.out.println(s.peek());
		s.push(111.111);
		System.out.println(s.peek());
		System.out.println(s.pop());
		System.out.println(s.peek());
		for (int i = 0; i < 100; i++) {
			System.out.println(s.pop());
		}	
		s.pop();
	}
}
