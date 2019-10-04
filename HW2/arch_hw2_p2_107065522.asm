.data
str1:		.asciiz "Please select an integer number A from (0~10): "
str2:		.asciiz "A * 2 = "
str3:		.asciiz "******"
str4:		.asciiz "THE END"
Pnewline: 	.asciiz "\n"
.text

_Start:
	# Prompt the user to enter int
	la $a0, str1        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	           
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	
  	add $t0, $zero, $v0 # $t0 = scanf("%d", &v0)
  	
  	# For Debug ----------------------------------------------
  	#add $a0, $zero, $t0  # $a0 = input 
  	#li $v0, 1	    # print integer
	#syscall	            # print integer at $a0	
	#jal  PrintNewline    # For printing new line
	# ----------------------------------------------------------
  	
  	#if input = 0, goto _Exit
  	beq $t0, $zero, _Exit
  	
  	# If $t0 < 0 || $t0 > 10, goto _Start
  	# t0 < 0
  	slt  $t1, $t0, $zero
  	#  t0 > 10  (10 < t0)
  	addi $t2, $zero, 10
  	slt  $t3, $t2, $t0
  	or  $t1, $t1, $t3 # $t0 < 0 || $t0 > 10
  	# Debug ------------
  	#add $a0, $zero, $t1
  	#li $v0, 1	   # ready to print string
	#syscall	           # print
  	# --------------------
  	addi $t2, $zero, 1
  	beq  $t1, $t2, _Start
  	
  	#If $t0  == 7, compute input * 2.
	addi $t1, $zero, 7
	bne  $t0, $t1, _function_others
	sll  $t1, $t0, 1
	
	#  print out the answer 14
	la $a0, str2         # print "A * 2 = "
	li $v0, 4	   # ready to print string
	syscall	            # print string at $a0	
  	add $a0, $zero, $t1  # $a0 = input 
	li $v0, 1	    # print integer
	syscall	            # print integer at $a0	
	jal  PrintNewline    # For printing new line         
	
  	#After print out, go back to wait the user to enter number.
  	j _Start
  	
_function_others:
	#setup counter i
	addi $t1, $zero, 0 # i = 0
	
	#Write a Loop for print ******
	Loop:
	#Check the input and the counter
	slt $t8, $t1, $t0 # $t8 = $t1 < $t0
	#End the loop and wait the user to enter number.
	beq $t8, $zero, _Start

	# print out ******  (if t1 < t0)
	la $a0, str3      # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	
	#print out the counter number
	add $a0, $zero, $t1     # load address of string to print
	li $v0, 1	 # ready to print string
	syscall	         # print
	                          
	# print out ******
	la $a0, str3      # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	             
	# print out \n (´«¦æ)
	jal  PrintNewline    # For printing new line         
		
	#counter ++
	addi $t1, $t1, 1
	#go back to the Loop
	j Loop                


PrintNewline:
la $a0, Pnewline # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return


#Stop the program
_Exit:
        la $a0, str4      # load address of string to print
	li $v0, 4	  # ready to print string
	syscall	          # print
	li $v0, 10
	syscall
	
