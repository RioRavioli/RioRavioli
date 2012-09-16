#include<stdio.h>

int power(int base, int exponent);

int main() {
	printf("WELCOME TO CALCULATOR!\n");
}

//Power function. Gives the result of the first int to the second int's power.
int power(int base, int exponent) {
	int result;

	result = 1;
	for (int i = 0; i < exponent; i++) {
		result *= base;
	}
	return result;
}

