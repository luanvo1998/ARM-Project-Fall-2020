	.globl isPrimeAssembly
isPrimeAssembly:
	/*length in X3
	//return address a - X0
	//return address prime - X1
	//return address composite - X2*/

	SUB SP, SP, #160		// create stack
	//STORING CONSTANTS
	STUR X19, [SP,#0]		//i
	STUR X20, [SP, #16]		//j
	STUR X21, [SP,#32]		//k
	STUR X22, [SP, #48]		//d
	STUR X23, [SP,#64]		//temp - SEEMS LIKE IT HAS NO USE IN C CODE, SO USE FOR HOLDING TEMP VALUES
	//STORING EXTRA
	STUR X24, [SP,#80]
	STUR X25, [SP,#96]
	STUR X26, [SP,#112]
	//STORE X30
	STUR X30, [SP, #128]	//X30 IS LR
	STUR X27, [SP,#144]

	//INITIALIZING CONSTANTS
	ADD X19, XZR, XZR		//I = 0
	ADD X20, XZR, XZR		//J = 0
	ADD X21, XZR, XZR		// K = 0
	ADD X22, XZR, XZR		//D = 0
	ADD X23, XZR, XZR		//temp = 0
	ADD X27, XZR, XZR
	//INITIALIZING EXTRA
	ADD X24, XZR, XZR
	ADD X25, XZR, XZR
	ADD X26, XZR, XZR

	Loop:
		//SUB X23, X19, #2
		SUB X23, X19, X3		// X23 = i - len
		CBZ X23, Exit			// If i == len => branch to exit

		SUB SP, SP, #16			//create stack for updating index
		STUR X30, [SP, #0]		//save return address
		LSL X9, X19, #3			//Shifting i by 1 in address
		ADD X9, X9, X0			//shfiting current address of array a
		LDUR X27, [X9, #0]		//x27 = a[i] (save in arguements /result register across calls)
		BL isPrime 				//jump to isPrime with parameter a[x0] (where x0 = i = x19)

		ADD X22, X5, XZR		// d = return from isPrime = isPrime(a[i]) (return reggister is x5)
		SUB X10, X22, #1		//temp = d - 1
		LDUR X30, [SP, #0]		//restore return address
		ADD SP, SP, #16			//restore stack

		CBNZ X10, Else 			//if (d-1) != 0 (means d not equal to 1) jumps to Else

		//if d == 1
		LSL	X11, X20, #3
		ADD X11, X11, X1			//shifting current address of prime
		ADD X25, XZR, X27		//prime[j] = a[i] (note: a[i] stored in reg x27)
		STUR X25, [X11, #0]		//STORE BACK TO (SHIFTED) PRIME[j]
		ADD X20, X20, #1		//j = j + 1

		ADD X19, X19, #1		//Increment i++
		B Loop					//jumps back to loop

		//else
		Else:
			LSL X12, X21, #3		//LSL x21 to become an address increment of 1
			ADD X12, X12, X2			//shifting current address of composite
			ADD X26, XZR, X27		//composite[k] = a[i] (note: a[i] stored in reg x27)
			STUR X26, [X12, #0]		//STORE BACK TO (SHIFTED) COMPOSITE[k]
			ADD X21, X21, #1		//k = k + 1

			ADD X19, X19, #1		//Increment i++
			B Loop					//jumps back to loop

	Exit:	//EXIT function
		LDUR X19, [SP,#0]		//i
		LDUR X20, [SP, #16]		//j
		LDUR X21, [SP,#32]		//k
		LDUR X22, [SP, #48]		//d
		LDUR X23, [SP,#64]		//temp - SEEMS LIKE IT HAS NO USE IN C CODE, SO USE FOR HOLDING TEMP VALUES
		LDUR X24, [SP,#80]
		LDUR X25, [SP,#96]
		LDUR X26, [SP,#112]
		LDUR X30, [SP, #128]
		LDUR X27, [SP,#144]
		ADD SP, SP, #160		//reduce stack to zero
		BR X30			//jump back to main

isPrime:
	ADD X5, XZR, XZR

	//Initializing constants
	ADD X13, XZR, XZR 		//i = 0
	ADD X13, X13, #2		//i = 2
	ADD X14, XZR, XZR		//temp14 = divisor = 0
	ADD	X14, X14, #2		//set divisor to 2

		//Udiv = quotient = int(dividend/divisor) (WHERE X15 IS QUOT, X13 IS DIVISOR, X27 IS DIVIDEND - OR N)
		//Remainder = dividend - quotient*divisor
	Loop1:
		SDIV X15, X27, X14
		SUBS XZR, X15, X13
		B.LO EXIT1			//if (n/2) LARGER/EQUAL than i, so branch when LESS than

		UDIV X15, X27, X13	//quotient = n/i
		MUL X15, X15, X13	//quotient = quotient * divisor
		SUB X16, X27, X15	//temp16 = dividend - (quotient*divisor)

		CBZ X16, IF1
		ADD X13, X13, #1	//increment i: i++
		B Loop1

		IF1:
			ADD X5, X5, #0	//return 0
			BR X30


	EXIT1:
		ADD X5, X5, #1
		BR X30
