************THE SEQUEL***************

This second commit is solely the formation of my subprogram 1 which finds the value of a byte passed to it.
It checks the value in the arguemnt $a1 and returns the answer in $v0.
The hex value 0 through 15 are returned if the byte is valid
16 is returned if white space is found
17 is for new line
18 is for null
and 19 for invalid byte

Requirements (Taken from Assigment Form): 
*******************************************************************************
You will write a MIPS program that reads a string of up to 1000 characters from user input.
The string consists of one or more substrings separated by comma. Spaces or tabs at the
beginning or end or around commas are ignored, those spaces or tabs should stay. For each
of the substring, if it is a hexadecimal string, i.e. it has only the characters from '0' to '9'
and from 'a' to 'f' and from 'A' to 'F', and it is of no more than 8 characters, the program
prints out the corresponding unsigned decimal integer. If the hexadecimal string has more
than 8 characters, the program prints out the string of “too large”. Otherwise, the program
prints out the string of “NaN”. Empty strings before the first comma, between commas or
after the last comma are also considered “NaN”. The output should be separated by
commas in the same way as the input.
The program must have the following 3 subprograms.
Subprogram 1:
It converts a single hexadecimal character to a decimal integer. Registers must be used
to pass parameters into the subprogram. Values must be returned via registers.
Subprogram 2:
It converts a single hexadecimal string to a decimal integer. It must call Subprogram 1
to get the decimal value of each of the characters in the string. Registers must be used
to pass parameters into the subprogram. Values must be returned via the stack.
Subprogram 3:
It displays an unsigned decimal integer. The stack must be used to pass parameters into
the subprogram. No values are returned.
The main program must call Subprogram 2 for conversion and call Subprogram 3 for
output.
******************************************************************************

//////////////////////////////////////////////////
Things I've done:
Sectioned off portions of my previous code (See MIPS_Assignment_1 repo) that could potentially be used as part of my subprogram
	Example: the portion where I Identify the the input bytes hexadecimal value has beeen sectioned off under subprogram_1
Allocated space for 1000 characters of input at the begining of my previous code 

Things that need to be done:
Write a coherent pseudo-code and Algorithm
Have each subprogram interact with eachother exclusively through arguement registers and stack pointers
Find a way to handle the conditions involving tabs and whitespace.
/////////////////////////////////////////////////

