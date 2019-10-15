.data
str1:		.asciiz  "input a: "
str2:		.asciiz  "input b: " 
str3:		.asciiz  "input c: " 
str4:		.asciiz  "result = "
Pnewline: 	.asciiz  "\n"

dbg1:            .asciiz  "large = "
dbg2: 	        .asciiz  "\nsmall = "
dbg3: 	        .asciiz  "\nans = "

.text
.globl  MAIN
MAIN:
	# int a, b, c, d = 0, 0, 0, 0;
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	
	# Prompt the user to enter int to a
	la $a0, str1        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	# $t0 = scanf("%d", &v0)
  	add $t0, $t0, $v0 
	
	# Prompt the user to enter int to b
	la $a0, str2        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	# $t1 = scanf("%d", &v0)
  	add $t1, $t1, $v0 
  	
  	# Prompt the user to enter int to c
	la $a0, str3        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	# $t2 = scanf("%d", &v0)
  	add $t2, $t2, $v0 
	
	# madd(a, c)
	add $a0, $zero, $t0
	add $a1, $zero, $t2
	jal madd # after this, v0 = madd(a, c)
	
	add $a0, $zero, $t1
	add $a1, $zero, $v0
	jal, abs_sub
	
	add $t3, $zero, $v0 # d = abs_sub ( b, madd(a, c) );
	# print( "result = %d", d )
	la $a0, str4       
	li $v0, 4	  
	syscall
	# print( %d )
	add $a0, $zero, $t3  # $a0 =  ans 
  	li $v0, 1	    # print integer
	syscall	            # print integer at $a0	
	jal  PrintNewline    # For printing new line
	j RETURN            # RETURN 0
	
	
madd:
        # 3 local vars + 1 tmp in total
        addi $sp, $sp, -16
        sw $s0, 0($sp)
        sw $s1, 4($sp)
        sw $s2, 8($sp)
        sw $t0, 12($sp)
        
        # int ans = 0;
        addi $s0, $zero, 0
        
        # int large  =  (x >= y) ? x : y; 
        slt $t0, $a0, $a1        # t0 = x < y
        bne $t0, $zero, y_val    # if x < y then y_val
        add $s1, $zero, $a0      # large = x
        j, exit1
y_val:   add $s1, $zero, $a1      # large = y

        # int small  =  (x <= y) ? x : y;
exit1:   slt $t0, $a1, $a0        # t0 = x > y
        bne $t0, $zero, y_val2   # if x > y then y_val2
        add $s2, $zero, $a0     # small = x
        j, exit2
y_val2:  add $s2, $zero, $a1     # small = y

	# for debug large, small ---------------------------------------
exit2:	#la $a0, dbg1        # load address of string to print
	#li $v0, 4	   # ready to print string
	#syscall	           # print
	#add $a0, $zero, $s1  # $a0 =  ans 
  	#li $v0, 1	    # print integer
	#syscall	            # print integer at $a0	
	
	#la $a0, dbg2       # load address of string to print
	#li $v0, 4	   # ready to print string
	#syscall	           # print
	#add $a0, $zero, $s2  # $a0 =  ans 
  	#li $v0, 1	    # print integer
	#syscall	            # print integer at $a0	
	# -----------------------------------------------------------------------

	#while (large >= small) { 
	#    ans = ans + small; 
	#    large = large - 1; 
	#  } 
loop:   slt $t0, $s1, $s2    # t0 = large < small
       bne $t0, $zero, end  # (large < small)
       add $s0, $s0, $s2
       addi $s1, $s1, -1
       j, loop
       
       
       # ------------------DEBUG ans: -------------------------------------------------------
       	#la $a0, dbg3       # load address of string to print
	#li $v0, 4	   # ready to print string
	#syscall	           # print
	#add $a0, $zero, $s0  # $a0 =  ans 
  	#li $v0, 1	    # print integer
	#syscall	            # print integer at $a0	
      # ----------------------------------------------------------------------------------------------- 
       
end:    add $v0, $zero, $s0 # return ans 
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $t0, 12($sp)
        addi $sp, $sp, 16
        jr $ra
        

abs_sub:
        addi $sp, $sp, -12
        sw $s1, 0($sp)
        sw $s2, 4($sp)
        sw $t0, 8($sp)
       
        # int large  =  (x >= y) ? x : y; 
        slt $t0, $a0, $a1        # t0 = x < y
        bne $t0, $zero, y_val3    # if x < y then y_val
        add $s1, $zero, $a0      # large = x
        j, exit3
y_val3:  add $s1, $zero, $a1      # large = y

        # int small  =  (x <= y) ? x : y;
exit3:   slt $t0, $a1, $a0        # t0 = x > y
        bne $t0, $zero, y_val4  # if x > y then y_val2
        add $s2, $zero, $a0     # small = x
        j, exit4
y_val4:  add $s2, $zero, $a1     # small = y

exit4:   sub $t0, $s1, $s2    # t0 = large - small
        add $v0, $zero, $t0  # return t0
        lw $s1, 0($sp)
        lw $s2, 4($sp)
        lw $t0, 8($sp)
        addi $sp, $sp, 12
        jr $ra
	

PrintNewline:
la $a0, Pnewline  # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return


#Stop the program
RETURN:
	li $v0, 10
	syscall
	
