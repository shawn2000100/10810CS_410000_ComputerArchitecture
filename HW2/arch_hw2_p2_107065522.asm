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
  	li $v0, 1	    # print integer
  	add $a0, $zero, $t0  # $a0 = input 
	syscall	            # print integer at $a0	
	jal  PrintNewline    # For printing new line
	# ----------------------------------------------------------
  	
  	#if input = 0, goto _Exit
  	beq $t0, $zero, _Exit
  	
  	# If $t0 < 0 || $t0 > 10, goto _OutofRange
  	
  	
  	
  	
  	
  	
  	
  	#If input =7, compute input * 2, and print out the answer.
	
	
	            
	
	
  	
  	
  	 
		
		
	
  	#After print out, go back to wait the user to enter number.
  	j _Start
  	
_function_others:
	#setup counter i
	
	 
	#Write a Loop for print ******
	Loop:
	
	#Chech the input and the counter
	
	
	#End the loop and wait the user to enter number.
	

	# print out ******
	
	
	 
	
	#print out the counter number
	             
	 
	
	
	# print out ******
	             
	
	 
	
	# print out \n (´«¦æ)
	
		
		
	
	#counter ++
	
	
	#go back to the Loop
	j Loop                


PrintNewline:
la $a0, Pnewline  # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return


#Stop the program
_Exit:
	li $v0, 10
	syscall
	
