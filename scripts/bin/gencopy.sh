#!/bin/bash

COPYRIGHT_PREFIX=" * Copyright (C)"
f=$1

last_user="X"
last_sdate="X"
last_edate="X"
while read -r line; do
    auth_user=$(echo "$line" | cut -d"ç" -f1)
    auth_date=$(echo "$line" | cut -d"ç" -f2)

    if [ "$last_user" != "$auth_user" ]; then
        if [ "$last_user" != "X" ]; then
            if [ "$last_edate" == $last_sdate ]; then
                echo "$COPYRIGHT_PREFIX $last_sdate $last_user"
            else
                echo "$COPYRIGHT_PREFIX $last_sdate-$last_edate $last_user"
            fi
        fi
        last_sdate=$auth_date
        last_user=$auth_user
    fi

    last_edate=$auth_date
    last_user=$auth_user
done < <(git log --date=short --pretty=format:"%an ç %ad" "$f" | sed 's/-..-..//' | sort | uniq; echo "-")
