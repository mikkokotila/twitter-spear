#!/bin/bash

## functions

f_account()
{
	ACCOUNT=$(echo 7 8 9 | tr ' ' '\n' | shuf -n 1)
	sudo t set active dev_statsit2"$ACCOUNT"
}

f_twitter()
{
	sudo t search all -l -n 640 "$BRAND" > twitterindex.temp
}

f_search()
{
	grep "$DATE" twitterindex.temp >> ~/sample/"$BRAND".sample
}

f_unique()
{
	LC_ALL=C sort -u ~/sample/"$BRAND".sample > twitterindex.temp
	mv twitterindex.temp ~/sample/"$BRAND".sample
}

f_log()
{
	echo -e "$BRAND,$DATE" >> twitterindex.log
}

f_date()
{
	DATE=$(date +"%b %Oe %H")
}

## program

while :
do

	while read BRAND
		do
			f_date
			f_account
			f_twitter
			f_search
			f_unique
			f_log
	done <twittercolumn.brand
done
