.data			#code portion for predefined data
str:	.space 1001 	#allocates uninitialized 9 bytes of information for string including NULL character
error:	.asciiz "NaN"	#error message to be displayed if input string found to be invalid
large:	.asciiz "too large"	#error message to be displayed if input string found to be too large

.text			#code portion for instructions
main: 
	li $v0, 8	#syscall code for reading in strings
	la $a0, str	#load space into call variable
	li $a1, 1001	#allow input buffer size of 9 bytes
	syscall		#call for user input
initializations:
	li $s1, 0	#used to determine if hex number has been read in at one point in the program
	li $s2, 0	#used to determine if whitespace has been read in at one point in the program
	li $s3, 0	#used to determine last byte read was whitespace (1) or hex number (0)
	li $s4, 10	#used for division during final displaying process
	addi $sp, $sp, -16	#allot stack space of 4 words: (0-3) hex number sum, (4-7) output type, 
				#(8-11) input string address, (12-15) program termination flag
loop:
	add $a2, $a3, $zero	#save input string address 
	jal subprogram_2
	lw $a3, 8($sp)
	jal subprogram_3
	lw $t3, 12($sp)
	bne $t3, $zero, exit
	j loop
exit:			
	li $v0, 10	#load syscall code for program exit
	syscall		#exit program



subprogram_1:
#****************************************************
	add $t0, $a1, $zero
check_value1:
	slti $t1, $t0, 103	#check if byte from input is less than 103 (highest hex digit is 'f', decimal value 102)
	bne $t1, $zero, af_range	#if byte is less than 103 proceed to a-f range of values
	addi $v0, $zero, 19
	jr $ra			#byte is invalid (code 19)
af_range:
	slti $t1, $t0, 97	#check if byte from input is less than 97, decimal value of 'a'
	bne $t1, $zero, check_value2	#if byte is less than 97, proceed to check for invalid byte values between A-F and a-f
	addi $t6, $zero, 87
	sub $t2, $t0, $t6	#if byte is between 97 and 102, obtain the true value of the hex number between 'a' and 'f'
	add $v0, $t2, $zero
	jr $ra			#return decimal value of hex number
check_value2:
	slti $t1, $t0, 71	#check if byte from input is less than 71. the range of characters 'A' through 'F' is 65-70
	bne $t1, $zero, AF_range	#if byte is less than 71 proceed to A-F range of values
	addi $v0, $zero, 19
	jr $ra			#byte is invalid (code 19)
AF_range:
	slti $t1, $t0, 65	#check if byte from input is less than 65, decimal value of 'A'
	bne $t1, $zero, check_value3	#if byte is less than 65, proceed to check for invalid byte values between 0-9 and A-F
	addi $t6, $zero, 55
	sub $t2, $t0, $t6	#if byte is between 65 and 70, obtain the true value of the hex number between 'A' and 'F'
	add $v0, $t2, $zero
	jr $ra			#return decimal value of hex number
check_value3:
	slti $t1, $t0, 58	#check if byte from input is less than 58. the range of characters '0' through '9' is 48-57
	bne $t1, $zero, digit_range	#if byte is less than 58 proceed to 0-9 range of values
	addi $v0, $zero, 19
	jr $ra			#byte is invalid (code 19)
digit_range:
	slti $t1, $t0, 48	#check if byte from input is less than 48, decimal value of '0'
	bne $t1, $zero, low_range	#if less than 48, proceed to lower range of deicmal values
	addi $t6, $zero, 48
	sub $t2, $t0, $t6	#find hexadecimal value of current byte from input
	add $v0, $t2, $zero
	jr $ra			#return decimal value of hex number
low_range:
	addi $t6, $zero, 44
	sub $t3, $t0, $t6		#check to see if the decimal value of the byte 32, the value of space key, via subtraction
	beq $t3, $zero, comma		#if the above difference is zero, then handle the byte as a comma
	addi $t6, $zero, 32
	sub $t3, $t0, $t6		#check to see if the decimal value of the byte 32, the value of space key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	addi $t6, $zero, 9
	sub $t3, $t0, $t6		#check to see if the decimal value of the byte 9, the value of tab key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	addi $t6, $zero, 10
	sub $t3, $t0, $t6		#check to see if the decimal value of the byte 10, the value of enter key, via subtraction
	beq $t3, $zero, newline_char	#if the above difference is zero, then handle the byte as a newline character
	beq $t0, $zero, null_byte	#Finally, if $t0, the byte read in, is zero it is a null, end of string character
	addi $v0, $zero, 19
	jr $ra			#byte is invalid (code 19)
comma:	
	addi $v0, $zero, 20
	jr $ra 			#byte is comma (code 20)
white_space:
	addi $v0, $zero, 16
	jr $ra 			#byte is whitespace (code 16)
newline_char:
	addi $v0, $zero, 17
	jr $ra 			#byte is newline (code 17)
null_byte:
	addi $v0, $zero, 18
	jr $ra 			#byte is null (code 18)
#***************************************************************************

			
subprogram_3:
#*************************************************
	lw $t0, 0($sp)		#load word containing integer value be displayed
	lw $t1, 4($sp)		#load word containing type of value integer is 
	lw $t3, 12($sp)		#load word containing flag program termination
	beq $t1, $zero, print_int
	beq $t0, $zero, print_large
print_error:
	li $v0, 4		#load syscall code for string display	
	la $a0, error		#load in previously defined string address	
	syscall			#call to display error message
	j comma_check
print_int:
	li $v0, 1	#syscall code for outputting 
	divu $t0, $s4	#divide the sum by 10 to ensure that a 2's complement (negative) number is not output 
	mflo $t4	#store the quotient
	mfhi $t5	#store the remainder
	beq $t4, $zero, alt_print_int	#if the quotient is zero proceed to only display the remainder
	add $a0, $t4, $zero		#otherwise display the quotient
	syscall				#call for integer output
	add $a0, $t5, $zero		#then display the remainder
	syscall				#call fo integer output
	jr $ra				#return to main program
alt_print_int:	#If the original sum is less than 10 display only the reaminder
	li $v0, 1	#syscall code for outputting 
	add $a0, $t5, $zero	#load the remainder into arguements register	
	syscall			#call to display final integer
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 10	#load ascii value of newline into arguement register
	syscall		#call to display newline
print_large: # section to print error message
	li $v0, 4		#load syscall code for string display	
	la $a0, large		#load in previously defined string address	
	syscall			#call to display error message
	j comma_check
comma_check:
	beq $t3, $zero, print_comma
	jr $ra
print_comma:
	li $v0, 11	#load syscall code for ascii character output
	li $a0, 44	#load ascii value of comma into arguement register
	syscall		#call to display comma
	jr $ra