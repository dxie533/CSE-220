# hw4_main1.asm
# This file is NOT part of your homework 4 submission.
# Any changes to this file WILL NOT BE GRADED.
#
# We encourage you to modify this file  and/or make your own mains to test different inputs

#.include "hw4_examples.asm"

# Constants
.data
newline:  .asciiz "\n"
comma:    .asciiz ", "
testchar: .byte '9'
success: .asciiz "Success: "
bytes: .asciiz "Bytes: "
packetNumber_1: .asciiz "packet number "
packetNumber_2: .asciiz " has invalid checksum"

.text
.globl _start


####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:

##################
	# clear_Board
	##################
	#li $a0, 0xffff0000
	#li $a1, 3
	#li $a2, 2
	#jal clear_board
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# place
	##################
	#li $a0, 0xffff0000
	#li $a1, 3
	#li $a2, 2
	#li $a3, 2
	#li $t0, 1
	#addi $sp, $sp, -8
	#sw $t0, 0($sp)
	#li $t0, 2
	#sw $t0, 4($sp)
	#jal place
	#addi $sp, $sp, 8
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# start_game
	##################
	li $a0, 0xffff0000
	li $a1, 5
	li $a2, 2
	li $a3, 0
	li $t0, 0
	li $t1, 1
	li $t2, 1
	
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	jal start_game
	addi $sp, $sp, 12
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# place
	##################
	li $a3, 0
	li $t0, 1
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 4
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 1
	li $t0, 0
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 4
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 2
	li $t0, 0
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 2
	li $t0, 1
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 3
	li $t0, 0
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 3
	li $t0, 1
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 4
	li $t0, 0
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	li $a3, 4
	li $t0, 1
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	li $t0, 8
	sw $t0, 4($sp)
	jal place
	addi $sp, $sp, 8
	
	# merge_row
	##################
	#li $a3, 2
	#li $t0, 0
	#addi $sp, $sp -4
	#sw $t0, 0($sp)
	#jal merge_row
	#addi $sp, $sp, 4
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# merge_col
	##################
	#li $a3, 1
	#li $t0, 0
	#addi $sp, $sp -4
	#sw $t0, 0($sp)
	#jal merge_col
	#addi $sp, $sp, 4
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# shift_row
	##################
	#li $a3, 0
	#li $t0, 1
	#addi $sp, $sp, -4
	#sw $t0, 0($sp)
	#jal shift_row
	#addi $sp, $sp, 4
	
	# shift_col
	##################
	#li $a3, 1
	#li $t0, 1
	#addi $sp, $sp, -4
	#sw $t0, 0($sp)
	#jal shift_col
	#addi $sp, $sp, 4
	
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# check_state
	##################
	#jal check_state
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	# user_move
	##################
	#li $a3, 'R'
	#jal user_move
	
	#li $a3, 'L'
	#jal user_move
	
	li $a3, 'U'
	jal user_move
	
	
	li $a3, 'D'
	jal user_move
	
	li $a3, 'U'
	jal user_move
	
	li $a3, 'L'
	jal user_move
	
	li $a3, 'R'
	jal user_move
	
	li $a3, 'D'
	jal user_move
	
	li $a3, 'L'
	jal user_move
	
	li $a3, 'D'
	jal user_move
	
	li $a3, 'D'
	jal user_move
	
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
	
	#Exit the program
	li $v0, 10
	syscall

###################################################################
# End of MAIN program
####################################################################


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"
