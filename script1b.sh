filename=$1

checker(){

    FILE=$(echo $1 | tr -d [[:punct:]] )

    if [ -f "$FILE.txt" ]; then
        if curl -sL --fail $1 -o /dev/null; then
            current=$(<$FILE.txt)
            new=$(curl -sL "$1" | md5sum | cut -d ' ' -f 1)

            if [ "$current" != "$new" ]; then
                echo "$1"
                echo "$new" > $FILE.txt
            fi
        else
            echo "$1" FAILED
            echo "Failed" > $FILE.txt
            continue
        fi
        
    else
        if curl -sL --fail $1 -o /dev/null; then
            echo "$1" INIT
            curl -sL "$1" | md5sum | cut -d ' ' -f 1 > $FILE.txt
        else
            echo "$1" FAILED
            echo Failed > $FILE.txt
            continue
        fi

    fi  
}


while IFS= read -r line; do
    [[ $line =~ ^[[:blank:]]*# ]] && continue

    checker $line &

done<$filename 