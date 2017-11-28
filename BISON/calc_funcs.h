#include <stdio.h>
#include <limits.h>
#define BASE 1234577

long int value_in_base(long int a) {
	if(a < 0)
		return (BASE + a);
	else
		return (a % BASE);
}

long int add(long int a, long int b) {
	a = value_in_base(a);
	b = value_in_base(b);
	long int sum = (a+b)%BASE;
	return sum;
}

long int subtract(long int a, long int b) {
	b = value_in_base(-b);
	return add(a, b);
}

long int multiply(long int a, long int b) {
	a = value_in_base(a);
	b = value_in_base(b);
	long int multi = (a*b) % BASE;
	return multi;
}

long int extendedGCD(long int a, long int b, long int *x, long int *y) {
    // Base Case
    if (a == 0) {
        *x = 0;
        *y = 1;
        return b;
    }
 
    long int x1, y1; // To store results of recursive call
    long int gcd = extendedGCD(b%a, a, &x1, &y1);
 
    // Update x and y using results of recursive
    *x = y1 - (b/a) * x1;
    *y = x1;
    return gcd;
}

long int divide(long int a, long int b) {
	a = value_in_base(a);
	b = value_in_base(b);

	long int x, y;
	extendedGCD(b, BASE, &x, &y);
    // printf("x: %ld, y: %ld\n\n", x, y);

	long int div = multiply(a, x);
	return div;
}

long int power(long int x, long int n) {
    printf("wykladnik=%li\n", n);
	x = value_in_base(x);

	// printf("Power: x = %li, n = %li\n", x, n);

	if (n == 0)
    	return 1;

    if (n < 0) {
    	x = divide(1, x);
    	n = subtract(0, n);
    }
    
    long int y = 1;
    while (n > 1) {
    	if (n % 2 == 0) {
    		x = multiply(x, x);
        	n = divide(n, 2);
        }
      	else {
        	y = multiply(x, y);
        	x = multiply(x, x);
        	n = divide(subtract(n, 1), 2);
    	}
    }
    return multiply(x, y);
}

long int modulo(long int a, long int b) {
	a = value_in_base(a);
	b = value_in_base(b);

	printf("Modulo: a = %li, b = %li\n", a, b);

	long int m = (a % b);

	return m;
}

// int main() {
// 	// MAX signed long int = 9223372036854775807 (64bit compiler) (%li)
// 	// long int c = LONG_MAX;
// 	// printf("MAX long int: %li\n", c);

// 	// addition
// 	long int a = 1234577;
// 	long int b = -1;

// 	printf("add: %li\n\n", add(a, b));

// 	// Subtraction
// 	a = 0;
// 	b = 0;
// 	printf("subtract: %li\n\n", add(a, b));

// 	// Multiplication
// 	a = 1234576;
// 	b = 1234576;
// 	printf("multi: %li\n\n", multiply(a, b));

// 	// Division
//     a = 1, b = -580978;
//     printf("divide: %li\n\n", divide(a, b));

//     // Power
//     a = 2, b = 100;
//     printf("power: %li\n\n", power(a, b));

//     // Modulo
//     a = 2898789S, b = 100;
//     printf("modulo: %li\n\n", modulo(a, b));

//     return 0;
// }