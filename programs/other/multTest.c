#include<stdio.h>

int mult(int x, int y);

int main() {
	int x;
	int y;
	x = 4;
	y = 3;
	printf("%d\n", 6 * 7);
	printf("%d\n", x * y);
	int a = mult(2, 4);
	printf("%d\n", mult(3, 19));
}

int mult(int x, int y) {
	int z = x * y;
	printf("%d\n", z);
	return z; 
}


