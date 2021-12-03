#!/bin/bash
mkdir assignments
                                    
tar -xzf "$1"

for i in $(find . -name '*.txt'); do
	
    if [[ ${i: -4} == ".txt" ]]; then
	
    	while IFS='' read -r link || [[ -n "$link" ]]; do
   	
       		[[ "$link" =~ ^[[:space:]]*# ]] && continue
    
            if [[ ${link::5} == "https" ]]; then
                cd assignments; git clone --quiet $link > /dev/null 2> /dev/null
    
                if [ $? -eq 0 ]; then
                    echo "$link Cloning OK" 
                else
                    echo "$link Cloning FAILED"
                fi
                break
            fi
		done<$i
	fi
	cd ..
done

cd assignments

for dir in */; do
	temp=$dir 
	dir=${dir%*/}
	
    echo "${dir##*/}:"	
	
    cd $temp
	
    dir_c=$(find . -mindepth 1 -not -path "*.git*" -type d | wc -l)
	all_c=$(find . -not -path "*.git*" | wc -l)
    txt_c=$(find . -name "*.txt" -not -path "*.git*" | wc -l)
	
	other_c=`expr $all_c - $txt_c - $dir_c - 1`
	
    echo "Number of directories: $dir_c"
	echo "Number of txt files: $txt_c"
	echo "Number of other files: $other_c"
	
    if [[ $other_c != 0 ]] || [[ $dir_c != 1 ]] || [[ $txt_c != 3 ]]; then
		echo "Directory structure is NOT OK."
	else
        # checks if dataA.txt, directory more, dataB.txt and dataC.txt are in the correct locations.
        if [ -e ./dataA.txt ]; then
            
            if [ -d more ]; then
                cd more
            
                if [ -e ./dataB.txt ]; then
            
                    if [ -e ./dataC.txt ]; then
            
                        count_all=$(find . | wc -l)
                        count_all=`expr $other_c - 1`
            
                        if [[ $all_c == 2 ]]; then
                            echo "Directroy structure is OK."
    # testing seperately for every one of the files and the directory  
    # and if one of them is not in the correct position print the
    # appropriate message and continues to the next repository                    
                        else
                            echo "$all_c Directory sturcutre is NOT OK."
                        fi
                    else
                        echo "Directory structure is NOT OK."
                    fi
                else
                    echo "Directory structure is NOT OK."
                fi
                cd ..
            else
                echo "Directory structure is NOT OK."
            fi
        else
            echo "Directory structure is NOT OK."
        fi
	fi
	cd ..
done