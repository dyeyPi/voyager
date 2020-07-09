#!/bin/bash

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
TOTAL_MEMORY=$( free | grep "Mem:" | awk '{ print $2 }' )
echo $TOTAL_MEMORY

USED_MEMORY=$( free | grep "cache:" | awk '{ print $3 }' ) 
USED_MEMORY_s=5 #test 10, 9, 6, and 5
echo $USED_MEMORY

#input parameters statically set
critValue=0.9 #critical limit in percentage
warnValue=0.6 #warning limit
email="memory@check.com"

#compute actual threshold limits
critThreshold=$(echo|awk "{print $critValue*$TOTAL_MEMORY}")
warnThreshold=$(echo|awk "{print $warnValue*$TOTAL_MEMORY}")
critThreshold_s=9
warnThreshold_s=6

#test variables to be used for conditional checks
echo $critThreshold $warnThreshold $email

function memStat() {
	if [ "$USED_MEMORY_s" -ge "$critThreshold_s" ]; then
		exitMessage 2
	elif [ "$USED_MEMORY_s" -ge "$warnThreshold_s" ]; then
		exitMessage 1
	elif [ "USED_MEMORY_s" ]; then
		exitMessage 0
	else 
		exitMessage "uncaught"
	fi
}

function exitMessage() {
	errorCode=${1}
	echo $errorCode
	
	case "$errorCode" in
		2)
			echo "exit 2, then do *bonus"
			exit 2;;
		1)
			exit 1;;
		0)
			echo "exit 0"
			exit 0;;
		*)
			echo "Check format: -w -c -e required"
	esac
}

memStat


