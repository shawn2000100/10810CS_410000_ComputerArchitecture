.data
str1:		.asciiz  "input a: "
str2:		.asciiz  "input b: " 
str3:		.asciiz  "ans: "
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
	
	# Prompt the user to enter int to  ' a '
	la $a0, str1        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	add $t0, $t0, $v0 
	
	# Prompt the user to enter int to  ' b '
	la $a0, str2        # load address of string to print
	li $v0, 4	   # ready to print string
	syscall	           # print
	# Get the int and store in $t0
	li $v0, 5	   # read
	syscall	           # read integer at $v0 
  	add $t1, $t1, $v0 
  	
  	# -------------------- fun1 -------------------------------- # c = re ( a ) ;
  	add $a0, $zero, $t0
  	jal, RE
  	add $t2, $zero, $v0
	
	# -----------------------------------------------------------
	
	
	# -------------------- fun2 -------------------------------- # d = fn(b, c);
	move $a0, $t1
	move $a1, $t2
	# ---------------------------------------
	jal, FN
	add $t3, $zero, $v0
	# -----------------------------------------------------------
	 
	 	 	 
	# printf("ans: %d", c);
	la $a0, str3      
	li $v0, 4	  
	syscall
	add $a0, $zero, $t2  # $a0 =  c 
  	li $v0, 1	    
	syscall	
	# printf("ans: %d", d);
	la $a0, str3      
	li $v0, 4	  
	syscall
	add $a0, $zero, $t3  # $a0 =  d
  	li $v0, 1	    
	syscall	           
	jal  PrintNewline    
	
	j RETURN            


RE:
	# ra, a0, s0 x*x , s1 x*re(x-1) , s2 (x-1)*re(x-2)  5 in total
        addi $sp, $sp, -20
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $s0, 8($sp)
        sw $s1, 12($sp)
        sw $s2, 16($sp)
         
       # if x >= 2:
       addi $t0, $zero, 2 # tmp 2
       bge $a0, $t0, if
       addi $t0, $zero, 1 # tmp 1
       bne $a0, $t0, zero
       addi $v0, $zero, 1 # return 1
       j, end_re
zero:   addi $v0, $zero, 0 # return 0
       j, end_re

if:     mul $s0, $a0, $a0  # s0 =  x*x
      addi $a0, $a0, -1   # x = x-1
      jal, RE
      lw $a0, 4($sp)     # restore the $a0 (x)
      mul $s1, $a0, $v0  #  s1 = x *  re(x - 1)
      
      addi $a0, $a0, -2   # x = x-2
      jal, RE
      lw $a0, 4($sp)     # restore the $a0 (x)
      addi $a0, $a0, -1  # x = x-1
      mul $s2, $a0, $v0  #  s2 = (x - 1) *  re(x - 2)
      
      add $v0, $zero, $s0 # v0 = s0 (x*x)
      add $v0, $v0, $s1 # v0 += s1 (  x *  re(x - 1) )
      add $v0, $v0, $s2 # v0 += s2 ( (x - 1) *  re(x - 2) )
	
end_re:  lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $s0, 8($sp)
        lw $s1, 12($sp)
        lw $s2, 16($sp)
        addi $sp, $sp, 20
        jr $ra
        

FN:
        addi $sp, $sp, -24
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        sw $s0, 12($sp)
        sw $s1, 16($sp)
        sw $s2, 20($sp)
        
       bgt $a0, $zero, cond1  # if x > 0 then
       addi $v0, $zero, 0     # return 0
       j, end_fn
cond1:  bgt $a1, $zero, cond2  # if y > 0 then
       addi $v0, $zero, 0     # return 0
       j, end_fn
cond2:  ble $a0, $a1, cond3    # if x <= y then
       addi $v0, $zero, 2     # return 2
       j, end_fn
cond3: addi $a0, $a0, -1   # x = x-1
      jal, FN
      addi $t0, $zero, 3 # tmp = 3
      mul $s0, $t0, $v0  #  s0 = 3 * fn(x - 1, y)
      lw $a0, 4($sp)     # restore the $a0 (x)
      
      addi $a1, $a1, -1   # y = y - 1
      jal, FN
      addi $t0, $zero, 2 # tmp = 2
      mul $s1, $t0, $v0  #  s1 = 2 * fn(x, y - 1)
      lw $a1, 8($sp)     # restore the $a1(y)
      
      addi $a0, $a0, -1   # x = x - 1
      addi $a1, $a1, -1   # y = y - 1
      jal, FN
      add $s2, $zero, $v0
      
      # ready to return s0 + s1 + s2
      add $v0, $zero, $s0 
      add $v0, $v0, $s1 
      add $v0, $v0, $s2
      
end_fn:  lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $s0, 12($sp)
        lw $s1, 16($sp)
        lw $s2, 20($sp)
        addi $sp, $sp, 24
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
	
