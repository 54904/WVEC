WVECRTNSTART ; WVEC Routine Explorer startup
 ;;1.0

START ;
 S U="^"
 S IOF="#,$C(27,91,50,74,27,91,72)"
 S DUZ=8

 D START^WVECNAV("WVECRTN")
 Q
