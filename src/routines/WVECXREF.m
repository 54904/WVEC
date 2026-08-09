WVECXREF ; WVEC XINDEX Analysis Service
 ;;1.0;WORLDVISTA ENGINEERING CONSOLE;;

 Q

TEST ;
 N RTN

 R !,"Routine: ",RTN:300
 Q:RTN=""

 D ANALYZE(RTN)

 D REPORT(RTN)

 Q
ANALYZE(RTN) ;
 N ROU

 S ROU=RTN
 Q:ROU=""

 K ^UTILITY($J)
 K ^TMP($J,"XREF")

 S ^UTILITY($J,ROU)=""

 D PARAM^XINDX6
 D HDR^XINDX7
 D BUILD^XINDX7
 D SETUP^XINDX7

 S INDLC=0
 S INP(11)=""
 S INP(12)=""

 S RTN=ROU

 D LOAD^XINDEX
 D BEG^XINDEX

 D EXTRACT(ROU)
 Q

EXTRACT(RTN) ;
 N X

 ; Metrics
 S ^TMP($J,"XREF","METRICS")=$G(^UTILITY($J,1,RTN,0))

 ; Tags
 S X=""
 F  S X=$O(^UTILITY($J,1,RTN,"T",X)) Q:X=""  D
 . S ^TMP($J,"XREF","TAG",X)=""

 ; External Calls
 S X=""
 F  S X=$O(^UTILITY($J,1,RTN,"X",X)) Q:X=""  D
 . S ^TMP($J,"XREF","CALL",X)=$G(^UTILITY($J,1,RTN,"X",X,0))

 ; Globals
 S X=""
 F  S X=$O(^UTILITY($J,1,RTN,"G",X)) Q:X=""  D
 . S ^TMP($J,"XREF","GLOBAL",X)=$G(^UTILITY($J,1,RTN,"G",X,0))

 ; Locals
 S X=""
 F  S X=$O(^UTILITY($J,1,RTN,"L",X)) Q:X=""  D
 . S ^TMP($J,"XREF","LOCAL",X)=$G(^UTILITY($J,1,RTN,"L",X,0))

 Q

REPORT(RTN) ;
 N X

 W !!,"=== SUMMARY ===",!

 W !,"Metrics:"
 W !,$G(^TMP($J,"XREF","METRICS"))

 W !!,"Tags:"
 S X=""
 F  S X=$O(^TMP($J,"XREF","TAG",X)) Q:X=""  W !,X

 W !!,"External Calls:"
 S X=""
 F  S X=$O(^TMP($J,"XREF","CALL",X)) Q:X=""  D
 . W !,X
 . W " -> ",$G(^TMP($J,"XREF","CALL",X))

 W !!,"Globals:"
 S X=""
 F  S X=$O(^TMP($J,"XREF","GLOBAL",X)) Q:X=""  D
 . W !,X
 . W " -> ",$G(^TMP($J,"XREF","GLOBAL",X))

 W !!,"Locals:"
 S X=""
 F  S X=$O(^TMP($J,"XREF","LOCAL",X)) Q:X=""  D
 . W !,X
 . W " -> ",$G(^TMP($J,"XREF","LOCAL",X))

 W !!

 Q
TAGS(RTN) ;
 N X

 D ANALYZE(RTN)

 S X=""
 F  S X=$O(^TMP($J,"XREF","TAG",X)) Q:X=""  W !,X

 Q
TAGLIST(RTN,LIST,COUNT) ;
 N X

 K LIST
 S COUNT=0

 D ANALYZE(RTN)

 S X=""
 F  S X=$O(^TMP($J,"XREF","TAG",X)) Q:X=""  D
 . S COUNT=COUNT+1
 . S LIST(COUNT)=X

 Q
LABELLINE(RTN,LABEL) ;
 N I,TXT,FOUND

 S FOUND=0

 F I=1:1 Q:$T(+I^@RTN)=""  D
 . S TXT=$P($T(+I^@RTN)," ")
 . S TXT=$P(TXT,"(")
 . I TXT=LABEL S FOUND=I

 Q FOUND
