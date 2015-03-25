#!/bin/bash
RESULT_FILE_URL="../result.csv"

# functions
function average_time() {
	file_name=$1
	total_time=0
	average_time=0
	count=0

	while read line
	do
		if [ -z "$line" ];
			then
				continue
			fi

		action_time=$(echo $line | awk '{split($0,a,","); print a[2]}')
		if [ "$action_time" != "average_time" ];
			then
				if [[ "$action_time" != "0" ]];
					then
						count=$((count+1))
						total_time=$(echo $total_time+$action_time | bc)
					fi
			fi
	done < $file_name

	if [[ $count -ne 0 ]];
		then
			average_time=$(echo $total_time/$count | bc -l)
			echo $average_time
		else
			echo -1
		fi
}

# main program
average_time=$(average_time $RESULT_FILE_URL)
echo $average_time