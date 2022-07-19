#!/bin/bash

if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo "This script is here to count words in GUTENBERG EBOOK's format"
	echo "The first argument must be a txt of the ebook and,"
	echo "the second is the number of the most frequent words in the provided txt."
	echo "This script, trusts you too much so it does not check if the txt exists."
	exit 0
fi

declare -A words
filename=$1
flag="false"

while IFS= read -r line; do
    if [[ "$line" == "*** START OF THIS PROJECT GUTENBERG EBOOK"* ]]; then
        flag="true"
        continue
    fi
    
    if [[ "$line" == "*** END OF THIS PROJECT GUTENBERG EBOOK"* ]]; then
        flag="false"
        break
    fi

    if [[ "$flag" == "true" ]]; then
    	
        tmp_line=$(echo $line | sed "s/'[[A-Za-z]]/'/g" |  sed "s/'[[A-Za-z]]/  /g" | sed "s/[[:punct:]]/ /g" | tr '[:upper:]' '[:lower:]')   							 
        
        for word in $tmp_line; do
			
			if [[ $word == "" ]]; then
				continue
			fi
			
			((words[$word]++))
        done
   
    fi

done<"$filename" 


for word in ${!words[@]}
do
    # printing 
    echo $word ${words[$word]}

done | sort -rn -k2 | head -$2