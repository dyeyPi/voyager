#! /bin/bash

#PSEUDOCODE
#	I/O	system generated > total memory, used memory
#		manual input 	> critical threshold, working threshold, email
#		output 		> case 0, 1, 2 -- email with data *bonus
#	Algorithm
#	1	Get Input ? 2 : 1
#			3 parameters required (manual input)
#	2	Compute c and w ? 3 : 1 
#			Must not exceed total memory
#	3	Compare used memory to c and w
#	 a		used >= crit ? 4(arg =2) : b
#	 b		used >= warn ? 4(arg =1) : c
#	 c		used < warn ? 4(arg = 0)
#	4	Check msg(arg)
#	 a		case 2) ? *optional bonus(args) : 0
#	 b		case *)	 0   
#	0	EXIT

#use hint to determine total_memory
free
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }' )
#echo $TOTAL_MEMORY
			

