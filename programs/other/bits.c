#include <stdio.h>

int negate();

int main() {
	printf("%d",  negate(5));
}

int negate(int num) {
	num = ~num + 1;
	return num;
}


