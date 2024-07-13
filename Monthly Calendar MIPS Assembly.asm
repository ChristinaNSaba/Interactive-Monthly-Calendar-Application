.data 
     fileName:  .asciiz "Calendar.txt"
     fileContent: .space 1024
     menuFrame: .asciiz "\n   ============\n   =   MENU   =\n   ============\n"
     calendar:  .asciiz "\n   ================\n   =   CALENDAR   =\n   ================\n"
     option1:   .asciiz "\n A)) View Calendar.\n"
     option1.1: .asciiz "-----Press 1: View per day\n"
     option1.2: .asciiz "-----Press 2: View per set of days\n"
     option1.3: .asciiz "-----Press 3: View a given slot for a given day\n"
     option2:   .asciiz "\n B)) View Statistics.\n Press 4 to view:\n----number of lectures (in hours)\n----number of Office hours OH (in hours)\n----number of meetings (in hours)\n----average lectures per day\n----ratio between number of Lectures L and nujmber of Office hours OH \n"
     option3:   .asciiz "Press 5: Add a New Appointment.\n"
     option4:   .asciiz "Press 6: Delete an Appointment.\n"
     option5:   .asciiz "Press 0: Exit.\n"
     choice:    .asciiz "\nEnter your choice: "
     error:     .asciiz "\nwrong input!\n"
     msg1:      .asciiz "\nEnter the day you want to view appointments for (1-31): "
     txtToFile: .space 100
     file_descriptor: .word 0
     printForUser:    .asciiz "\nAppointment added successfully!\n"
     newText:         .space 1024
     userInputDel:    .space 10
     del1:            .asciiz "\nPress 1: M\nPress 2: L\nPress 3: OH\nEnter Your Choice:"
     avgL:            .space 50
     
     #viewPerSetDaysChoices
     setDaysInput:	.asciiz "Enter the number of days to view: \n"
     invalidMsg: .asciiz "Invalid number. Please enter numbers between 1 and 31.\n"
     
     #viewPerGivenSlotChoices
     firstNum: .asciiz "Enter the Beginning hour of the time slot of the chosen day to view if found:\n"
     lastNum: .asciiz "Enter the Ending hour of the time slot of the chosen day to view if found:\n"
     
     storeArray:  .word 100
     arrayLength: .word 100
     
     wrongHour:   .asciiz "\nWrong Hour range. Enter an hour from 8AM to 5PM:\n"
     
     output:    .space 100
     appointments: .space 1024
     line:      .space 1024
     buffer:    .space 1
     bufferIn:    .space 5
     output1:   .space 100
     inputMsg:   .space 100
     filenot:    .ascii "\nfile not found\n"
     newLine:    .asciiz "\n"
     Lcounter:   .space 10
     OHcounter:  .space 10
     Mcounter:   .space 10
     statisticMsg1:   .asciiz "The number of lectures "
     Lcount:     .space 10
     countLmsg:  .asciiz "\nNumber of Lectures in hours: "
     countOHmsg:  .asciiz "\nNumber of office hours in hours: "
     countMmsg:  .asciiz "\nNumber of meetings in hours: "
     notFoundDay: .asciiz "\nDay not found\n"
     avgOfLec:    .asciiz "\nAverage of lectures per day: "
     enterDay:    .asciiz "\nEnter the day: "
     enterStime:  .asciiz "\nEnter the start time: "
     enterEtime:  .asciiz "\nEnter the end time: "
     enterType:   .asciiz "\nEnter the type of the appointment: "
     invalidInputMsg: .asciiz "\nInvalid input!\n"
     ratioLOH:    .asciiz "Ratio between Lectures and office hours in hours: "
     

.text
     Menu:
     	  #the menu is printed to the user to enter the requested part 
     	  li $t8, 1
     	  beq $a3, $t8, viewSetDays #to branch to setDays again
     	  
     	  li $t5, 0
     	  li $v0, 4
     	  la $a0, newLine
     	  syscall
     	  
          li $v0, 4
          la $a0, menuFrame
          syscall   
          
          li $v0, 4
          la $a0, option1
          syscall  
          
          li $v0, 4
          la $a0, option1.1
          syscall  
          li $v0, 4
          la $a0, option1.2
          syscall  
          li $v0, 4
          la $a0, option1.3
          syscall  
          
          li $v0, 4
          la $a0, option2
          syscall  
          
          li $v0, 4
          la $a0, option3
          syscall  
          
          li $v0, 4
          la $a0, option4
          syscall  
          
          li $v0, 4
          la $a0, option5
          syscall  
          
          li $v0, 4
          la $a0, choice
          syscall
          
          li $v0, 5
          syscall 
          move $t0, $v0 
          
          
          # t0 contains the choice
          # t0 = entered number by the user
          
          beq $t0, 1, viewPerDay
          beq $t0, 2, viewPerSetDays
          beq $t0, 3, viewAGivenSlot
          beq $t0, 4, viewStatistics
          beq $t0, 5, addAppointment
          beq $t0, 6, deleteAppointment
          beq $t0, 0, exit
          b  ErrorMessage
            
readFile:
	#the system reads the text file contents
     li $v0, 13
     la $a0, fileName
     li $a1, 0
     syscall
     move $s0, $v0
     
     li $v0, 14
     move $a0, $s0
     
     la $a1, fileContent
     la $a2, 1024
     syscall
     
     la $t0, fileContent
     
     jr $ra
     
initializeArray:
    la $t1, storeArray  
    lw $t2, arrayLength  

    li $t3, 0            
    loopInitialize:
        sw $t3, 0($t1)    
        addi $t1, $t1, 4   
        subi $t2, $t2, 1   
        bnez $t2, loopInitialize  

    jr $ra                 

                                                                                                                                                                                                                                                                                                                                          
viewPerDay:
     # the system prints a selected day entered by the user if found in the text file
     li $v0, 4
     la $a0, calendar
     syscall 
     
     li $v0, 4
     la $a0, msg1 
     syscall
     
     
     li $v0, 13
     la $a0, fileName
     li $a1, 0
     syscall
     move $s0, $v0
     
     li $v0, 14
     move $a0, $s0
     
     la $a1, fileContent
     la $a2, 1024
     syscall
     
     la $t0, fileContent
     
     li $v0, 5
     syscall
     move $t6, $v0
     add $t6, $t6, 48
     
     lb $t1, 0($t0)
     beq $t1, $zero, filenotfound
     li $s5, 0
     letter1:
     	lb $t1, 0($t0)
     	li $s3, 58
     	beq $t1, $s3, checkBeforCol
     	beq $t1, 0, dayNotFound
     	addi $t5, $t5, 1
     	addi $t0, $t0, 1
     	b letter1 
     
     j Menu


viewStatistics:
	#the system prints the calculations requested included finding the number of hours of L OH and M, find the average of L, and ratio between L and OH
     #making statistics
     jal readFile
     #counter for lectures
     li $s2, 0
     
     #counter for OH
     li $s4, 0
     
     #counter for M
     li $s5, 0
     
     readLoop:
        addi $t5, $t5, 1
     	lb $t1, 0($t0)
     	#L
     	li $s3, 0
     	beq $t1, 76, addToLcounter
        li $s3, 1
        #OH
     	beq $t1, 79, addToLcounter
     	li $s3, 2
     	#M
     	beq $t1, 77, addToLcounter
     	
        beq $t1, 0, endCounting
     	addi $t0, $t0, 1
     	b readLoop
     	
         
addAppointment:
	#add an appointment if not conflicting with the other existing appointments in the selected day by the user if found in the calendar
     # add an appointment
     #t2 = day
     #t3 = start time
     #t4 = end time
     #t5 = type
     li $t6, 0
     li $t7, 0
     li $a1, 0
     
     li $v0, 4
     la $a0, enterDay
     syscall
     
     li $v0, 5
     syscall
     move $t2, $v0
     
     li $v0, 4
     la $a0, enterStime
     syscall
     
     li $v0, 5
     syscall
     move $t3, $v0
     
     li $v0, 4
     la $a0, enterEtime
     syscall
     
     li $v0, 5
     syscall
     move $t4, $v0
     
     li $v0, 4
    la $a0, enterType
    syscall
    
    li $v0, 4
    la $a0, del1
    syscall
    
    li $v0, 5
    syscall
    move $t5, $v0
    
    beq $t5, 1, MFunction.1
    b cont438.1
    
    MFunction.1:
    	li $t5, 77
    	b cont451.1
    	
    cont438.1:	
    beq $t5, 2, LFunction.1
    b cont447.1
    
    LFunction.1:
    	li $t5, 76
    	b cont451.1
    	
    cont447.1:
    beq $t5, 3, OHFunction.1
    b cont451.1
    
    OHFunction.1:
    	li $t5, 79
    	b cont451.1
    
    b invalidMsgDel
    
    cont451.1:
     
     ble $t3, 5, add12v3
     
     backHere:
     ble $t4, 5, add12v4
     
     backHere2:
     ble $t3, 7, printErrorMessage
     
     li $t6, 323
     
     jal readFile
     
     loop1:
     	lb $t1, 0($t0)
     	beq $t1, 58, checkBeforCol2
     	beq $t1, 0, dayNotFound
     	addi $t0, $t0, 1
     	b loop1
     
	
     j Menu

add12v3:
     	addi $t3, $t3, 12
     	b backHere
     	
     	
add12v4:
	addi $t4, $t4, 12
	b backHere2
	
     	            
deleteAppointment:
	#delete an appointment if the slot entered matches one of the existing appointments in the selected day by the user if found (the beginning and ending hour and the type should match exactly to delete)
     #delete an appointment
     # t2 = day, t3 = start time, t4 = end time
    li $v0, 4
    la $a0, enterDay
    syscall
    
    li $v0, 5
    syscall
    move $t2, $v0
    
    li $v0, 4
    la $a0, enterStime
    syscall
    
    li $v0, 5
    syscall
    move $t3, $v0
    
    li $v0, 4
    la $a0, enterEtime
    syscall
    
    li $v0, 5
    syscall
    move $t4, $v0
    
    li $v0, 4
    la $a0, enterType
    syscall
    
    li $v0, 4
    la $a0, del1
    syscall
    
    li $v0, 5
    syscall
    move $t5, $v0
    
    beq $t5, 1, MFunction
    b cont438
    
    MFunction:
    	li $t5, 77
    	b cont451
    	
    cont438:	
    beq $t5, 2, LFunction
    b cont447
    
    LFunction:
    	li $t5, 76
    	b cont451
    	
    cont447:
    beq $t5, 3, OHFunction
    b cont451
    
    OHFunction:
    	li $t5, 79
    	b cont451
    
    b invalidMsgDel
    
    cont451:
    jal readFile
    la $a0, fileContent
    move $t0, $a0
    lb $t1, 0($t0)
    move $t8, $t0
    la $a1, newText
    sb $t1, 0($a1)
    
    loop6:
    	addi $t0, $t0, 1
    	addi $a1, $a1, 1
        lb $t1, 0($t0)
        sb $t1, 0($a1)
        
     	beq $t1, 58, checkBeforeColDel
     	beq $t1, 0, test
     	b loop6
     	
     j Menu

test:
	li $v0, 4
	la $a0, newText
	syscall
	
	la $a0, newText
	addi $a0, $a0, 1
	
	 # Open the file for writing
        li $v0, 13           # System call for open file
        la $a0, fileName   
        li $a1, 1            # Open for writing
        li $a2, 0            
        syscall              # Open a file
        move $s6, $v0        # Save the file descriptor 

        # Write text to the file
        li $v0, 15
        move $a0, $s6      
        la $a1, newText   
        li $a2, 1024         
        syscall
        
        
        li $v0, 16
        move $a0, $s6
        syscall

	b Menu
		
checkBeforeColDel: #find the day based on the colon in that line by checking if one digit day like 1 or two-digits like 25

    subi $s2, $t0, 2
    lb $t7, 0($s2)
    beq $t7, 49, twoDigitsDel
    beq $t7, 50, twoDigitsDel
    beq $t7, 51, twoDigitsDel
    move $s3, $t0
    subi $s3, $s3, 1
    
    lb $s4, 0($s3)
    subi $s4, $s4, 48 # $s4 has the day number from file
    beq $s4, $t2, checkDelete
    b loop6
   
twoDigitsDel:
    
    #10 => s3 = 0 , s2 = 1 
    subi $s7, $t0, 1
    lb $s3, 0($s7)
    subi $s7, $s7, 1
    lb $s2, 0($s7)
    sub $s3, $s3, 48
    sub $s2, $s2, 48
    mul $s2, $s2, 10
    add $t7, $s2, $s3
    #here
    move $s3, $t0
    subi $s3, $s3, 1
    
    beq $t7, $t2, checkDelete
    
    b loop6
         
twoDigDel:
	# 12 => t7 = 2, s4 = 1
	lb $t7, 0($s2) 
	subi $s2, $s2, 1
	lb $s4, 0($s2)
	subi $t7, $t7, 48
	subi $s4, $s4, 48
	mul $s4, $s4, 10
	# s4 = 12
	add $s4, $s4, $t7
	beq $s4, $t3, nextStage
	b check2
	
	        
checkDelete:
    move $k0, $t0
    addi $t0, $t0, 1 #now t0 is at space
    lb $t1, 0($t0)
    move $s2, $t0
    loop7:
        addi $s2, $s2, 1 #now $s2 is at first digit of begin hour
        lb $s3, 0($s2)
        beq $s3, 49, checkAfter
        beq $s3, 32, returnLoop7
        subi $s3, $s3, 48
	beq $s3, $t3, nextStage
	b check2
    	#lb $s1, 0($t0)
    	
returnLoop7:
        addi $a1, $a1, 1
	sb  $s3, 0($a1)
	b loop7
	
	   	
nextStage:
    addi $s2, $s2, 1
    lb $t1, 0($s2)
    beq $t1, 45, checkAfterSlash
    b nextStage
    

checkAfterSlash:
	addi $s2, $s2, 1
	# 12 => $s6 = 1, $t1 = 2
	lb $s6, 0($s2) 
	addi $s5, $s2, 1
	lb $t1, 0($s5)
	bne $t1, 32, twoDigDel1
	subi $s6, $s6, 48
	beq $s6, $t4, checkType
	b check2


twoDigDel1:
	addi $s2, $s2, 1 #now $s2 is at the last digit of end hour
	subi $s6, $s6, 48
	subi $t1, $t1, 48
	mul $s6, $s6, 10
	add $t1, $t1, $s6
	beq $t1, $t4, checkType
	b check2

		
checkType: #check the type entered by user is matching to continue delete process
	addi $s2, $s2, 2 
	lb $t1, 0($s2) #$t1 has the type of slot (L OH M)
	addi $s2, $s2, 1
	beq $t1, 79, skipH
	b cont574
	skipH:
		addi $s2, $s2, 2
		beq $t1, $t5, contStoring1
		b check2
		
	cont574:
	beq $t1, $t5, contStoring
	addi $s2, $s2, 2
	#beq $t1, $t5, SlotDel 
	b check2   	


contStoring:
        addi $a1, $a1, 1
	lb $t1, 0($s2)
	beq $t1, 0, test
	sb $t1, 0($a1)
	
	addi $s2, $s2, 1
	b contStoring


contStoring1:

	li $s6, 10
	addi $a1, $a1, 1
	sb $s6, 0($a1)
	
        addi $a1, $a1, 1
	lb $t1, 0($s2)
	beq $t1, 0, test
	sb $t1, 0($a1)
	
	addi $s2, $s2, 1
	b contStoring	

										
SlotDel:
        lb $t1, 0($t8)
	sb $t1, 0($a1)
    loopStore:
    	addi $t8, $t8, 1
    	addi $a1, $a1, 1
        lb $t1, 0($t8)
     	beq $t1, 0, test
     	subi $t1, $t1, 48 
     	add $t9, $t8, 1
     	lb $t9, 0($t9)
     	bne $t9, 45, twoDigHourDel
     	contDel:
     	beq $t1, $t3, skipSlot
     	#addi $t1, $t1, 48
     	sb $t1, 0($a1)
     	b loopStore
     	

twoDigHourDel:
	# 12 => $t1 = 1, $t9 = 2
	add $t8, $t8, 1
	sub $t9, $t9, 48
	mul $t1, $t1, 10
	add $t1, $t1, $t9
	b contDel
	
	
	skipSlot:
		addi $t8, $t8, 5 #now $t8 skipped the slot until the apace between slots
		b loopStore 		   		    		    				    		    				    		    		    		    				    		    							    		    		    		    				    		    				    		    		    		    				    		    						    		    		    		    				    		    				    		    		    		    				    		    					    		    		    		    				    		    				    		    		    		    				    		    							    		    		    		    				    		    				    		    		    		    				    		    						    		    		    		    				    		    				    		    		    		    				    		    		
					    		    		    		    				    		    				    		    		    		    				    		    						    		    		    		    				    		    				    		    		    		    				    		    						    		    		    		    				    		    				    		    		    		    				    		    						    		    		    		    				    		    				    		    		    		    				    		    		
check2:
	
	addi $a1, $a1, 1
	lb $t1, 0($s2)
	sb $t1, 0($a1)
	
	beq $t1, 44, loop7
	beq $t1, 10, printErrorMessage
	addi $s2, $s2, 1
	b check2
	  
    
checkAfter:
	addi $s2, $s2, 1
	lb $s3, 0($s2)
	bne $s3, 45, twoDigDel
	subi $s3, $s3, 48
	beq $s3, $t3, nextStage
	b check2
	
	   	   
invalidMsgDel:
	li $v0, 4
	la $a0, invalidInputMsg
	syscall
	
	b  deleteAppointment
    
endCounting: #continue the calculations for the statistics 
	li $k0, 0
	li $k1, 0
	sb $t3, Mcounter
	sb $t4, OHcounter
	
	li $v0, 4
	la $a0, countLmsg
	syscall
	
	li $v0, 1      
	move $a0, $s2 
	syscall
	
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	
	li $v0, 4
	la $a0, countOHmsg
	syscall

	
	li $v0, 1      # syscall code for print integer
	move $a0, $s4  # load the value to print
	syscall
	
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	
	li $v0, 4
	la $a0, countMmsg
	syscall
	
	
	li $v0, 1      
	move $a0, $s5  
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	
	sb $s2, Lcounter
	#average of lectures
	jal readFile
	
	loop746:
		lb $t1, 0($t0)
		beq $t1, 58, addToDayCounter
		beq $t1, 76, addToLnumber
		beq $t1, 0, cont752
		addi $t0, $t0, 1
		b loop746
	
		
        cont752:
        mtc1 $k0, $f0
        mtc1 $k1, $f1
        	
	div.s $f2, $f1, $f0
	
	li $v0, 4
	la $a0, avgOfLec
	syscall
	
	li $v0, 2
	mov.s $f12, $f2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	#ratio between L and OH
	li $t3, 0
	mtc1 $s2, $f0
	mtc1 $s4, $f1
	
	div.s $f2, $f0, $f1
	
	li $v0, 4
	la $a0, ratioLOH
	syscall
	
	li $v0, 2
	mov.s $f12, $f2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $k0, 0
	li $k1, 0
	b Menu


exit:
    li $v0, 10
    syscall 


ErrorMessage: #print error message if branched to

    li $v0,4
    la $a0,error
    syscall
    
    j Menu          
      
              
filenotfound: #print file not found if not exists
    la $a0, filenot
    li $v0, 4
    syscall
    
    
checkBeforCol:
    
    subi $s2, $t0, 2
    lb $t7, 0($s2)
    beq $t7, 49, twoDigits
    beq $t7, 50, twoDigits
    beq $t7, 51, twoDigits
    move $t2, $t0
    subi $t2, $t2, 1
    
    lb $t3, 0($t2)
    
    beq $t3, $t6, printLine
    beq $t3, $t2, checkAvailability
    move $k0, $t0
    addi $t0, $t0, 1
    beq $t6, 323, loop1
    b letter1
    
    
checkBeforCol2:
    
    subi $s2, $t0, 2
    lb $t7, 0($s2)
    beq $t7, 49, twoDigitsAdd
    beq $t7, 50, twoDigitsAdd
    beq $t7, 51, twoDigitsAdd
    
    move $s1, $t0
    subi $s1, $s1, 1
    
    lb $s3, 0($s1)
    subi $s3, $s3, 48
    beq $s3, $t2, checkAvailability
    addi $t0, $t0, 1
    b loop1
 
 
checkAvailability: #if the day matched then the appointments are checked if not conflicting to add appointment
    
    addi $t0, $t0, 1
    lb $t1, 0($t0)
    
    loop4:
    	lb $t1, 0($t0)
    	beq $t1, 45, checkBeforeSlash
    	beq $t1, 10, printInFile
    	beq $t1, 0, printInFile
    	addi $t0, $t0, 1
    	b loop4
    
    
    j Menu


 printNewLine:
    b Menu
    
          
checkBeforeSlash:
    # x - y => s3 = x, s4 = y
    move $s2, $t0
    subi $s3, $t0, 1
    subi $s2, $t0, 2
    lb $s2, 0($s2)
    beq $s2, 49, forTwoDig
    
    lb $s3, 0($s3)
    subi $s3, $s3, 48
    ble $s3, 5, add12Fors3.1
    b resume556
    
    add12Fors3.1:
    	addi $s3, $s3, 12
    	b resume556
    	
    resume556:
    move $s2, $t0
    addi $s4, $s2, 2
    lb $s4, 0($s4)
    beq $s4, 49, forTwoDig2
    beq $s4, 48, forTwoDig2
    addi $s4, $s2, 1
    lb $s4, 0($s4)
    subi $s4, $s4, 48
    ble $s4, 5, add12Fors4.1
    b resume568
    
    add12Fors4.1:
    	addi $s4, $s4, 12
    	b resume568
    
    resume568:
    beq $t3, $s3, printErrorMessage
    beq $t4, $s4, printErrorMessage
    
    bge $t3, $s3, newB
    b resume582
    newB:
    	blt $t4, $s4, printErrorMessage
    	b resume582
    
    resume582:
    bge $t4, $s3, newB1
    b resume589
    newB1:
    	blt $t4, $s4, printErrorMessage
    	b resume589
    	
    resume589:	
    bgt $s3, $t3, newB2
    b cont5
    
    newB2:
    	blt $s4, $t4, printErrorMessage
    	b cont5 
 
       
add12Fors3:
	addi $s3, $s3, 12
	jr $ra
	
	                
add12Fors4:
	addi $s4, $s4, 12
	jr $ra     
	
	
forTwoDig:
    # 11 - 1 => s4 = 11
    move $s2, $t0
    subi $s3, $s2, 1
    subi $s4, $s2, 2
    lb $s3, 0($s3)
    lb $s4, 0($s4)
    subi $s3, $s3, 48
    subi $s4, $s4, 48
    mul $s4, $s4, 10  
    add $s3, $s4, $s3
    ble $s3, 5, add12Fors3.2
    b resume613
    add12Fors3.2:
    	addi $s3, $s3, 12
    	b resume613
    
    resume613:
    move $s2, $t0
    addi $s4, $s2, 2
    lb $s4, 0($s4)
    bne $s4, 32, forTwoDig1
    
    move $s4, $t0
    addi $s4, $s2, 1
    lb $s4, 0($s4)
    subi $s4, $s4, 48
    ble $s4, 5, add12Fors4.2
    b resume630
    
    add12Fors4.2:
    	addi $s4, $s4, 12
    	b resume630
    
    resume630:
    beq $t3, $s3, printErrorMessage
    beq $t4, $s4, printErrorMessage
    
    bge $t3, $s3, newB.1
    b resume582.1
    newB.1:
    	blt $t4, $s4, printErrorMessage
    	b resume582.1
    
    resume582.1:
    bge $t4, $s3, newB1.1
    b resume589.1
    
    newB1.1:
    	blt $t4, $s4, printErrorMessage
    	b resume589.1
    	
    resume589.1:	
    bgt $s3, $t3, newB2.1
    b cont5
    
    newB2.1:
    	blt $s4, $t4, printErrorMessage
    	b cont5 
 	           	            	                   	            	                   	            	                   	            	        
forTwoDig1:
    # 10 - 12 => s4 = 12
    li $s7, 0
    move $s2, $t0
    addi $s7, $s2, 1
    addi $s5, $s2, 2
    lb $s7, 0($s7)
    lb $s5, 0($s5)
    subi $s7, $s7, 48
    subi $s5, $s5, 48
    mul $s7, $s7, 10
    add $s4, $s5, $s7
    
    beq $t3, $s7, printErrorMessage
    beq $t4, $s4, printErrorMessage
    
    bge $t3, $s3, newB.2
    b resume582.2
    newB.2:
    	blt $t4, $s4, printErrorMessage
    	b resume582.2
    
    resume582.2:
    bge $t4, $s3, newB1.2
    b resume589.2
    newB1.2:
    	blt $t4, $s4, printErrorMessage
    	b resume589.2
    	
    resume589.2:	
    bgt $s3, $t3, newB2.2
    b cont5
    
    newB2.2:
    	blt $s4, $t4, printErrorMessage
    	b cont5 


forTwoDig2:
    
    move $s5, $t0
    addi $s5, $t0, 2
    addi $s6, $t0, 1
    
    lb $s5, 0($s5)
    lb $s6, 0($s6)
    
    subi $s5, $s5, 48
    subi $s6, $s6, 48
    
    mul $s6, $s6, 10
    add $s4, $s6, $s5
    
    beq $t3, $s3, printErrorMessage
    beq $t4, $s4, printErrorMessage
    
    bge $t3, $s3, newB.3
    b resume582.3
    newB.3:
    	blt $t4, $s4, printErrorMessage
    	b resume582.3
    
    resume582.3:
    bge $t4, $s3, newB1.3
    b resume589.3
    newB1.3:
    	blt $t4, $s4, printErrorMessage
    	b resume589.3
    	
    resume589.3:	
    bgt $s3, $t3, newB2.3
    b cont5
    
    newB2.3:
    	blt $s4, $t4, printErrorMessage
    	b cont5 
    
    
cont5:
    addi $t0, $t0, 1
    lb $s6, 0($t0)
    beq $s6, 10, printInFile
    beqz $s6, printInFile
    b loop4
    
        
printInFile: #print in file the added appointment when no conflict found
 
    li $v0, 4
    la $a0, printForUser
    syscall 
    
    li $v0, 4
    la $a0, txtToFile
    syscall
    
    li $s0, 58  # ( : )
    li $s1, 32  # ( space )
    li $s2, 45  # ( - )
    li $s3, 10  # ( \n )
    li $s4, 49  
    
    subi $s5, $t3, 10
    addi $s5, $s5, 48

    la $a0, txtToFile

    move $t0, $a0
    bgt $t3, 9, storeTwoDig
    b cont1078
 
    storeTwoDig:
       	addi $t2, $t2, 48
    	 sb $t2, 0($a0)
         addi $t0, $t0, 1

         sb $s0, 0($t0)
         addi $t0, $t0, 1

         sb $s1, 0($t0)
         addi $t0, $t0, 1
         
         sb $s4, 0($t0)
         addi $t0, $t0, 1
         
         sb $s5, 0($t0)
         addi $t0, $t0, 1
         
         sb $s2, 0($t0)
         addi $t0, $t0, 1
         
         subi $s6, $t4, 10
         addi $s6, $s6, 48
         
         sb $s1, 0($t0)
         addi $t0, $t0, 1
         
         sb $t5, 0($t0)
         addi $t0, $t0, 1
         
         sb $s3, 0($t0)
         b cont1122
         
         
    cont1078:
    addi $t2, $t2, 48
    addi $t3, $t3, 48
    addi $t4, $t4, 48
    
    sb $t2, 0($a0)
    addi $t0, $t0, 1

    sb $s0, 0($t0)
    addi $t0, $t0, 1

    sb $s1, 0($t0)
    addi $t0, $t0, 1

    sb $t3, 0($t0)
    addi $t0, $t0, 1

    sb $s2, 0($t0)
    addi $t0, $t0, 1

    sb $t4, 0($t0)
    addi $t0, $t0, 1
    
    sb $s1, 0($t0)
    addi $t0, $t0, 1
         
    sb $t5, 0($t0)
    addi $t0, $t0, 1

    sb $s3, 0($t0)
    
      # Open the file in write mode (truncates the file)
    li $v0, 13            # open file
    la $a0, fileName      
    li $a1, 1            
    li $a2, 0           
    syscall
    sw $v0, file_descriptor  # Save the file descriptor for later use
    
    # Write the text to the file
    li $v0, 15           
    lw $a0, file_descriptor  
    la $a1, txtToFile     
    li $a2, 100            
    syscall

    # Close the file
    li $v0, 16          
    lw $a0, file_descriptor  
    syscall
    
    cont1122:
    li $v0, 4
    la $a0, fileContent
    syscall
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, txtToFile
    syscall
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    b Menu
    	
	
checkExtra:
    bge $t4, $s4, cont5
    
    li $v0, 4
    la $a0, invalidInputMsg
    syscall
    
    b Menu
    

printErrorMessage:
    #li $k0, 329
    li $v0, 4
    la $a0, invalidInputMsg
    syscall
    
    b Menu
    
            
twoDigits:
    
    #10 => t3 = 0 , t2 = 1 
    subi $s7, $t0, 1
    lb $t3, 0($s7)
    subi $s7, $s7, 1
    lb $t2, 0($s7)
    sub $t3, $t3, 48
    sub $t2, $t2, 48
    mul $t2, $t2, 10
    add $t7, $t2, $t3
    addi $t7, $t7, 48
    beq $t7, $t6, printLine
    addi $t0, $t0, 1
    beq $t6, 323, loop1
    b letter1
    
   
printLine:

    move $s7, $t0 #$s7 now has the day line found
    beq $t9, 1, printSlot
    
    beq $t6, 323, checkAvailability
    addi $t0, $t0, 1
    lb $t1, 0($t0)
    
    beq $t1, 10, Menu
    beq $t1, 0, Menu
    
    li $v0, 11
    move $a0, $t1
    syscall
 
    b printLine
    
viewPerSetDays:	
    #the user enters the number of days to enter and then the user enters day by day and each one is printed when found in calendar
    #user enter number of days to view 
     li $v0, 4
     la, $a0, setDaysInput
     syscall
     
     li $v0, 5
     syscall
     move $k1, $v0 #$k1 has the number of days
     
viewSetDays:
     li $a3, 0
     beqz  $k1, doneDays 
     subi $k1, $k1, 1
     li $a3, 1
     b viewPerDay
     
doneDays: 
     j Menu
     
viewAGivenSlot:
	# the user enters a day and a slot to print all the available existing appointment in that day if found by storing them to an array then printing it 
     li $t9, 1
     b viewPerDay 
     
printSlot:
	#intialize the array to store the appointment in the given slot if found
	la $t1, storeArray
	li $t5, 32
	sw $t5, 0($t1)
	sw $t5, 4($t1)
	sw $t5, 8($t1)
	sw $t5, 12($t1)
	sw $t5, 16($t1)
	sw $t5, 20($t1)
	sw $t5, 24($t1)
	sw $t5, 28($t1)
	sw $t5, 32($t1)
	sw $t5, 36($t1)
	sw $t5, 40($t1)
	sw $t5, 44($t1)
	sw $t5, 48($t1)
	sw $t5, 52($t1)
	sw $t5, 56($t1)
	sw $t5, 60($t1)
	sw $t5, 64($t1)
	sw $t5, 68($t1)	
	sw $t5, 72($t1)	
	sw $t5, 76($t1)	
	sw $t5, 80($t1)	
	
     li $t9, 0
     #user enters first hour of the slot
     
     enterNum1:
     li $v0, 4
     la $a0, firstNum
     syscall
     
     li $v0, 5
     syscall
     move $s2, $v0 #$s2 has the first hour
     addi $s6, $s2, 12
     beq $s6, 18, reenterNum1
     beq $s6, 19, reenterNum1
     ble $s2, 5, add12v1
          
     num2: 
     #user enter number of days to view 
     li $v0, 4
     la $a0, lastNum
     syscall
     
     li $v0, 5
     syscall
     move $s3, $v0 #$s3 has the last hour
     addi $s6, $s3, 12
     beq $s6, 18, reenterNum2
     beq $s6, 19, reenterNum2
     ble $s3, 5, add12v2

     b moveSlot
	
     add12v1:
     addi $s2, $s2, 12     
          b num2
          
     reenterNum1:
     li $v0, 4
     la $a0, wrongHour
     syscall
     b enterNum1
     
     add12v2:
     addi $s3, $s3, 12
          b moveSlot
          
     reenterNum2:
     li $v0, 4
     la $a0, wrongHour
     syscall
     b num2

moveSlot:
    lb $t0, 0($s7) #$t0 has the first char of the line
    
    beq $t0, 10, printSlotRange
    beq $t0, 0, printSlotRange
    
    beq $t0, 76, letterL
    beq $t0, 79, letterOH
    beq $t0, 77, letterM
    
    contRange:
    addi $s7, $s7, 1
    b moveSlot
    
	printSlotRange:
		la $t1, storeArray
		lw $a1, arrayLength

		loopPrint: #print the array to the user 
			lw $a0, 0($t1)
			
			beqz $a0, endLoop
			beq $a0, 79, printLchar
			beq $a0, 76, printOffice
			beq $a0, 77, printMeet
			beq $a0, 72, printHour
			beq $a0, 32, printSpace
			beq $a0, 45, printDash
			bgt $a0, 17, printSpace
			
			# Print the value as an integer
        		li $v0, 1
    	 		syscall
     			b continueLoop
			
		endLoop:
		b Menu
		
	printLchar:
		li $v0, 11
        	li $a0, 79  # ASCII code for 'L'
        	syscall
        	b continueLoop
        
        printOffice:
        	li $v0, 11
        	li $a0, 76  # ASCII code for 'O'
        	syscall
        	b continueLoop
        
        printHour:
        	li $v0, 11
        	li $a0, 72  # ASCII code for 'H'
        	syscall
        	b continueLoop
        
        printMeet:
        	li $v0, 11
        	li $a0, 77  # ASCII code for 'M'
        	syscall
        	b continueLoop
        	
        printSpace:
        	li $v0, 11
        	li $a0, 32  # ASCII code for 'O'
        	syscall
        	b continueLoop
        
        printDash:
        	li $v0, 11
        	li $a0, 45  # ASCII code for 'O'
        	syscall
        	b continueLoop
	
	continueLoop:
		addi $t1, $t1, 4
		subi $a1, $a1, 1
		b loopPrint
		
	
		
letterL:
	li $t4, 0
	subi $t1, $s7, 2 
 	subi $t2, $s7, 4 
 	#10 => 0
	lb $t6, 0($t1) #t1 has the beginning hour
	lb $t7, 0($t2) #t2 has the end hour
	beq $t7, 45, dashCase
	b case1
	
	dashCase:
	subi $t6, $t6, 48
    	subi $t4, $t1, 1
    	
    	lb $t4, 0($t4)
    	subi $t4, $t4, 48
    	mul $t4,$t4, 10
    	#t4 = end time
    	add $t4, $t4, $t6 #$t4 now has the end hour
    	
    	subi $t2, $t2, 1
    	#t6 => 10 => 0
    	lb $t6, 0($t2)
    	subi $t6, $t6, 48 #$t6 has the begin hour if not two digits
    	
    	subi $t2, $s7, 6
    	lb $t7, 0($t2)
    	#t7 => 10 => 1
    	subi $t7, $t7, 48 
    	beq $t7, 1, new1special
    	
    	#if not 2 digits then $t7 is the begin hour
    	move $t7, $t6
    	b continue1
    	
 case1:
 	subi $t6, $t6, 48 #$t6 holds the end hour 
 	#$t7 => 10 => 0
 	subi $t7, $t7, 48
 	
 	#begin hour is 2 digit case
	subi $t2, $s7, 5
    	lb $t3, 0($t2)
    	#t3 => 10 => 1
    	subi $t3, $t3, 48 
    	beq $t3, 1, new1special2
 		
 continue1:
 	la $t1, storeArray #$t1 holds the address of the array to store slot in
 	ble $t7, 5, newAdd12v1
 	#now $t7 has the beginning hour
 	go: 
	beq $t4, 0, moveReg
 	ble $t4, 5, newAdd12v2
 	b start
 
 moveReg: 
 	move $t4, $t6
 	ble $t4, 5, newAdd12v2
 	
 	start: 
 	beq $s0, 1, printOH
 	beq $s1, 1, printM
 	blt $t7, $s2, dontPrint0
 	beq $t7, $s3, endOfL
 	
 	b continuePrint
 	
 	dontPrint0:
 	beq $s2, $t4, endOfL
 	b continuePrint
 	
 	
 	continuePrint:
 	blt $s2, $t7, checkEndHourL
 	bge $s2, $t7, checkEndHourL1
 	

	newAdd12v1:
		addi $t7, $t7, 12
		b go
	newAdd12v2: 
 		addi $t4, $t4, 12
 		b start
printbegin0:
	sw $t7, 0($t1)
	bgt $s3, $t4, printbegin1
	ble $s3, $t4, greaterRange0
	
	checkEndHourL:
 		bge $s3, $t7, printbegin0
 		b endOfL
 		
 	checkEndHourL1:
 		bge $t4, $s2, smallRange0
 		b endOfL
	
printbegin1:
	li $t5, '-'
	sw $t5, 4($t1)
	sw $t4, 8($t1)
	li $t5, ' '
	sw $t5, 12($t1)
	li $t5, 'L'
	sw $t5, 16($t1)
	
	b contRange
	
smallRange0:
	sw $s2, 0($t1)
	bgt $s3, $t4, printbegin1
	ble $s3, $t4, greaterRange0

greaterRange0:
	li $t5, '-'
	sw $t5, 4($t1)
	sw $s3, 8($t1)
	li $t5, ' '
	sw $t5, 12($t1)
	li $t5, 'L'
	sw $t5, 16($t1)
	
	endOfL:
	b contRange
	
new1special:
    # 10 - 12 => t7=10
    mul $t7, $t7, 10
    add $t7, $t7, $t6
    b continue1
    
new1special2:
	# 10 - 1 => $t6=1 & $t7 = 0 & $t3 = 1
	mul $t3, $t3, 10
	add $t7, $t7, $t3 # $t7 has the begin hour $t7 => 10
	b continue1

letterOH:
	li $s0, 1
	li $t4, 0
	b letterL
	
	printOH:
		blt $t7, $s2, dontPrint1
 		beq $t7, $s3, endOfO
 	
 		b continuePrint1
 	
 		dontPrint1:
 		beq $s2, $t4, endOfO
 		b continuePrint1
 	
 	
 		continuePrint1:
		blt $s2, $t7, checkEndHourO
 		bge $s2, $t7, checkEndHourO1
 		
 		checkEndHourO:
 		bge $s3, $t7, printbegin2
 		b endOfO
 		
 		printbegin2:
 		li $t5, ' '
		sw $t5, 20($t1)
		sw $t7, 24($t1)
		bge $s3, $t4, printbegin3
		blt $s3, $t4, greaterRange1
	printbegin3:
		li $t5, '-'
		sw $t5, 28($t1)
		sw $t4, 32($t1)
		li $t5, ' '
		sw $t5, 36($t1)
		li $t5, 'O'
		sw $t5, 40($t1)
		li $t5, 'H'
		sw $t5, 44($t1)
	
	li $s0, 0
		b contRange
		
		checkEndHourO1:
 		bge $t4, $s2, smallRange1
 		b endOfO
		
	smallRange1:
		li $t5, ' '
		sw $t5, 20($t1)
		sw $s2, 24($t1)
		bgt $s3, $t4, printbegin3
		ble $s3, $t4, greaterRange1

	greaterRange1:
		li $t5, '-'
		sw $t5, 28($t1)
		sw $s3, 32($t1)
		li $t5, ' '
		sw $t5, 36($t1)
		li $t5, 'O'
		sw $t5, 40($t1)
		li $t5, 'H'
		sw $t5, 44($t1)
		
	endOfO:
	li $s0, 0
		b contRange
 		
	
letterM:
	li $s1, 1
	li $t4, 0
	b letterL
	
	printM:
		blt $t7, $s2, dontPrint2
 		beq $t7, $s3, endOfM
 	
 		b continuePrint2
 	
 		dontPrint2:
 		beq $s2, $t4, endOfM
 		b continuePrint2
 	
 	
 		continuePrint2:
		blt $s2, $t7, checkEndHourM
 		bge $s2, $t7, checkEndHourM1
 		checkEndHourM:
 		bge $s3, $t7, printbegin4
 		b endOfM
 		
 		printbegin4:
 		li $t5, ' '
		sw $t5, 48($t1)
		sw $t7, 52($t1)
		bgt $s3, $t4, printbegin5
		ble $s3, $t4, greaterRange2
	printbegin5:
		li $t5, '-'
		sw $t5, 56($t1)
		sw $t4, 60($t1)
		li $t5, ' '
		sw $t5, 64($t1)
		li $t5, 'M'
		sw $t5, 68($t1)

	li $s1, 0
		b contRange
		
	checkEndHourM1:
 		bge $t4, $s2, smallRange2
 		b endOfM
 			
	smallRange2:
		li $t5, ' '
		sw $t5, 48($t1)
		sw $s2, 52($t1)
		bgt $s3, $t4, printbegin5
		ble $s3, $t4, greaterRange2

	greaterRange2:
		li $t5, '-'
		sw $t5, 56($t1)
		sw $s3, 60($t1)
		li $t5, ' '
		sw $t5, 64($t1)
		li $t5, 'M'
		sw $t5, 68($t1)
	
	endOfM:
	li $s1, 0
		b contRange

addToLcounter:
    subi $t2, $t0, 2
    subi $t3, $t0, 4
    
    #10 => 0
    lb $t6, 0($t2)
    lb $t7, 0($t3)
    beq $t7, 45, specialCase
    b cont
    
    specialCase:
    	
    	subi $t6, $t6, 48
    	subi $t4, $t2, 1
    	#10 => 1
    	lb $t4, 0($t4)
    	subi $t4, $t4, 48
    	mul $t4,$t4, 10
    	#t4 = end time
    	add $t4, $t4, $t6
    	
    	subi $t3, $t3, 1
    	#t6 => 10 => 0
    	lb $t6, 0($t3)
    	subi $t6, $t6, 48
    	
    	subi $t2, $t0, 6
    	lb $t7, 0($t2)
    	#t7 => 10 => 1
    	subi $t7, $t7, 48
    	beq $t7, 1, special2
    	sub $t7, $t4, $t6
    	beq $s3, 0, addL
	beq $s3, 1, addOH
	beq $s3, 2, addM
    	
        
        addi $t0, $t0, 1
        b readLoop
    	
    cont:	
            subi $t3, $t3, 1
            lb $t3, 0($t3)
            subi $t3, $t3, 48
            beq $t3, 1, special3
            b cont4
            special3:
            	mul $t3, $t3, 10
            	subi $t6, $t6, 48
	   	subi $t7, $t7, 48
	   	add $t7, $t3, $t7
	   	
	   	ble $t6, 5, add12f1
    
	   	add12f1:
	    		addi $t6, $t6, 12
	    	
	    		
	    	 sub $t7, $t6, $t7
	   	 beq $s3, 0, addL
	   	 beq $s3, 1, addOH
	   	 beq $s3, 2, addM
	  	 addi $t0, $t0, 1
	   	 b readLoop
	    
	    cont4:	
		    sub $t7, $t6, $t7
		    beq $s3, 0, addL
		    beq $s3, 1, addOH
		    beq $s3, 2, addM
		    addi $t0, $t0, 1
            	  
		    subi $t6, $t6, 48
		    subi $t7, $t7, 48
    
		    ble $t6, 5, add12f
		
    
		    add12f:
		    	addi $t6, $t6, 12
	    	
		    sub $t7, $t6, $t7
		    beq $s3, 0, addL
		    beq $s3, 1, addOH
		    beq $s3, 2, addM
		    addi $t0, $t0, 1
		    b readLoop
	    
    
addToOHcounter:
    addi $t4, $t4, 1
    
    jr $ra


addToDayCounter:
    addi $k0, $k0, 1
    addi $t0, $t0, 1
    b loop746
    
addToLnumber:
    addi $k1, $k1, 1
    addi $t0, $t0, 1
    b loop746

special2:
    # 10 - 12 => t7=10
    mul $t7, $t7, 10
    add $t7, $t7, $t6
    
    
    
    ble $t7, 5, plus12
    b con1
    
    con1:
    	ble $t4, 5, plus12v2
    	b con2
    
    plus12:
    	addi $t7, $t7, 12
    	b con1
    
    plus12v2:
    	addi $t4, $t4, 12
    	b con2
    
    con2:
    	    sub $t7, $t4, $t7
    	    beq $s3, 0, addL
    	    beq $s3, 1, addOH
	    
	    addi $t0, $t0, 1
	    b readLoop
	    
dayNotFound:
	li $v0, 4
	la $a0, notFoundDay
	syscall
	
	b Menu

addL:
	    add $s2, $s2, $t7
    
	    add $t4, $t4, $t2
    	
	    addi $t0, $t0, 1
	    b readLoop
	    
	    
addOH:
	    add $s4, $s4, $t7
    
	    li $v0, 4
	    la $a0, Lcount
	    #syscall
    
	    add $t4, $t4, $t2
    	
	    addi $t0, $t0, 1
	    b readLoop
	    
addM:
	    add $s5, $s5, $t7
    
	    li $v0, 4
	    la $a0, Lcount
	    #syscall
    
	    add $t4, $t4, $t2
    	
	    addi $t0, $t0, 1
	    b readLoop
	    
twoDigitsAdd: #check two-digit number for the ad appointment case

    #10 => t3 = 0 , t2 = 1 
    subi $s7, $t0, 1
    lb $s3, 0($s7)
    subi $s7, $s7, 1
    lb $s2, 0($s7)
    sub $s3, $s3, 48
    sub $s2, $s2, 48
    mul $s2, $s2, 10
    add $t7, $s2, $s3
    beq $t7, $t2, checkAvailability
    addi $t0, $t0, 1
    b loop1
