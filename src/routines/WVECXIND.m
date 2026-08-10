WVECXIND ; WVEC XINDEX Debug
 ;;1.0;WORLDVISTA ENGINEERING CONSOLE;;

TEST ;
 N RTN

 K ^UTILITY($J)

 ; Queue one routine for analysis
 S ^UTILITY($J,"WVECNAV")=""

 ; Initialize XINDEX parameters
 D PARAM^XINDX6

 ; Initialize XINDEX environment
 D SETUP^XINDX7

 ; Process queued routines
 S RTN="$"

A S RTN=$O(^UTILITY($J,RTN))
 Q:RTN=""

 ; Required by BEG^XINDEX
 S INDLC=(RTN?1"|"1.4L.NP)

 ; Load source into ^UTILITY($J,1,...)
 D LOAD^XINDEX

 ; Analyze routine
 D BEG^XINDEX

 G A

DONE ;
 W !!,"DONE - RESULTS PRESERVED",!
 Q
