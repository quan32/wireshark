#!/bin/bash
TARGET_DIR="../pcap"

for entry in "$TARGET_DIR"/*
do
	modDate=$(stat -c %y "$entry")
	modDate=${modDate%% *}
	echo $entry:$modDate
done