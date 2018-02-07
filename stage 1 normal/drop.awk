#!/bin/awk -f

BEGIN {
 sum=0;
}
{
  if(($1=="D")&&($3 == "_3_"))
  {
    sum = sum+1;
    print "Drop @: ",$2;
  }
print "total drop:",sum,"packets";
}

