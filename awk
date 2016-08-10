# change output field separator to "," (default separator (space/tab) '' or '\t'

awk 'BEGIN {OFS = "," ;} {print $1,$2,$3;}' test.dat > out.dat


# printf, always use printf
# %s, %.2f, \n (similar to C++) 

echo `grep "" FEPanalyze.log` | awk '{printf( "%s %.2f \n %s %.2f \n ", $1, $7, $13, $19)}'
