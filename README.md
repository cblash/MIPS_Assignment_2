************THE SEQUEL***************

In my third commit I hastely prepared both my main program to call subprograms 2 and 3 and my subprogram 3.
I felt that preparing these two programs was the logical next step as the main program is vitally important albeit small and the subprogra three is large but requires few changes from my outlined subprogram 3 in commit_1.s


Here in this fourth commit I sought revise my main program and subprograms 1 and 3 so that they are properly commented. 
They are also much more readable and fall within my pseudo code and algorithm that I have prepared below the requirements listed in the project

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

++++++++++++++++++++++
Algorithm :
++++++++++++++++++++++
1. read user input
2. proceed to input string decipherer (subprogram 2)
3. decipher unread byte
	a. if NULL, enter key or comma go to 4. 
	b. if actual hex number, check for invalid string input and either add number to sum return to 3. or go to 4. as NaN
	c. if white space back to 3.
4. print result from 3. (subprogram 3)
	a. if NULL or enter key received end program
	b. otherwise print comma and go back to 2
++++++++++++++++++++++

+++++++++++++++++++++++++++
Pseudo Code
+++++++++++++++++++++++++++
Main:
Read user input 
Move input string address into sub_2 arguements
Go to sub_2
save return values
move value into stack parameters for sub_3
call sub_3

sub_1(takes byte from sub_2):
check byte value
If tab or space bar return 16
If newline or null return 18
if not a hex number return 19
if comma return 20
otherwise return corresponding 0 through 15 hex value to sub_2

sub_2(takes input string address from main):
save return address
read byte using input string address
move byte into sub_1 arguements
call sub_1
receive returned value
if value is comma
	if number hasn't been received
		return 0 as integer, string as output type, current input string address and false termination flag
	else 
		return current sum as integer, integer as output type, current input string address and false termination flag
else if value is NaN
	return 1 as integer, string as output type, current input string address and false termination flag
else if value is whitespace
	white space has now been received
	last byte received was white space
	increment input string address 
	proceed back read byte
else if newline or null
	if hex number has been received 
		return current sum as integer, integer as output type, current input string address and true termination flag
	else
		return 1 as integer, string as output type, current input string address and true termination flag
else
	if hex number has been received
		if space has been recieved
			if last byte received was space
				return 1 as integer, string as output type, current input string address and false termination flag
			else
				multiply sum by 16 and add hex value 
				increment input string address
				back to read byte
		else
			multiply sum by 16 and add hex value
			increment input string address
			back to read byte
	else
		multiply sum by 16 and add hex value
		increment input string address
		back to read byte


sub_3(takes integer, output type, termination flag):
	check output type
	if integer
		print integer
		if termination flag true 
			return to main
		else
			print comma
			return to main
	else if string
		if integer is 0
			print "too large"
			if termination flag true 
				return to main
			else
				print comma
				return to main
		else
			print "NaN"
			if termination flag true 
				return to main
			else
				print comma
				return to main

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//////////////////////////////////////////////////
Things I've done:
Allocated space for 1000 characters of input at the begining of my previous code 
Write a coherent pseudo-code and Algorithm
Have each subprogram interact with eachother exclusively through arguement registers and stack pointers
completed subprograms 1 and 3

Things that need to be done:

Find a way to handle the conditions involving tabs and whitespace.
	(should be in subprogram 2)
/////////////////////////////////////////////////

