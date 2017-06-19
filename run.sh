#!/usr/bin/env bash
# check if res.csv already exists, if so, remove it first
if [ -f res.csv ] ; then
rm res.csv
fi

########concatenate header and content into one output and put into cvs file
######comma in the last column will give problems by splitting into 3 columns instead of one, thus
###### remove comma before inserting into a cvs file
{ curl 'https://in.finance.yahoo.com/quote/GOOG/history?ltr=1' -so - \
| grep -iPo '(?<=<thead data-reactid=)(.*)(?=</thead>)' \
| grep -iPo '<span data-reactid="[1-9][0-9]*">(.*?)</span>' \
| sed -e 's/<[^>]*>//g'; \
curl 'https://in.finance.yahoo.com/quote/GOOG/history?ltr=1' -so - \
| grep -iPo '(?<=<tr class=\"BdT Bdc\(\$lightGray\) Ta\(end\) Fz\(s\)\")(.*)(?=</tr>)' \
| grep -iPo '<span data-reactid="[1-9][0-9]*">(.*?)</span>' \
| sed -e 's/<[^>]*>//g'; } \
| sed 's/[,]//g' \
| awk '{printf "%s,", $0} NR%7==0{print ""}' >> res.csv

exit 0