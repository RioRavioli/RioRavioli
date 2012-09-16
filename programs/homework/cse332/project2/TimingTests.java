/*
 * Rio Bacon
 * CSE 332
 * May 8th, 2012
 *
 * TimingTests prints the amount of time it takes for WordCount to process
 * hamlet.txt and the-new-atlantis.txt using various data structures and
 * sorting algorithms.
 */

public class TimingTests {
	public static void main(String[] args) {
		long bisStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-is", "hamlet.txt"});
		long bisEnd = System.currentTimeMillis();

		long bhsStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-hs", "hamlet.txt"});
		long bhsEnd = System.currentTimeMillis();

		long bosStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-os", "hamlet.txt"});
		long bosEnd = System.currentTimeMillis();

		long aisStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-is", "hamlet.txt"});
		long aisEnd = System.currentTimeMillis();

		long ahsStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-hs", "hamlet.txt"});
		long ahsEnd = System.currentTimeMillis();

		long aosStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-os", "hamlet.txt"});
		long aosEnd = System.currentTimeMillis();

		long misStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-is", "hamlet.txt"});
		long misEnd = System.currentTimeMillis();

		long mhsStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-hs", "hamlet.txt"});
		long mhsEnd = System.currentTimeMillis();

		long mosStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-os", "hamlet.txt"});
		long mosEnd = System.currentTimeMillis();

		long hisStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-is", "hamlet.txt"});
		long hisEnd = System.currentTimeMillis();

		long hhsStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-hs", "hamlet.txt"});
		long hhsEnd = System.currentTimeMillis();

		long hosStart = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-os", "hamlet.txt"});
		long hosEnd = System.currentTimeMillis();

		long bisStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-is", "the-new-atlantis.txt"});
		long bisEnd2 = System.currentTimeMillis();

		long bhsStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-hs", "the-new-atlantis.txt"});
		long bhsEnd2 = System.currentTimeMillis();

		long bosStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-b", "-os", "the-new-atlantis.txt"});
		long bosEnd2 = System.currentTimeMillis();

		long aisStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-is", "the-new-atlantis.txt"});
		long aisEnd2 = System.currentTimeMillis();

		long ahsStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-hs", "the-new-atlantis.txt"});
		long ahsEnd2 = System.currentTimeMillis();

		long aosStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-a", "-os", "the-new-atlantis.txt"});
		long aosEnd2 = System.currentTimeMillis();

		long misStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-is", "the-new-atlantis.txt"});
		long misEnd2 = System.currentTimeMillis();

		long mhsStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-hs", "the-new-atlantis.txt"});
		long mhsEnd2 = System.currentTimeMillis();

		long mosStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-m", "-os", "the-new-atlantis.txt"});
		long mosEnd2 = System.currentTimeMillis();

		long hisStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-is", "the-new-atlantis.txt"});
		long hisEnd2 = System.currentTimeMillis();

		long hhsStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-hs", "the-new-atlantis.txt"});
		long hhsEnd2 = System.currentTimeMillis();

		long hosStart2 = System.currentTimeMillis();
		WordCount.main(new String[]{"-h", "-os", "the-new-atlantis.txt"});
		long hosEnd2 = System.currentTimeMillis();


		System.out.println("hamlet.txt:");
		System.out.println("-b, -is:  " + (bisEnd - bisStart));
		System.out.println("-b, -hs:  " + (bhsEnd - bhsStart));
		System.out.println("-b, -os:  " + (bosEnd - bosStart));
		System.out.println("-a, -is:  " + (aisEnd - aisStart));
		System.out.println("-a, -hs:  " + (ahsEnd - ahsStart));
		System.out.println("-a, -os:  " + (aosEnd - aosStart));
		System.out.println("-m, -is:  " + (misEnd - misStart));
		System.out.println("-m, -hs:  " + (mhsEnd - mhsStart));
		System.out.println("-m, -os:  " + (mosEnd - mosStart));
		System.out.println("-h, -is:  " + (hisEnd - hisStart));
		System.out.println("-h, -hs:  " + (hhsEnd - hhsStart));
		System.out.println("-h, -os:  " + (hosEnd - hosStart));

		System.out.println("the-new-atlantis.txt:");
		System.out.println("-b, -is:  " + (bisEnd2 - bisStart2));
		System.out.println("-b, -hs:  " + (bhsEnd2 - bhsStart2));
		System.out.println("-b, -os:  " + (bosEnd2 - bosStart2));
		System.out.println("-a, -is:  " + (aisEnd2 - aisStart2));
		System.out.println("-a, -hs:  " + (ahsEnd2 - ahsStart2));
		System.out.println("-a, -os:  " + (aosEnd2 - aosStart2));
		System.out.println("-m, -is:  " + (misEnd2 - misStart2));
		System.out.println("-m, -hs:  " + (mhsEnd2 - mhsStart2));
		System.out.println("-m, -os:  " + (mosEnd2 - mosStart2));
		System.out.println("-h, -is:  " + (hisEnd2 - hisStart2));
		System.out.println("-h, -hs:  " + (hhsEnd2 - hhsStart2));
		System.out.println("-h, -os:  " + (hosEnd2 - hosStart2));
	}
}
