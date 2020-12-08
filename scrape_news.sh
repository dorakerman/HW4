#!/bin/bash

echo "Starting..."
wget https://www.ynetnews.com/category/3082
#Use grep and sort to get all the links and sort them to appear only once.
#Store links in a different file.
grep -o -E '(https://www.ynetnews.com/article/)([a-z]|[0-9]|[A-Z]){9}("|#)+'\
 3082 | sort -u | sed 's/"//' | sed 's/#//' > list_of_pages.txt

#grep -o -E '(https://www.ynetnews.com/article/)([a-z]|[0-9]|[A-Z])+("|#)+' 3082\
#	| sort -u | sed 's/"//' |sed 's/#//'> list_of_pages.txt

#Count and store number of lines in result file.
wc -l list_of_pages.txt | sed 's/list_of_pages.txt//' > results.csv
#Each line is a link, the loop goes over all of them. 
while read line
do
	wget -O temp_content.txt $line
	bibi_num=$(grep -o 'Netanyahu' temp_content.txt | wc -l)
	gantz_num=$(grep -o 'Gantz' temp_content.txt | wc -l)
	#If both names do not appear, insert - sign.
	if [ "$bibi_num" -eq 0 ] && [ "$gantz_num" -eq 0 ]; then
		echo "${line}, -">>results.csv
	else
		echo "${line}, Netanyahu, ${bibi_num}, Gantz, ${gantz_num}">>results.csv
	fi
done<list_of_pages.txt

#Now we remove the files that were created by the program, so they dont appear
# in the folder at the end. This is optional.
rm temp_content.txt
rm 3082
rm list_of_pages.txt
