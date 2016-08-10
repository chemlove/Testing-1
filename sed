# print the last line
sed '$!D' test.dat
# print file except the last line
sed '$D' test.dat
# print the file except the first line
sed '1d' test.dat
# print the file except the first and last line
sed '1D;$D' test.dat
# delete the 3rd line & print starting from the 2nd line,
sed '3d; 2,$!D' test.dat
# print starting from the 2th line
sed -n '2,$p' test.dat
# print all lines from 10 to 20
sed -n '10,20p' test.dat ((equivalent to: sed '10,20!d' test.dat))
# print the file except the first 2 lines and last line
sed '1d;2d;$D' test.dat
# print 3rd line
sed -n 3p test.dat

