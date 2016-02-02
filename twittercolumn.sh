#!/bin/bash

## functions

f_parsing()
{
	LC_ALL=C cut -d ' ' -f9- ~/sample/"$BRANDt".sample | tr ' ' '\n' | grep ^[a-zA-Z0-9] | tr '.' ' ' | tr ')' ' ' | tr ',' ' ' | sed 's/[[:blank:]]//g' | grep -v / > "$BRANDt".temp
}

f_bucket(){	
	while read WORD
	do
		LC_ALL=C grep -i ^$WORD$ "$BRANDt".temp | wc -l | tr -d ":[[:blank:]]:" >> ~/column/"$BRANDt"."$BUCKET"
	done <twittercolumn."$BUCKET"
}

f_control(){
	cd ~/column
	paste Pepsi.$BUCKET2 Nissan.$BUCKET2 Philips.$BUCKET2 Nike.$BUCKET2 IKEA.$BUCKET2 | awk {'print $1+$2+$3+$4+$5'} > ~/column/control.$BUCKET2
}

f_cleanup(){
	rm "$BRANDt".temp
}

## program

while read BRANDt
do
	f_parsing

	while read BUCKET
        do
		f_bucket	
	done <twittercolumn.bucket
	
	f_cleanup

done <twittercolumn.brand


while read BUCKET2
do
	f_control
done <twittercolumn.bucket
