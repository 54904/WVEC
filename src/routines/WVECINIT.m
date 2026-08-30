WVECINIT ; WVEC initialization

INIT ;
 S U="^"
 S DTIME=9999

 ; VT100 defaults
 S IOST="C-VT100"
 S IOST(0)=9
 S IOM=80
 S IOSL=24
 S IOF="#,$C(27,91,50,74,27,91,72)"
 Q
