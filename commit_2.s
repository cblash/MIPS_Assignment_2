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
	subi $t2, $t0, 87	#if byte is between 97 and 102, obtain the true value of the hex number between 'a' and 'f'
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
	subi $t2, $t0, 55	#if byte is between 65 and 70, obtain the true value of the hex number between 'A' and 'F'
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
	subi $t2, $t0, 48	#find hexadecimal value of current byte from input
	add $v0, $t2, $zero
	jr $ra			#return decimal value of hex number
low_range:
	subi $t3, $t0, 32		#check to see if the decimal value of the byte 32, the value of space key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	subi $t3, $t0, 9		#check to see if the decimal value of the byte 9, the value of tab key, via subtraction
	beq $t3, $zero, white_space	#if the above difference is zero, then handle the byte as white space
	subi $t3, $t0, 10		#check to see if the decimal value of the byte 10, the value of enter key, via subtraction
	beq $t3, $zero, newline_char	#if the above difference is zero, then handle the byte as a newline character
	beq $t0, $zero, null_byte	#Finally, if $t0, the byte read in, is zero it is a null, end of string character
	addi $v0, $zero, 19
	jr $ra			#byte is invalid (code 19)
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