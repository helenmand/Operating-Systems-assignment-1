filename=$1

while IFS= read -r line; do
    [[ $line =~ ^[[:blank:]]*# ]] && continue

    FILE=$(echo $line | tr -d [[:punct:]] )

    if [ -f "$FILE.txt" ]; then
        if curl -sL --fail $line -o /dev/null; then
            current=$(<$FILE.txt)
            new=$(curl -sL "$line" | md5sum | cut -d ' ' -f 1)

            if [ "$current" != "$new" ]; then
                echo "$line"
                echo "$new" > $FILE.txt
            fi
        else
            echo "Failed" > $FILE.txt
            echo "$line" FAILED
            continue
        fi
        
    else
        if curl -sL --fail $line -o /dev/null; then
            curl -sL "$line" | md5sum | cut -d ' ' -f 1 > $FILE.txt
            echo "$line" INIT
        else
            echo Failed > $FILE.txt
            echo "$line" FAILED
            continue
        fi

    fi    
done<$filename