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

#getInput() using getopts
function getInput(){

	cInput=""
	wInput=""
	eInput=""
	argCount=0
	while getopts "c:w:e:" options; do
			#match -option pattern
			case "$options" in
				c) 
					cInput="$OPTARG"
					((argCount+=1));;
				w)
					wInput="$OPTARG"
					((argCount+=1));;
				e)
					eInput="$OPTARG"
					((argCount+=1));;
				\?) 
					exitMessage "format";;
			esac
	done
	
	#input check for arguments greater than 3	
	if [ $argCount -eq 3 ]; then
		#check for validity of each argument
		if (isNumber $cInput) && (isNumber $wInput) && (isEmail $eInput); then
			#check if critical is greater than warning
			if [ $cInput -gt $wInput ]; then
				memStat $cInput $wInput $eInput
			else
				exitMessage "format"
			fi
		else
			exitMessage "format"
		fi
	else 
		exitMessage "format"
	fi
}


function memStat() {

	critValue=$(echo "scale=1; ${1}/100" | bc)
	warnValue=$(echo "scale=1; ${2}/100" | bc)
	email=${3}

	#total memory check
	TOTAL_MEMORY=$( free | grep "Mem:" | awk '{ print $2 }' )

	#used memory check (without buffers)
	USED_MEMORY=$( free | grep "Mem:" | awk '{ print $3 }' ) 

	#used memory check (including buffers)
	#USED_MEMORY=$( free | grep "cache:" | awk "{ print $3 }" ) 

	#compute actual threshold limits
	critThreshold=$(echo "scale=1; $critValue*$TOTAL_MEMORY" | bc)
	warnThreshold=$(echo "scale=1; $warnValue*$TOTAL_MEMORY" | bc)

        #echo $TOTAL_MEMORY $USED_MEMORY $critValue $critThreshold
	#test variables to be used for conditional checks
	if [ $USED_MEMORY -ge ${critThreshold%.*} ]; then
		exitMessage 2 $email
	elif [ $USED_MEMORY -ge ${warnThreshold%.*} ]; then
		exitMessage 1
	elif (( "USED_MEMORY" )); then
		exitMessage 0
	else 
		exitMessage "uncaught"
	fi	
}

function isNumber(){
	#will check if value is between 0 to 100
	let "difference = ${1} - 1"
	if [ $difference -ge -1 ] && [ $difference -le 99 ]; then
		#echo "got ur number"
		return 0
	else
		return 1
	fi
}

function isEmail(){
	#heuristic check of valid email any@any.com	
	if [[ "${1}" =~ .*\@.*\.com ]]; then
		#echo "got ur email"
		return 0
	else 
		return 1
	fi
}

function sendReport() {
	email=${1}
	echo "$( ps aux | sort -k4 -r | head | awk '{print $2"\t"$4}')" > critLog
	mailx -s "Memory check report" -a ./critLog $email
	exit 2
}

#can be discarded for optimization purposes
function exitMessage() {
	errorCode=${1}
	#echo $errorCode

	case "$errorCode" in
		2)	sendReport ${2};;
		1)	exit 1;;
		0)	exit 0;;
		format)	
			echo "format: ./memory_check -c 90 -w 60 -e user@network.com"
			exit;;
		*)
			exit;;
	esac
}

getInput ${*}
