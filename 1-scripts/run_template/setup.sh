#!/bin/bash
for (( i = 0; i < 15; i++ )); do

    DIR=f$i
	if [ ! -d "$DIR" ]; then
        mkdir f$i
	fi
    echo "$i out of 50"
done
mkdir f_out_0 
