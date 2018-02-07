#!/bin/awk -f

BEGIN {
 sum=0;
}
{
  if($1=="r" && ($3 == "_8_") && ($7 == "cbr"))
  {
    sum = sum + $8;
    print $2, " ", sum*8.0/$2/1000;#unit in bits/sec,time in ms
  }
else if(sum==0)
{print "no data recived";
}
}
