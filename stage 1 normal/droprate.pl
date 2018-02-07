#!/usr/bin/perl

$infile=$ARGV[0];
open (DATA,"<$infile") || die "Opening File $infile Failed";
$ind=0;  
$ct=0;
$y[0]=0;
while (<DATA>) {
    @x = split(' ');
    $temp=$ind+1;
    if($x[2]>$temp)
    {
      $ind=$ind+1;
      $ct=0;
    }
    if ($x[0] eq 'D')
    {	    	
      $ct=$ct+1;
    }  
    $y[$ind]=$ct;
}
$i=0;
foreach $val (@y) {
  print "$i\t$val\n";
  $i=$i+1;
}
close DATA;
exit(0); 
