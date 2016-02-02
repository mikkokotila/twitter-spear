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
ubuntu@ip-172-31-31-106:~$ cat twitterstats.sh
#!/bin/bash

## function

f_datafile(){
	paste ~/column/"$BRANDs"."$BUCKETs" ~/column/control."$BUCKETs" > data.csv
}

f_spearman(){
	./twitterspear.r > twitterstats.temp
}

f_value(){
        cat twitterstats.temp | head -2 | tail -1  | cut -d ' ' -f3 > twitterindex.temp.$BUCKETs
}

f_log(){
	DATEs=$(date +%d-%m-%H)
	SAMPLESIZE=$(LC_ALL=C wc -l ~/sample/"$BRANDs".sample | cut -d ' ' -f1 | sed 's/[[:blank:]]//g')
	WORDS=$(cat twitterindex.temp.word)
	PERSONAL=$(cat twitterindex.temp.personal)
	ACTION=$(cat twitterindex.temp.verb)  
	echo -e "$DATEs,$BRANDs,$SAMPLESIZE,$WORDS,$PERSONAL,$ACTION" | sed 's/\ /,/g' >> twitterstats.log
}

# f_curl(){
#	
#	STATS=$(cat test | grep data-is-compact | tr '>' '\n' | tr '<' '\n| sed 's/,//' | tr '\n' ',')
#}



f_cleanup(){
	rm twitterindex.temp.* -f
	rm twitterstats.temp -f
}

## program

while read BRANDs
do
	while read BUCKETs
	do
		f_datafile
		f_spearman
		f_value
	done <twittercolumn.bucket

	f_log
	f_cleanup

done <twittercolumn.brand
