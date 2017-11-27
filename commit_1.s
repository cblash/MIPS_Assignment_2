.data			#code portion for predefined data
str:	.space 9 	#allocates uninitialized 9 bytes of information for string including NULL character
error:	.asciiz "Invalid hexadecimal number."	#error message to be displayed if input string found to be invalid
.text			#code portion for instructions
User_Input: 
	li $v0, 8	#syscall code for reading in strings
	la $a0, str	#load space into call variable
	li $a1, 9	#allow input buffer size of 9 bytes
	syscall		#call for user input
initializations:
	li $s0, 0	#to hold the decimal value of final converted hexadecimal number
	li $s1, 0	#used to determine if hex number has been read in at one point in the program
	li $s2, 0	#used to determine if whitespace has been read in at one point in the program
	li $s3, 0	#used to determine last byte read was whitespace (1) or hex number (0)
	li $s4, 10	#used for division during final displaying process
loop:
	lb $t0, 0($a0)	#read in byte from input string	
check_value1:
	slti $t1, $t0, 103	#check if byte from input is less than 103 (highest hex digit is 'f', decimal value 102)
	bne $t1, $zero, af_range	#if byte is less than 103 proceed to a-f range of values
	j invalid			#if greater than or equal to 103 byte is invalid
af_range:
	slti $t1, $t0, 97	#check if byte from input is less than 97, decimal value of 'a'
	bne $t1, $zero, check_value2	#if byte is less than 97, proceed to check for invalid byte values between A-F and a-f
	subi $t2, $t0, 87	#if byte is between 97 and 102, obtain the true value of the hex number between 'a' and 'f'
	j sum_check1		#proceed to add value to total sum
check_value2:
	slti $t1, $t0, 71	#check if byte from input is less than 71. the range of characters 'A' through 'F' is 65-70
	bne $t1, $zero, AF_range	#if byte is less than 71 proceed to A-F range of values
	j invalid			#if byte value is between 71 and 96 it is an invalid input
AF_range:
	slti $t1, $t0, 65	#check if byte from input is less than 65, decimal value of 'A'
	bne $t1, $zero, check_value3	#if byte is less than 65, proceed to check for invalid byte values between 0-9 and A-F
	subi $t2, $t0, 55	#if byte is between 65 and 70, obtain the true value of the hex number between 'A' and 'F'
	j sum_check1	 	#proceed to add value to total sum
check_value3:
	slti $t1, $t0, 58	#check if byte from input is less than 58. the range of characters '0' through '9' is 48-57
	bne $t1, $zero, digit_range	#if byte is less than 58 proceed to 0-9 range of values
	j invalid			#if byte value is between 58 and 64, it is an invalid input
digit_range:
	slti $t1, $t0, 48	#check if byte from input is less than 48, decimal value of '0'
	bne $t1, $zero, low_range	#if less than 48, proceed to lower range of deicmal values
	subi $t2, $t0, 48	#find hexadecimal value of current byte from input
	j sum_check1		#proceed to sum hexadecimal value into total
low_range:
	subi $t3, $t0, 32		#check to see if the decimal value of the byte 32, the value of space key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	subi $t3, $t0, 9		#check to see if the decimal value of the byte 9, the value of tab key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	subi $t3, $t0, 10		#check to see if the decimal value of the byte 10, the value of enter key, via subtraction
	beq $t3, $zero, newline_char	#if the above difference is zero, then handle the byte as a newline character
	beq $t0, $zero, null_byte	#Finally, if $t0, the byte read in, is zero it is a null, end of string character
	j invalid			#if none of the above are true, proceed to invalid output
white_space:
	li $s3, 1		#signify that the most recent byte read was a white space character
	li $s2, 1		#signify that a white space has been read into the program at one point
	addi $a0, $a0, 1	#increment input string address by one to read the next byte of information
	j loop			#return to start of loop
newline_char:
	bne $s1, $zero, display_sum	#if a hex number has been read in at one point and the byte is return key it's time to display the sum
	j invalid		#if a hex number hasn't been read at any point and the byte is a return key, the input is not valid
null_byte:
	bne $s1, $zero, display_sum	#if a hex number has been read in at one point and the byte is NULL it's time to display the sum
	j invalid				#otherwise end the program with error message
sum_check1:
	bne $s1, $zero, sum_check2	#if a hex number has been read in at anypoint proceed to check if whitespace has been read in as well
	j first_sum			#otherwise proceed to the first addition to the total sum
sum_check2:
	bne $s2, $zero, sum_check3	#if white space has been read in at one point proceed to check the validity of the string
	j sum_up			#otherwise proceed to add the hex number to sum
sum_check3:
	beq $s3, $zero, sum_up		#if the previous byte read was not a space proceed to the sum as normal
	j invalid			#if the previous byte was a space and both a space and a hex number were read in at one point,
			 		#then this implies a string with two space seperated hex numbers was entered, an invalid input 
sum_up:
	sll $s0, $s0, 4			#shifting the sum left by 4 bits is equivalent to multiplying the sum by 16. See pseudo code
	add $s0, $t2, $s0		#after multiplying by 16 add the newly checked hex nummber to the sum
	li $s3, 0			#signify that the previously read byte is a hex number now
	li $s1, 1			#signify that a hex number has been read in at one point
	addi $a0, $a0, 1		#increment input string address by one to read the next byte of information
	j loop			#proceed back to start of loop
first_sum:
	add $s0, $t2, $s0		#add the first hex number recieved to the total sum
	li $s3, 0			#signify that the previously read byte is a hex number now
	li $s1, 1			#signify that a hex number has been read in at one point
	addi $a0, $a0, 1		#increment input string address by one to read the next byte of information
	j loop			#proceed back to start of loop
invalid: # section to print error message
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 10	#load ascii value of newline into arguement register
	syscall		#call to display newline
	li $v0, 4		#load syscall code for string display	
	la $a0, error		#load in previously defined string address	
	syscall			#call to display error message
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 10	#load ascii value of newline into arguement register
	syscall		#call to display newline
	j exit			#proceed to exit program
display_sum:	#section to print converted user input integer
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 10	#load ascii value of newline into arguement register
	syscall		#call to display newline
	li $v0, 1	#syscall code for outputting 
	divu $s0, $s4	#divide the sum by 10 to ensure that a 2's complement (negative) number is not output 
	mflo $t4	#store the quotient
	mfhi $t5	#store the remainder
	beq $t4, $zero, alt_display_sum	#if the quotient is zero proceed to only display the remainder
	add $a0, $t4, $zero		#otherwise display the quotient
	syscall				#call for integer output
	add $a0, $t5, $zero		#then display the remainder
	syscall				#call fo integer output
	li $v0, 11			#load syscall code for ascii character output
	li $a0, 10			#load ascii value of newline into arguement register
	syscall				#call to display newline
	j exit				#proceed to exit program
alt_display_sum:	#If the original sum is less than 10 display only the reaminder
	li $v0, 1	#syscall code for outputting 
	add $a0, $t5, $zero	#load the remainder into arguements register	
	syscall			#call to display final integer
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 10	#load ascii value of newline into arguement register
	syscall		#call to display newline
exit:			
	li $v0, 10	#load syscall code for program exit
	syscall		#exit program
