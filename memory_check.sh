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

while getopts "c:w:e:" options; do
		#match -option pattern
		case "$options" in
			c) 
				cInput="$OPTARG";;
			w)
				wInput="$OPTARG";;
			e)
				eInput="$OPTARG";;
			\?) 
				exitMessage "format";;
		esac
done

	#check instance of each argument's occurence by length - not null
	if [ ${#cInput} -gt 0 ] && [ ${#wInput} -gt 0 ] && [ ${#eInput} -gt 0 ]; 
	then

		#check for validity of each argument
		if (isNumber $cInput) && (isNumber $wInput) && (isEmail $eInput); 
		then
			memStat $cInput $wInput $eInput
		else
			exitMessage "format"
		fi
	else 
		exitMessage "format"
	fi
}


function memStat() {

critValue=$(echo|awk "{print ${1}/100}")
warnValue=$(echo|awk "{print ${2}/100}")
email=${3}

#total memory check
TOTAL_MEMORY=$( free | grep "Mem:" | awk '{ print $2 }' )

#used memory check (without buffers)
USED_MEMORY=$( free | grep "Mem:" | awk '{ print $3 }' ) 

#used memory check (including buffers)
#USED_MEMORY=$( free | grep "cache:" | awk '{ print $3 }' ) 

#compute actual threshold limits
critThreshold=$(echo|awk "{print $critValue*$TOTAL_MEMORY}")
warnThreshold=$(echo|awk "{print $warnValue*$TOTAL_MEMORY}")
free
echo $TOTAL_MEMORY $USED_MEMORY $critThreshold

#test variables to be used for conditional checks
echo $critThreshold $warnThreshold $email

	if (("$USED_MEMORY" >= "$critThreshold")); then
		exitMessage 2
	elif (( "$USED_MEMORY" >= "$warnThreshold" )); then
		exitMessage 1
	elif (( "USED_MEMORY" )); then
		exitMessage 0
	else 
		exitMessage "uncaught"
	fi
}

function isNumber(){
	#will check if value is between 0 to 100
	let "difference = "${1}" - 1"
	if [ $difference -ge 0 ] && [ $difference -le 99 ]; then
		return 0
	else
		return 1
	fi
}

function isEmail(){
	#heuristic check of valid email any@any.com
	if [[ "${1}" =~ .*\@.*\.com ]]; then
		echo "hmm"
		return 0
	else 
		return 1
	fi
}

function exitMessage() {
	errorCode=${1}
	echo $errorCode
	
	case "$errorCode" in
		2)	echo "exit 2, then do *bonus";	exit 2;;
		1)	exit 1;;
		0)	exit 0;;
		*)	echo "format: ./memory_check -c 90 -w 60 -e user@network.com"
			exit;;
	esac
}

getInput ${*}
