WVECXREF ; WVEC XINDEX Explorer
 ;;1.0;WORLDVISTA ENGINEERING CONSOLE;;

TEST ;
 N RTN,RTNNM,X,Y

 R !,"Routine: ",RTN:300
 Q:RTN=""

 S RTNNM=RTN

 K ^UTILITY($J)

 ; Build routine list for XINDEX
 S ^UTILITY($J,RTN)=""

 ; Initialize XINDEX environment
 D PARAM^XINDX6
 D HDR^XINDX7
 D BUILD^XINDX7
 D SETUP^XINDX7

 ; Analyze selected routine
 S RTN="$"
 F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  D
 . S INDLC=0
 . D LOAD^XINDEX
 . D BEG^XINDEX

 W !!,"=== SUMMARY ===",!

 ; Metrics
 W !,"Metrics:"
 W !,$G(^UTILITY($J,1,RTNNM,0))

 ; Tags
 W !!,"Tags:"
 S X=""
 F  S X=$O(^UTILITY($J,1,RTNNM,"T",X)) Q:X=""  W !?2,X

 ; External Calls
 W !!,"External Calls:"
 S X=""
 F  S X=$O(^UTILITY($J,1,RTNNM,"X",X)) Q:X=""  D
 . W !?2,X
 . W " -> ",$G(^UTILITY($J,1,RTNNM,"X",X,0))

 ; Globals
 W !!,"Globals:"
 S X=""
 F  S X=$O(^UTILITY($J,1,RTNNM,"G",X)) Q:X=""  D
 . W !?2,X
 . W " -> ",$G(^UTILITY($J,1,RTNNM,"G",X,0))

 ; Locals
 W !!,"Locals:"
 S X=""
 F  S X=$O(^UTILITY($J,1,RTNNM,"L",X)) Q:X=""  D
 . W !?2,X
 . W " -> ",$G(^UTILITY($J,1,RTNNM,"L",X,0))

 W !!
 Q
