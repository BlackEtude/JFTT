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

	long int div = multiply(a, x);
	return div;
}

long int power(long int x, long int n) {
	x = value_in_base(x);

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