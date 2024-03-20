#!/bin/sh

list=$1
wd=$2
t=5 # secs to sleep

i=1
n=$(wc -l $list | cut -f1 -d' ')

mkdir -p $wd

while read line
do
    echo -n "$i/$n ($line)"
    xml=$wd/$line.xml
    esummary -db sra -id "$line" > $xml 2> $xml.log
    if grep -q "DOCTYPE ERROR" $xml
    then
	echo -n " FAILURE"
	rm $xml
    else
	echo -n " SUCCESS"
    fi
    i=$((i+1))
    for j in $(seq 1 $t)
    do
	echo -n "."
	sleep 1
    done
    echo ""
done < $list
