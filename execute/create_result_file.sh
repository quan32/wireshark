#!/bin/bash
BASE_FOLDER="../pcap"
SCRIPT_URL="../script/test2.lua"

# main program
echo "----------------running----------------"
for file in $BASE_FOLDER/*
do
	if [[ $file == *"temp"* ]];
	then
		tshark -X lua_script:$SCRIPT_URL -r $file
	fi
done
echo "----------------done----------------"