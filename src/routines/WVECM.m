WVECM ; WorldVistA M Explorer
 ;;1.1;WORLDVISTA ENGINEERING CONSOLE;;

INIT ; Initialize Explorer
 ;
 N RTN,X
 ;
 F  D  Q:RTN]""
 . R !,"Routine: ",X:300
 . I X="^" S RTN="^" Q
 . Q:X=""
 . S RTN=$$UP^XLFSTR(X)
 . S X=RTN
 . X ^%ZOSF("TEST")
 . I '$T D  S RTN=""
 . . W !,"Routine not found.",!
 ;
 I RTN="^" Q
 ;
 S ^TMP($J,"WVECM","START")=RTN
 ;
 D TOP
 Q

TOP ; Return to top level
 ;
 N START
 ;
 S START=$G(^TMP($J,"WVECM","START"))
 ;
 K ^TMP($J,"WVECM")
 ;
 S ^TMP($J,"WVECM","START")=START
 S ^TMP($J,"WVECM","MODE")="ROUTINES"
 ;
 D LIST
 Q

LIST ; Build display
 ;
 N X,N
 N MODE
 ;
 S MODE=$G(^TMP($J,"WVECM","MODE"),"ROUTINES")
 ;
 I MODE="MENU" D MENU Q
 I MODE="LABELS" D LABELS Q
 I MODE="SOURCE" D SOURCE Q
 I MODE="CALLS" D CALLS Q
 ;
 D CLEAR^WVECWS
 K %ZR

 D SILENT^%RSEL("*","SRC")

 N START,FOUND
 S START=$G(^TMP($J,"WVECM","START"))
 S N=0

 I START'="",$D(%ZR(START)) S X=$O(%ZR(START),-1)
 E  S X=""

 F  S X=$O(%ZR(X)) Q:X=""!(N'<500)  D
 . S N=N+1
 . D ADDITEM^WVECWS(N,X,"","R",X)

 D SETSTATE^WVECWS("COUNT",N)
 Q

BUILD ; Build Workspace
 D LIST
 Q

OPEN(NUMBER) ; Open Selected Item
 ;
 N MODE,ITEM,X
 ;
 S MODE=$G(^TMP($J,"WVECM","MODE"),"ROUTINES")
 S ITEM=$$DISPLAY^WVECWS(NUMBER)
 ;
 Q:ITEM=""
 ;
 ; ----- Routine List -----
 I MODE="ROUTINES" D  Q
 . S ^TMP($J,"WVECM","ROUTINE")=ITEM
 . S ^TMP($J,"WVECM","MODE")="MENU"
 . D LIST
 ;
 ; ----- Routine Menu -----
 I MODE="MENU" D  Q
 . I ITEM="Labels" S ^TMP($J,"WVECM","MODE")="LABELS" D LIST Q
 . I ITEM="Source" S ^TMP($J,"WVECM","LABEL")="" S ^TMP($J,"WVECM","MODE")="SOURCE" D LIST Q
 . I ITEM="Calls" S ^TMP($J,"WVECM","MODE")="CALLS" D LIST Q
 . I ITEM="Globals" W !!,"Globals not implemented yet." R !!,"Press RETURN: ",X D LIST Q
 . I ITEM="Variables" W !!,"Variables not implemented yet." R !!,"Press RETURN: ",X D LIST Q
 . I ITEM="Metrics" W !!,"Metrics not implemented yet." R !!,"Press RETURN: ",X D LIST Q
 ;
 ; ----- Label List -----
 I MODE="LABELS" D  Q
 . S ^TMP($J,"WVECM","LABEL")=ITEM
 . S ^TMP($J,"WVECM","MODE")="SOURCE"
 . D LIST
 ;
; ----- Calls -----
 I MODE="CALLS" D  Q
 . N RTN
 . S RTN=$P(ITEM," ")
 . S ^TMP($J,"WVECM","ROUTINE")=RTN
 . K ^TMP($J,"WVECM","LABEL")
 . S ^TMP($J,"WVECM","MODE")="MENU"
 . D LIST
 Q
SELECT(NUMBER)
 Q 1

UP ; Navigate Up
 ;
 N MODE
 ;
 S MODE=$G(^TMP($J,"WVECM","MODE"),"ROUTINES")
 ;
 I MODE="SOURCE" D  Q
 . S ^TMP($J,"WVECM","MODE")="LABELS"
 . D LIST
 ;
 I MODE="CALLS" D  Q
 . S ^TMP($J,"WVECM","MODE")="MENU"
 . D LIST
 ;
 I MODE="LABELS" D  Q
 . S ^TMP($J,"WVECM","MODE")="MENU"
 . D LIST
 ;
 I MODE="MENU" D  Q
 . K ^TMP($J,"WVECM","ROUTINE")
 . K ^TMP($J,"WVECM","LABEL")
 . S ^TMP($J,"WVECM","MODE")="ROUTINES"
 . D LIST
 ;
 I MODE="ROUTINES" D  Q
 . S ^TMP($J,"WVECNAV","TYPE")="WVECEXP"
 . D INIT^WVECEXP
 Q

REFRESH
 D LIST
 Q

HEADER ; Display Header
 ;
 N MODE,RTN,LABEL
 ;
 S MODE=$G(^TMP($J,"WVECM","MODE"),"ROUTINES")
 ;
 W @IOF
 W !,"============================================================"
 W !,"                    WVEC M Explorer"
 W !,"============================================================"
 ;
 I MODE="ROUTINES" D  Q
 . W !,"Location : Routine List"
 . W !
 ;
 I MODE="MENU" D  Q
 . S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 . W !,"Location : Routine Menu"
 . W !,"Routine  : ",RTN
 . W !
 ;
 I MODE="LABELS" D  Q
 . S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 . W !,"Location : Labels"
 . W !,"Routine  : ",RTN
 . W !
 ;
 I MODE="CALLS" D  Q
 . S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 . W !,"Location : Calls"
 . W !,"Routine  : ",RTN
 . W !
 ;
 I MODE="SOURCE" D  Q
 . S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 . S LABEL=$G(^TMP($J,"WVECM","LABEL"))
 . W !,"Location : Source"
 . W !,"Routine  : ",RTN
 . I LABEL'="" W !,"Label    : ",LABEL
 . W !
 ;
 W !,"Location : Unknown"
 Q

MENU ; Build routine menu
 ;
 N RTN
 ;
 S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 ;
 D CLEAR^WVECWS
 ;
 D ADDITEM^WVECWS(1,"Labels","","M","LABELS")
 D ADDITEM^WVECWS(2,"Source","","M","SOURCE")
 D ADDITEM^WVECWS(3,"Calls","","M","CALLS")
 D ADDITEM^WVECWS(4,"Globals","","M","GLOBALS")
 D ADDITEM^WVECWS(5,"Variables","","M","VARIABLES")
 D ADDITEM^WVECWS(6,"Metrics","","M","METRICS")
 ;
 D SETSTATE^WVECWS("TITLE","Routine: "_RTN)
 D SETSTATE^WVECWS("COUNT",6)
 ;
 Q
LABELS ; Build Label List
 ;
 N RTN,I,CNT,LIST
 ;
 S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 ;
 D CLEAR^WVECWS
 ;
 S CNT=0
 D TAGLIST^WVECXREF(RTN,.LIST,.CNT)
 ;
 F I=1:1:CNT D
 . D ADDITEM^WVECWS(I,LIST(I),"","L","")
 ;
 D SETSTATE^WVECWS("TITLE","Labels: "_RTN)
 D SETSTATE^WVECWS("COUNT",CNT)
 ;
 Q
CALLS ; Build Call List
 ;
 N RTN,I,CNT,LIST
 ;
 S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 ;
 D CLEAR^WVECWS
 ;
 S CNT=0
 D CALLLIST^WVECXREF(RTN,.LIST,.CNT)
 ;
 F I=1:1:CNT D
 . D ADDITEM^WVECWS(I,LIST(I),"","C",LIST(I))
 ;
 D SETSTATE^WVECWS("TITLE","Calls: "_RTN)
 D SETSTATE^WVECWS("COUNT",CNT)
 ;
 Q

SOURCE ; Display Source
 ;
 N RTN,LABEL,I,LINE,CNT,START
 ;
 S RTN=$G(^TMP($J,"WVECM","ROUTINE"))
 S LABEL=$G(^TMP($J,"WVECM","LABEL"))
 ;
 D CLEAR^WVECWS
 ;
 S CNT=0
 S START=$S(LABEL="":1,1:0)
 ;
 F I=1:1 D  Q:LINE=""
 . S LINE=$T(+I^@RTN)
 . Q:LINE=""
 . I LABEL'="",$P($P(LINE," "),"(")=LABEL S START=1
 . I 'START Q
 . S CNT=CNT+1
 . D ADDITEM^WVECWS(CNT,$J(I,5)_" "_LINE,"","S","")
 ;
 D SETSTATE^WVECWS("TITLE","Source: "_RTN)
 D SETSTATE^WVECWS("COUNT",CNT)
 ;
 Q
FIND ; Find Text

 N TEXT,I,X,MATCH,PAGE

 Q:$G(^TMP($J,"WVECM","MODE"))'="SOURCE"

 R !!,"Find: ",TEXT:300

 Q:TEXT=""

 S TEXT=$$UP^XLFSTR(TEXT)
 S MATCH=0

 F I=1:1:$$COUNT^WVECWS() D  Q:MATCH
 . S X=$$DISPLAY^WVECWS(I)
 . I $$UP^XLFSTR(X)[TEXT S MATCH=I

 I 'MATCH W !,"Not found." H 2 Q

 S PAGE=((MATCH-1)\$$SIZE^WVECNAV())+1

 D SETPAGE^WVECNAV(PAGE)

 Q
