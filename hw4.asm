
##############################################################
# Homework #4
# name: David Xie
# sbuid: 111098813
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

clear_board:
    #Define your code here
	############################################
	clear_Board_CheckError:
	li $t0, 2
	blt $a1, $t0, clear_Board_Error
	blt $a2, $t0, clear_Board_Error
	clear_Board_NoError:
	li $t1, 0 # $t1 = value of row
	li $t2, 0 # $t2 = value of column
	li $t3, 2
	mult $a2, $t3 # col * 2 = row_size
	mflo $t3 # $t3 = row_size
	li $t6, -1
	clear_Board_Loop:
	beq $t1, $a1, boardCleared # branch if row counter = num_rows
	move $t0, $a0 # $t0 = starting address
	mult $t3, $t1 # multiply row_size by value of row
	mflo $t4 # $t4 = row_size * i
	sll $t5, $t2, 1 # $t5 = j * 2
	add $t0, $t0, $t4 # $t0 = starting address + row_size * i
	add $t0, $t0, $t5 # $t0 = starting address + (row_size * i) + (j * 2)
	sh $t6, 0($t0) # set $t0 to -1
	addi $t2, $t2, 1 # value of col + 1
	beq $t2, $a2, clearBoard_IncrementRow # if value of col = col, add 1 to row and set col to 0
	j clear_Board_Loop
	clearBoard_IncrementRow:
	addi $t1, $t1, 1 # value of row + 1
	li $t2, 0 # value of col = 0
	j clear_Board_Loop
	
	clear_Board_Error:
	li $v0, -1
	b clear_Board_Complete
	
	boardCleared:
	li $v0, 0
	
	clear_Board_Complete:
	############################################
	jr $ra

get_cell: # helper function
#Define your code here
	############################################
	#$a0 = base address
	#$a1 = number of columns
	#$a2 = row value
	#$a3 = col value
	mult $a1, $a2
	mflo $t0 # $t0 = number of columns * row value
	add $t0, $t0, $a3 # $t0 = (number of columns * row value) + value of column
	sll $t0, $t0, 1 # $t0 = ((number of columns * row value) + value of column)(element size)
	add $v0, $a0, $t0 # $v0 = the location in the array
	############################################
    jr $ra
	
place:
    #Define your code here
	############################################
	lw $t0, 0($sp) # $t0 = col
	lw $t1, 4($sp) # $t1 = value
	check_place_valid:
	li $t2, 2 # $t2 = 2
	blt $a1, $t2, place_error # n_rows < 2
	blt $a2, $t2, place_error # n_cols < 2
	li $t2, 1 # $t2 = 1
	blt $a3, $0, place_error # row < 0
	addi $t3, $a1, -1 # $t3 = n_rows - 1
	bgt $a3, $t3, place_error # row > n_rows - 1
	blt $t0, $0, place_error # col < 0
	addi $t3, $a2, -1 # $t3 = n_cols - 1
	bgt $t0, $t3, place_error # col > n_col - 1
	li $t2, 1
	beq $t1, $t2, place_error # value cannot be 1
	beq $t1, $0, place_error # value cannot be 0
	li $t2, -1
	beq $t1, $t2, check_valid_complete # value can be -1
	check_power_of_two:
	li $t2, 0 # $t2 = counter
	li $t3, 1 # $t3 = position
	li $t4, 0 # $t4 = position of bit ( must be < 32)
	li $t6, 1 # if counter > 1, it has more than 1 bit so it is not a power of 2
	li $t7, 17 # i must be < 16
	
	check_power_loop:
	and $t5, $t1, $t3 # $t5 = anded version of the value and position
	beqz $t5, bit_is_zero
	addi $t2, $t2, 1 # increment counter by 1
	bgt $t2, $t6, place_error
	
	bit_is_zero:
	sll $t3, $t3, 1 # position = position *2
	addi $t4, $t4, 1 # increment i
	bge $t4, $t7, check_power_done
	j check_power_loop
	
	check_power_done:
	
	check_valid_complete:
	addi $sp, $sp, -12
	sw $a1, 0($sp)
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	move $a1, $a2 # $a1 = n_cols
	move $a2, $a3 # $a2 = value of row
	move $a3, $t0 # $a3 = value of col
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t1, 4($sp) # store value
	jal get_cell
	lw $ra, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	lw $a1, 0($sp)
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	addi $sp, $sp, 12
	
	sh $t1, 0($v0) # set the cell to value
	li $v0, 0
	b place_Complete
	
	place_error:
	li $v0, -1
	place_Complete:
	############################################
    jr $ra

start_game:
    #Define your code here
	############################################
	lw $t0, 0($sp) # $t0 = c1
	lw $t1, 4($sp) # $t1 = r2
	lw $t2, 8($sp) # $t2 = c2
	check_start_game_valid:
	li $t3, 2
	blt $a1, $t3, start_game_error # num_rows < 2
	blt $a2, $t3, start_game_error # num_cols < 2
	blt $a3, $0, start_game_error # r1 < 0
	blt $t0, $0, start_game_error # c1 < 0 
	blt $t1, $0, start_game_error # r2 < 0
	blt $t2, $0, start_game_error # c2 < 0
	addi $t3, $a1, -1 # $t3 = num_rows - 1
	bgt $a3, $t3, start_game_error # r1 > num_rows - 1
	bgt $t1, $t3, start_game_error # r2 > num_rows - 1
	addi $t3, $a2, -1 # $t3 = num_cols - 1
	bgt $t0, $t3, start_game_error # c1 > num_cols - 1
	bgt $t2, $t3, start_game_error # c2 > num_cols - 1
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal clear_board
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	bne $v0, $0, start_game_error
	
	lw $t0, 0($sp) # $t0 = c1
	li $t3, 2 # $t3 = 2
	addi $sp, $sp, -12
	sw $t0, 0($sp) # 0($sp) = col value
	sw $t3, 4($sp) # 4($sp) = value
	sw $ra, 8($sp) # 8($sp) = $ra
	jal place
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	bne $v0, $0, start_game_error
	
	lw $t1, 4($sp) # $t1 = r2
	lw $t2, 8($sp) # $t2 = c2
	li $t3, 2 # $t3 = 2
	move $a3, $t1 # row value = r2
	addi $sp, $sp, -12
	sw $t2, 0($sp) # 0($sp) = col value
	sw $t3, 4($sp) # 4($sp) = value
	sw $ra, 8($sp) # 8($sp) = $ra
	jal place
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	bne $v0, $0, start_game_error
	
	li $v0, 0
	b start_Complete
	
	start_game_error:
	li $v0, -1
	start_Complete:
	############################################
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
    #Define your code here
    ############################################
    lw $t0, 0($sp) # load direction into $t0 to move into $s0 later
    
    addi $sp, $sp, -20
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $ra, 16($sp)
    
    move $s0, $t0 # move $t0 into $s0, $s0 = direction
    li $s1, 0 # $s1 = counter for what column its on
    addi $s2, $a2, -2 # $s2 = where to end (num_cols - 1)
    li $s3, 0 # $s3 = number of non-empty cells after merging
    
    check_merge_row_valid:
    bge $a3, $a1, merge_error # check if row >= num_rows (num_rows - 1 >= row >= 0)
    blt $a3, $0, merge_error # check if row < 0
    li $t0, 2
    blt $a1, $t0, merge_error # num_rows < 2
    blt $a2, $t0, merge_error # num_cols < 2
    
    li $t0, 1
    beq $s0, $0, merge_row_start # direction = 0
    beq $s0, $t0, merge_row_start # direction = 1
    b merge_error
    
    merge_row_start:
    beq $s0, $0, col_is_zero # starting col = 0
    addi $s1, $a2, -2 # starting col = num_cols - 2
    b after_col
    col_is_zero:
    li $s1, 0 # $s1 = counter for what column its on   
    after_col:
    addi $sp, $sp, -12
    sw $a1, 0($sp)
    sw $a2, 4($sp)
    sw $a3, 8($sp)
    move $a1, $a2 # $a1 = num_cols
    move $a2, $a3 # $a2 = row
    
    beq $s0, $t0, merge_row_loop_right # direction = 1
    
    merge_row_loop:
    bgt $s1, $s2, merge_loop_done
    move $a3, $s1 # $a3 = current col
    jal get_cell
    move $t0, $v0 # $t0 = cell address
    lh $t1, 0($t0) # $t1 = value of left cell
    li $t3, -1
    beq $t1, $t3, merge_executed
    addi $t0, $t0, 2 # increment the targeted cell address to get the right side
    lh $t2, 0($t0) # $t2 = value of right cell
    beq $t1, $t2, merge_left
    b merge_executed
    
    merge_row_loop_right:
    blt $s2, $0, merge_loop_done
    move $a3, $s2 # $a3 = current col
    jal get_cell
    move $t0, $v0 # $t0 = cell address
    lh $t1, 0($t0) # $t1 = value of left cell
    li $t3, -1
    beq $t1, $t3, merge_executed_right
    addi $t0, $t0, 2 # increment the targeted cell address to get the right side
    lh $t2, 0($t0) # $t2 = value of right cell
    beq $t1, $t2, merge_right
    b merge_executed_right
    
    merge_left:
    addi $t0, $t0, -2 # $t0 = address of left cell
    sll $t1, $t1, 1 # $t1 = value of left cell * 2
    sh $t1, 0($t0) # set the left cell to the new value
    addi $t0, $t0, 2 # $t0 = address of right cell
    li $t2, -1
    sh $t2, 0($t0) # right cell = empty
    addi $s3, $s3, 1 # increment number of merged cells
    b merge_executed
    
    merge_right:
    sll $t2, $t2, 1 # $t2 = value of right cell * 2
    sh $t2, 0($t0) # set the right cell to the new value
    addi $t0, $t0, -2 # $t0 = address of left cell
    li $t1, -1
    sh $t1, 0($t0) # left cell = empty
    addi $s3, $s3, 1 # increment number of merged cells
    b merge_executed_right
    
    merge_executed:
    addi $s1, $s1, 1 # increment column counter by 1
    j merge_row_loop
    
    merge_executed_right:
    addi $s2, $s2, -1 # decrement column counter by 1
    j merge_row_loop_right
    
    merge_loop_done:
    lw $a1, 0($sp)
    lw $a2, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    move $v0, $s3 # $v0 =  number of merged cells
    b merge_row_Complete
    
    merge_error:
    li $v0, -1
    
    merge_row_Complete:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $ra, 16($sp)
    addi $sp, $sp, 20
    
    ############################################
    jr $ra

merge_col:
    #Define your code here
    ############################################
    lw $t0, 0($sp) # load direction into $t0 to move into $s0 later
    
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $ra, 20($sp)
    
    move $s0, $t0 # move $t0 into $s0, $s0 = direction
    li $s1, 0 # $s1 = counter for what col its on
    addi $s2, $a2, -2 # $s2 = where to end (num_cols - 1)
    li $s3, 0 # $s3 = number of non-empty cells after merging
    sll $s4, $a2, 1 # $s4 = num_cols * 2 (the difference between each row)
    
    check_merge_col_valid:
    bge $a3, $a2, merge_error_2 # check if col >= num_cols (num_cols - 1 >= cols >= 0)
    blt $a3, $0, merge_error_2 # check if row < 0
    li $t0, 2
    blt $a1, $t0, merge_error_2 # num_rows < 2
    blt $a2, $t0, merge_error_2 # num_cols < 2
    
    li $t0, 1
    beq $s0, $0, merge_col_start # direction = 0
    beq $s0, $t0, merge_col_start # direction = 1
    b merge_error_2
    
    merge_col_start:
    beq $s0, $0, row_is_not_zero # starting row 
    li $s1, 0 # $s1 = starting row = 0
    b after_row
    row_is_not_zero:
    addi $s1, $a1, -2 # starting row = num_row - 2
    after_row:   
    addi $sp, $sp, -12
    sw $a1, 0($sp)
    sw $a2, 4($sp)
    sw $a3, 8($sp)
    move $a1, $a2 # $a1 = num_cols
    
    beq $s0, $0, merge_col_loop_bottom # direction = 0
    
    merge_col_loop:
    bgt $s1, $s2, merge_loop_done_2
    move $a2, $s1 # $a2 = current row
    jal get_cell
    move $t0, $v0 # $t0 = cell address
    lh $t1, 0($t0) # $t1 = value of top cell
    li $t3, -1
    beq $t1, $t3, merge_executed_2
    add $t0, $t0, $s4 # increment the targeted cell address to get the bottom side
    lh $t2, 0($t0) # $t2 = value of bottom cell
    beq $t1, $t2, merge_top_bottom
    b merge_executed_2
    
    merge_col_loop_bottom:
    blt $s1, $0, merge_loop_done_2
    move $a2, $s1 # $a2 = current row
    jal get_cell
    move $t0, $v0 # $t0 = cell address
    lh $t1, 0($t0) # $t1 = value of top cell
    li $t3, -1
    beq $t1, $t3, merge_executed_2_bottom
    add $t0, $t0, $s4 # increment the targeted cell address to get the bottom side
    lh $t2, 0($t0) # $t2 = value of bottom cell
    beq $t1, $t2, merge_bottom_top
    b merge_executed_2_bottom
    
    merge_bottom_top:
    sll $t2, $t2, 1 # $t2 = value of bottom cell * 2
    sh $t2, 0($t0) # set the bottom cell to the new value
    sub $t0, $t0, $s4 # $t0 = address of left cell
    li $t1, -1
    sh $t1, 0($t0) # left cell = empty
    addi $s3, $s3, 1 # increment number of merged cells
    b merge_executed_2_bottom
    
    merge_top_bottom:
    sub $t0, $t0, $s4 # $t0 = address of top cell
    sll $t1, $t1, 1 # $t1 = value of top cell * 2
    sh $t1, 0($t0) # set the top cell to the new value
    add $t0, $t0, $s4 # $t0 = address of bottom cell
    li $t2, -1
    sh $t2, 0($t0) # bottom cell = empty
    addi $s3, $s3, 1 # increment number of merged cells
    b merge_executed_2
    
    merge_executed_2:
    addi $s1, $s1, 1 # increment col counter by 1
    j merge_col_loop
    
    merge_executed_2_bottom:
    addi $s1, $s1, -1 # decrement col counter by 1
    j merge_col_loop_bottom
    
    merge_loop_done_2:
    lw $a1, 0($sp)
    lw $a2, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    move $v0, $s3 # $v0 =  number of merged cells
    b merge_col_Complete
    
    merge_error_2:
    li $v0, -1
    
    merge_col_Complete:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    
    ############################################
    jr $ra

shift_row:
    #Define your code here
    ############################################
    lw $t0, 0($sp) # $t0 = direction
    
    shift_row_check:
    li $t1, 2
    blt $a1, $t1, shift_row_error # num_rows < 2
    blt $a2, $t1, shift_row_error # num_cols < 2
    bltz $a3, shift_row_error # row < 0
    bge $a3, $a1, shift_row_error # row >= num_row 
    beq $t0, $0, shift_row_start
    li $t1, 1
    beq $t0, $t1, shift_row_start
    b shift_row_error
    
    
    shift_row_start:
    beq $t0, 0, shift_left
    
    shift_right:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal shift_right_row
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    b shift_row_done
    
    shift_left:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal shift_left_row
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    b shift_row_done
    
    shift_row_error:
    li $v0, -1
    
    shift_row_done:
    ############################################
    jr $ra
    
shift_left_row:
    #Define your code here
    ############################################
    # $a0 = board address
    # $a1 = num_rows
    # $a2 = num_cols
    # $a3 = value of row
    
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    
    li $s0, 0  # $s0 = value of column
    addi $s1, $a2, -1 # $s1 = the column to stop after
    li $s4, -1 # $s4 = -1 for checking
    li $s5, 0 # $s5 = counter for the amount of cells shifted
    
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    
    move $a1, $a2 # $a1 = num_cols
    move $a2, $a3 # $a2 = row
    li $a3, 0 # $a3 = col = 0
    jal get_cell
    move $s2, $v0 # $s2 = address of leftmost cell
    addi $s3, $s2, 2 # $s3 = address of letmost cell + 1
    li $s0, 1 # $s0 = 1
    
    lw $ra, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    addi $sp, $sp, 16
    
    shift_left_row_loop:
    bgt $s0, $s1, shift_left_row_done # value of col > num_col - 1
    lh $t0, 0($s3) # $t0 = value of $s3
    bne $t0, $s4, check_left_for_blank
    addi $s3, $s3, 2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_left_row_loop
    
    check_left_for_blank:
    addi $t1, $s3, -2 # $t1 = the address of the cell to the left of the targetted cell
    lh $t1, 0($t1) # $t1 = the value of the cell to the left of the targetted cell
    beq $t1, $s4, shift_the_cell_left
    addi $s3, $s3, 2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_left_row_loop
    
    shift_the_cell_left:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    
    move $a0, $s2 # $a0 = address of leftmost cell
    move $a1, $s3 # $a1 = address of targetted cell
    li $a2, 2 # $a2 = 2 bytes
    jal shift_cell_left
    addi $s5, $s5, 1 # increment the amount of cells shifted by 1
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addi $sp, $sp, 16
    
    addi $s3, $s3, 2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_left_row_loop
    
    shift_left_row_done:
    move $v0, $s5 # $v0 = amount of cells shifted
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    addi $sp, $sp, 24
    ############################################
    jr $ra
    
shift_cell_left:
    #Define your code here
    ############################################
    # $a0 = address of left most cell
    # $a1 = address of cell
    # $a2 = distance between each cell (2 bytes)
    
    move $t0, $a1 # %t0 = counter for the address that is moving
    sub $t1, $a0, $a2 # $t1 = the address of the leftmost cell - 1 cell
    li $t3, -1 # $t3 = -1
    sub $t0, $t0, $a2 # $t0 = the previous cell
    
    shift_cell_left_loop:
    beq $t0, $t1, shift_cell_left_number_found # if the counter reaches the leftmost cell then we place it there
    lh $t2, 0($t0) # $t2 = the value of the cell
    bne $t2, $t3, shift_cell_left_number_found # $t0 contains a number
    sub $t0, $t0, $a2 # $t0 = the previous cell
    j shift_cell_left_loop
    
    shift_cell_left_number_found:
    add $t0, $t0, $a2 # get the address of the cell to the right of $t0
    lh $t4, 0($a1) # $t4 = value of the cell being moved
    sh $t3, 0($a1) # turn the cell blank
    sh $t4, 0($t0) # store the value of cell into $t0
    
    shift_cell_left_done:
    ############################################
    jr $ra

shift_right_row:
    #Define your code here
    ############################################
    # $a0 = board address
    # $a1 = num_rows
    # $a2 = num_cols
    # $a3 = value of row
    
    addi $sp, $sp, -24
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    
    addi $s0, $a2, -1  # $s0 = value of column
    addi $s1, $a2, -1 # $s1 = column to stopo after num_cols - 1
    li $s4, -1 # $s4 = -1 for checking
    li $s5, 0 # $s5 = counter for the amount of cells shifted
    
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    
    move $a1, $a2 # $a1 = num_cols
    move $a2, $a3 # $a2 = row
    addi $a3, $a1, -1 # $a3 = col = num_cols - 1
    jal get_cell
    move $s2, $v0 # $s2 = address of rightmost cell
    addi $s3, $s2, -2 # $s3 = address of rightmost cell - 1
    li $s0, 1 # $s0 = 1
    
    lw $ra, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    addi $sp, $sp, 16
    
    shift_right_row_loop:
    bgt $s0, $s1, shift_right_row_done # value of col > num_cols - 1
    lh $t0, 0($s3) # $t0 = value of $s3
    bne $t0, $s4, check_right_for_blank
    addi $s3, $s3, -2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_right_row_loop
    
    check_right_for_blank:
    addi $t1, $s3, 2 # $t1 = the address of the cell to the right of the targetted cell
    lh $t1, 0($t1) # $t1 = the value of the cell to the right of the targetted cell
    beq $t1, $s4, shift_the_cell_right
    addi $s3, $s3, -2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_right_row_loop
    
    shift_the_cell_right:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    
    move $a0, $s2 # $a0 = address of rightmost cell
    move $a1, $s3 # $a1 = address of targetted cell
    li $a2, 2 # $a2 = 2 bytes
    jal shift_cell_right
    addi $s5, $s5, 1 # increment the amount of cells shifted by 1
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addi $sp, $sp, 16
    
    addi $s3, $s3, -2 # get the next cell
    addi $s0, $s0, 1 # increment col by 1
    j shift_right_row_loop
    
    shift_right_row_done:
    move $v0, $s5 # $v0 = amount of cells shifted
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    addi $sp, $sp, 24
    ############################################
    jr $ra
    
shift_cell_right:
    #Define your code here
    ############################################
    # $a0 = address of right most cell
    # $a1 = address of cell
    # $a2 = distance between each cell (2 bytes)
    
    move $t0, $a1 # %t0 = counter for the address that is moving
    add $t1, $a0, $a2 # $t1 = the address of the rightmost cell + 1 cell
    li $t3, -1 # $t3 = -1
    add $t0, $t0, $a2 # $t0 = the next cell
    
    shift_cell_right_loop:
    beq $t0, $t1, shift_cell_right_number_found # if the counter reaches the rightmost cell then we place it there
    lh $t2, 0($t0) # $t2 = the value of the cell
    bne $t2, $t3, shift_cell_right_number_found # $t0 contains a number
    add $t0, $t0, $a2 # $t0 = the next cell
    j shift_cell_right_loop
    
    shift_cell_right_number_found:
    sub $t0, $t0, $a2 # get the address of the cell to the left of $t0
    lh $t4, 0($a1) # $t4 = value of the cell being moved
    sh $t3, 0($a1) # turn the cell blank
    sh $t4, 0($t0) # store the value of cell into $t0
    
    shift_cell_right_done:
    ############################################
    jr $ra

shift_col:
    #Define your code here
    ############################################
    lw $t0, 0($sp) # $t0 = direction
    
    shift_col_check:
    li $t1, 2
    blt $a1, $t1, shift_col_error # num_rows < 2
    blt $a2, $t1, shift_col_error # num_cols < 2
    bltz $a3, shift_col_error # col < 0
    bge $a3, $a2, shift_col_error # col >= num_col 
    beq $t0, $0, shift_col_start
    li $t1, 1
    beq $t0, $t1, shift_col_start
    b shift_col_error
    
    
    shift_col_start:
    beq $t0, 0, shift_up
    
    shift_down:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal shift_down_col
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    b shift_col_done
    
    shift_up:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal shift_up_col
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    b shift_col_done
    
    shift_col_error:
    li $v0, -1
    
    shift_col_done:
    ############################################
    jr $ra
    
shift_up_col:
    #Define your code here
    ############################################
    addi $sp, $sp, -28
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    
    li $s0, 0  # $s0 = value of row
    addi $s1, $a1, -1 # $s1 = the row to stop after
    li $s4, -1 # $s4 = -1 for checking
    li $s5, 0 # $s5 = counter for the amount of cells shifted
    sll $s6, $a2, 1 # $s6 = num_cols * 2 (space between each cell)
    
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    
    move $a1, $a2 # $a1 = num_cols
    li $a2, 0 # $a2 = row = 0
    jal get_cell
    move $s2, $v0 # $s2 = address of uppermost cell
    add $s3, $s2, $s6 # $s3 = address of uppermost cell + 1
    li $s0, 1 # $s0 = 1
    
    lw $ra, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    addi $sp, $sp, 16
    
    shift_up_col_loop:
    bgt $s0, $s1, shift_up_col_done # value of row > num_row - 1
    lh $t0, 0($s3) # $t0 = value of $s3
    bne $t0, $s4, check_up_for_blank
    add $s3, $s3, $s6 # get the next cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_up_col_loop
    
    check_up_for_blank:
    sub $t1, $s3, $s6 # $t1 = the address of the cell to the up of the targetted cell
    lh $t1, 0($t1) # $t1 = the value of the cell up of the targetted cell
    beq $t1, $s4, shift_the_cell_up
    add $s3, $s3, $s6 # get the next cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_up_col_loop
    
    shift_the_cell_up:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    
    move $a0, $s2 # $a0 = address of leftmost cell
    move $a1, $s3 # $a1 = address of targetted cell
    move $a2, $s6 # $a2 = num_cols * 2
    jal shift_cell_up
    addi $s5, $s5, 1 # increment the amount of cells shifted by 1
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addi $sp, $sp, 16
    
    add $s3, $s3, $s6 # get the next cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_up_col_loop
    
    shift_up_col_done:
    move $v0, $s5 # $v0 = amount of cells shifted
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    addi $sp, $sp, 28
    ############################################
    jr $ra
    
shift_cell_up:
    #Define your code here
    ############################################
    # $a0 = address of upper most cell
    # $a1 = address of cell
    # $a2 = distance between each cell
    
    move $t0, $a1 # %t0 = counter for the address that is moving
    sub $t1, $a0, $a2 # $t1 = the address of the uppermost cell - 1 cell
    li $t3, -1 # $t3 = -1
    sub $t0, $t0, $a2 # $t0 = the cell on top of this cell
    
    shift_cell_up_loop:
    beq $t0, $t1, shift_cell_up_number_found # if the counter reaches the uppermost cell then we place it there
    lh $t2, 0($t0) # $t2 = the value of the cell
    bne $t2, $t3, shift_cell_up_number_found # $t0 contains a number
    sub $t0, $t0, $a2 # $t0 = get the cell on top of this cell
    j shift_cell_up_loop
    
    shift_cell_up_number_found:
    add $t0, $t0, $a2 # get the address of the cell to the bottom of $t0
    lh $t4, 0($a1) # $t4 = value of the cell being moved
    sh $t3, 0($a1) # turn the cell blank
    sh $t4, 0($t0) # store the value of cell into $t0
    
    shift_cell_up_done:
    ############################################
    jr $ra
    
shift_down_col:
    #Define your code here
    ############################################
    # $a0 = board address
    # $a1 = num_rows
    # $a2 = num_cols
    # $a3 = value of col
    
    addi $sp, $sp, -28
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    
    addi $s0, $a1, -1  # $s0 = value of row
    addi $s1, $a1, -1 # $s1 = row to stop after num_rows - 1
    li $s4, -1 # $s4 = -1 for checking
    li $s5, 0 # $s5 = counter for the amount of cells shifted
    sll $s6, $a2, 1 # $s6 = num_cols * 2 (space between each cell)
    
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    
    move $a1, $a2 # $a1 = num_cols
    move $a2, $s1 # $a2 = row = num_rows - 1
    jal get_cell
    move $s2, $v0 # $s2 = address of bottomost cell
    sub $s3, $s2, $s6 # $s3 = address of bottomost cell - 1
    li $s0, 1 # $s0 = 1
    
    lw $ra, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 8($sp)
    lw $a3, 12($sp)
    addi $sp, $sp, 16
    
    shift_down_col_loop:
    bgt $s0, $s1, shift_down_col_done # value of row > num_row - 1
    lh $t0, 0($s3) # $t0 = value of $s3
    bne $t0, $s4, check_down_for_blank
    sub $s3, $s3, $s6 # get the previous cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_down_col_loop
    
    check_down_for_blank:
    add $t1, $s3, $s6 # $t1 = the address of the cell below the targetted cell
    lh $t1, 0($t1) # $t1 = the value of the cell below the targetted cell
    beq $t1, $s4, shift_the_cell_down
    sub $s3, $s3, $s6 # get the previous cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_down_col_loop
    
    shift_the_cell_down:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    
    move $a0, $s2 # $a0 = address of bottommost cell
    move $a1, $s3 # $a1 = address of targetted cell
    move $a2, $s6 # $a2 = num_cols * 2
    jal shift_cell_down
    addi $s5, $s5, 1 # increment the amount of cells shifted by 1
    
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    addi $sp, $sp, 16
    
    sub $s3, $s3, $s6 # get the previous cell
    addi $s0, $s0, 1 # increment row by 1
    j shift_down_col_loop
    
    shift_down_col_done:
    move $v0, $s5 # $v0 = amount of cells shifted
    
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    addi $sp, $sp, 28
    ############################################
    jr $ra
    
shift_cell_down:
    #Define your code here
    ############################################
    # $a0 = address of bottom most cell
    # $a1 = address of cell
    # $a2 = distance between each cell
    
    move $t0, $a1 # %t0 = counter for the address that is moving
    add $t1, $a0, $a2 # $t1 = the address of the bottommost cell + 1 cell
    li $t3, -1 # $t3 = -1
    add $t0, $t0, $a2 # $t0 = the next cell
    
    shift_cell_down_loop:
    beq $t0, $t1, shift_cell_down_number_found # if the counter reaches the bottommost cell then we place it there
    lh $t2, 0($t0) # $t2 = the value of the cell
    bne $t2, $t3, shift_cell_down_number_found # $t0 contains a number
    add $t0, $t0, $a2 # $t0 = the next cell
    j shift_cell_down_loop
    
    shift_cell_down_number_found:
    sub $t0, $t0, $a2 # get the address of the cell to the top of $t0
    lh $t4, 0($a1) # $t4 = value of the cell being moved
    sh $t3, 0($a1) # turn the cell blank
    sh $t4, 0($t0) # store the value of cell into $t0
    
    shift_cell_down_done:
    ############################################
    jr $ra

check_state:
    #Define your code here
    ############################################
    addi $sp, $sp, -28
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    
    li $s0, 0 # $s0 = row counter
    li $s1, 0 # $s1 = col counter
    li $s3, 0 # $s3 = # of blanks
    move $s4, $a1 # $s4 = num_rows
    move $s5, $a2, # $s5 = num_cols
    sll $s6, $s5, 1 # $s6 = num_cols * 2
    
    #$a0 = base address
    #$a1 = number of columns
    #$a2 = row value
    #$a3 = col value
    
    addi $sp, $sp, -8
    sw $a1, 0($sp)
    sw $a2, 4($sp)
    move $a1, $a2 # $a1 = num_cols
    li $a2, 0 # $a2 = col value
    li $a3, 0# $a3 = row value
    
    check_win_loop:
    bge $a3, $s4, check_win_loop_done
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    jal get_cell
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    move $t0, $v0 # $t0 = the address of cell
    lh $t1, 0($t0) # $ t1 = value of the cell
    li $t2, -1 
    li $t3, 2048
    bne $t1, $t2, dont_increment_blank_counter
    addi $s3, $s3, 1 # increment blank counter
    dont_increment_blank_counter:
    bge $t1, $t3, game_won
    addi $a2, $a2, 1 # increment col by 1
    bge $a2, $s5, increment_row
    j check_win_loop
    
    increment_row:
    addi $a3, $a3, 1 # row = row + 1
    li $a2, 0 # col = 0
    j check_win_loop
    
    check_win_loop_done:
    lw $a1, 0($sp)
    lw $a2, 4($sp)
    addi $sp, $sp, 8
    beq $s3, 0, check_mergables
    game_still_going:
    li $v0, 0
    b check_win_done
    
    check_mergables:
    
    check_mergable_rows:
    move $t0, $a0 # $t0 = beginning address
    addi $t5, $s5, -1 # $t5 = num_cols - 1
    check_mergable_row_loop_row:
    bge $s0, $s4, check_mergable_rows_done # row >= num_rows
    move $t1, $t0 # $t1 = target cell address
    check_mergable_row_loop_col:
    addi $t2, $t1, 2 # $t2 = the address of the cell to the right of the target cell
    lh $t3, 0($t1) # $t3 = value of target cell
    lh $t4, 0($t2) # $t4 = value of right cell
    beq $t3, $t4, game_still_going
    addi $t1, $t1, 2 # increment target address
    addi $s1, $s1, 1 # increment col counter
    bge $s1, $t5, mergable_row_increment_row # col counter >= num_cols - 1
    j check_mergable_row_loop_col
    mergable_row_increment_row:
    addi $s0, $s0, 1 # increment row counter
    li $s1, 0 # col counter = 0
    add $t0, $t0, $s6 # increment beginning address tog et next row
    j check_mergable_row_loop_row
    
    check_mergable_rows_done:
    li $s0, 0 # row counter = 0
    li $s1, 0 # col counter = 0
    
    check_mergable_cols:
    move $t0, $a0 # $t0 = beginning address
    addi $t5, $s4, -1 # $t5 = num_rows - 1 (last row)
    check_mergable_col_loop_col:
    bge $s1, $s5, check_mergable_cols_done # col >= num_cols
    move $t1, $t0 # $t1 = target cell address
    check_mergable_col_loop_row:
    add $t2, $t1, $s6 # $t2 = the address of the cell to the bottom of the target cell
    lh $t3, 0($t1) # $t3 = value of target cell
    lh $t4, 0($t2) # $t4 = value of bottom cell
    beq $t3, $t4, game_still_going
    add $t1, $t1, $s6 # increment target address
    addi $s0, $s0, 1 # increment row counter
    bge $s0, $t5, mergable_col_increment_col # row counter >= num_rows - 1
    j check_mergable_col_loop_row
    mergable_col_increment_col:
    addi $s1, $s1, 1 # increment col counter
    li $s0, 0 # row counter = 0
    addi $t0, $t0, 2 # increment beginning address tog et next col
    j check_mergable_col_loop_col
    
    check_mergable_cols_done:
    
    game_lost:
    li $v0, -1
    b check_win_done
    
    game_won:
    lw $a1, 0($sp)
    lw $a2, 4($sp)
    addi $sp, $sp, 8
    li $v0, 1
    
    check_win_done:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    addi $sp, $sp, 28
    ############################################
    jr $ra

user_move:
    #Define your code here
    ############################################
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    
    li $t0, 'L' # $t0 = Left
    li $t1, 'R' # $t1 = Right
    li $t2, 'U' # $t2, = Up
    li $t3, 'D' # $t3 = Down
    
    li $s0, 0 # $s0 = row counter
    li $s1, 0 # $s1 = col counter
    li $s2, 0 # $s2 = amount of shifts done
    
    beq $a3, $t0, swipe_left
    beq $a3, $t1, swipe_right
    beq $a3, $t2, swipe_up
    beq $a3, $t3, swipe_down
    b user_move_error
    
    swipe_left:
    li $t4, 0 # $t4 - left
    b swipe_row_shift_loop
    
    swipe_right:
    li $t4, 1 # $t4 - right
    b swipe_row_shift_loop
    
    swipe_up:
    li $t4, 0 # $t4 - top
    b swipe_col_shift_loop
    
    swipe_down:
    li $t4, 1 # $t4 - down
    b swipe_col_shift_loop
    
    swipe_row_shift_loop:
    bge $s0, $a1, swipe_row_shift_complete
    addi $sp, $sp, -12
    sw $t4, 0($sp) # direction
    sw $ra, 4($sp)
    sw $a3, 8($sp)
    move $a3, $s0 # $a3 = currrent row
    jal shift_row
    lw $t4, 0($sp)
    lw $ra, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    beq $v0, -1, user_move_error
    addi $s0, $s0, 1 # increment row
    j swipe_row_shift_loop
    
    swipe_row_shift_complete:
    addi $s2, $s2, 1
    bgt $s2, 1, swipe_check_state # shifted twice
    b swipe_row_merge
    
    swipe_row_merge:
    li $s0, 0 # row = 0
    
    swipe_row_merge_loop:
    bge $s0, $a1, swipe_row_merge_complete
    addi $sp, $sp, -12
    sw $t4, 0($sp) # direction
    sw $ra, 4($sp)
    sw $a3, 8($sp)
    move $a3, $s0 # $a3 = currrent row
    jal merge_row
    lw $t4, 0($sp)
    lw $ra, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    beq $v0, -1, user_move_error
    addi $s0, $s0, 1 # increment row
    j swipe_row_merge_loop
    
    swipe_row_merge_complete:
    li $s0, 0 # row = 0
    j swipe_row_shift_loop
    
    swipe_col_shift_loop:
    bge $s1, $a2, swipe_col_shift_complete
    addi $sp, $sp, -12
    sw $t4, 0($sp) # direction
    sw $ra, 4($sp)
    sw $a3, 8($sp)
    move $a3, $s1 # $a3 = currrent col
    jal shift_col
    lw $t4, 0($sp)
    lw $ra, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    beq $v0, -1, user_move_error
    addi $s1, $s1, 1 # increment col
    j swipe_col_shift_loop
    
    swipe_col_shift_complete:
    addi $s2, $s2, 1
    bgt $s2, 1, swipe_check_state # shifted twice
    b swipe_col_merge
    
    swipe_col_merge:
    li $s1, 0 # col = 0
    beq $t4, $0, dir_is_one
    li $t4, 0
    b swipe_col_merge_loop
    dir_is_one:
    li $t4, 1
    
    swipe_col_merge_loop:
    bge $s1, $a2, swipe_col_merge_complete
    addi $sp, $sp, -12
    sw $t4, 0($sp) # direction
    sw $ra, 4($sp)
    sw $a3, 8($sp)
    move $a3, $s1 # $a3 = currrent col
    jal merge_col
    lw $t4, 0($sp)
    lw $ra, 4($sp)
    lw $a3, 8($sp)
    addi $sp, $sp, 12
    beq $v0, -1, user_move_error
    addi $s1, $s1, 1 # increment col
    j swipe_col_merge_loop
    
    swipe_col_merge_complete:
    li $s1, 0 # col = 0
    beq $t4, $0, dir_is_one_2
    li $t4, 0
    b swipe_col_shift_loop
    dir_is_one_2:
    li $t4, 1
    j swipe_col_shift_loop
    
    
    swipe_check_state:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $a3, 4($sp)
    jal check_state
    lw $ra, 0($sp)
    lw $a3, 4($sp)
    addi $sp, $sp, 8
    
    swipe_success:
    move $v1, $v0
    li $v0, 0
    b swipe_done
    
    user_move_error:
    li $v0, -1
    li $v1, -1
    
    swipe_done:
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addi $sp, $sp, 12
    ############################################
    jr $ra

#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


