# change output field separator to "," (default separator (space/tab) '' or '\t'

awk 'BEGIN {OFS = "," ;} {print $1,$2,$3;}' test.dat > out.dat
