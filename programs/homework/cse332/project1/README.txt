1. I found my TA to be of great help when he lead the section about generics. It really made part two go a lot more smoothly than it would have otherwise.

2. I tested my implementations by creating a test class that would use my stacks in various ways.

3. The scent of bitter almonds always reminded him of the fate of unrequited love.

4. No

5. 1 million: 17
	1 billion: 27
	1 trillion: 37
	Because the size doubles each time, you can calculate this taking the log of the total number. But because it starts out size 10, you must first divie the
	number by 10. So for example, 1 million would look like log(1million/10). (Log is log base 2)

6.
Class Stack
	queue named data

	push(object)
		data.enqueue(object)

	pop
		throw exception if data.size == 0
		aux = new queue
		while data.size > 1
			aux.enqueue(data.dequeue)
		
		object = data.dequeue
		data = queue
		return object

7. It would be worse to have an implementation with a queue because although it pushes with O(1) time, it has linear run time for popping, when the other implementations
	have O(1) for both pop and push (except for when an array needs to be resized).

8. Other than minor errors such as forgetting to convert all instances of 'double' to 'T', the one error I had was not declaring the type for the interface. I solved this
	eventually by looking up an example use of the comparable interface from the section slides.

9. I did not even look at Reverse.java to implement my stacks, so in otherwords nothing.

10. It only completes the basic requirements.

11. I really enjoyed working with generics, as it a feature of java that I have been using for a long time, never knowing the implementation and how it works.
	There was nothing I really did not enjoy about this assignment; even this write-up isn't bad at all. I wish I spent more time to do the extra components.

12. This is a fun, not too hard assinment, and is a great way to start off the class!


