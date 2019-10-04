.data

PHello:   .asciiz "This is the first part of Homework 2. (Load, Store, Add, Sub)"
Pnewline: .asciiz "\n"
PA:       .asciiz "A = "
PB:       .asciiz "B = "
PApB:     .asciiz "B - A = "
PBmA:     .asciiz "A + A = "

.text

# Hello! This is the first part of Homework 2 -- Basic MIPS Assembly Language Assignment.
# In this part, you have to fill the code in the region bounded by 2 hashtag lines.
# Hopefully you can enjoy assembly programming.
# =====================================================
# For grading, DO NOT modify the code here
# Print Hello Msg.
la $a0, PHello	   # load address of string to print
li $v0, 4	   # ready to print string
syscall	           # print
jal PrintNewline
# Load and save data (A and B)
li $t0, 520         # load A
sw $t0, 8($gp)     # save A
li $t1, 1314        # load B
sw $t1, 4($gp)     # save B
# =====================================================

# The following block helps you practice with the R-type instructions,
# including ADD and SUB, and also LOAD and STORE.
# Here, please read data from 8($gp) and 4($gp),
# store 4($gp)-8($gp) to 0($gp), and
# store 8($gp)+8($gp) to 12($gp)
#####################################################
# @@@ write the code here
sub $t2, $t1, $t0 # $t2 = B - A
sw  $t2, 0($gp)   # 0($gp) = B - A
sll $t2, $t0, 1   # $t2 = A * 2
sw  $t2, 12($gp)  # $t2 = 12($gp)
#####################################################

# =====================================================
# For grading, DO NOT modify the code below
lw $t0, 8($gp)
lw $t1, 4($gp)
lw $t3, 0($gp)
lw $t4, 12($gp)
# Print A
la $a0, PA	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t0    # load int value to $a0
syscall	         # print
jal PrintNewline
# Print B
la $a0, PB	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t1    # load int value to $a0
syscall	         # print
jal PrintNewline
# Print A + B
la $a0, PApB	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t3    # load int value to $a0
syscall	         # print
jal PrintNewline
# Print B - A
la $a0, PBmA	 # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
li $v0, 1        # ready to print int
move $a0, $t4    # load int value to $a0
syscall	         # print
j Exit           # jump to exit

PrintNewline:
la $a0, Pnewline # load address of string to print
li $v0, 4	 # ready to print string
syscall	         # print
jr $ra           # return

Exit:
# =====================================================
li $v0, 10
syscall
