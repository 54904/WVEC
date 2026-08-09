WVECNAV ; WorldVistA Engineering Console Navigator
 ;;6.0;WORLDVISTA ENGINEERING CONSOLE;;

 ;===============================================================
 ; Generic Navigator
 ;===============================================================

START(TYPE) ;
 D INIT(TYPE)

 F  Q:$$QUIT()  D
 . I $$DIRTY() D BUILD
 . D RENDER
 . D READ
 . D EXEC

 Q


INIT(TYPE) ;
 K ^TMP($J,"WVECNAV")

 S ^TMP($J,"WVECNAV","TYPE")=TYPE
 S ^TMP($J,"WVECNAV","PAGE")=1
 S ^TMP($J,"WVECNAV","SIZE")=20
 S ^TMP($J,"WVECNAV","DIRTY")=1
 S ^TMP($J,"WVECNAV","QUIT")=0
 D INIT^WVECPROV(TYPE)
 Q
BUILD ; Build Navigation Workspace
 ;
 ; Purpose
 ;   Ask the active provider to build the workspace.
 ;

 D BUILD^WVECPROV($$TYPE())

 D SETDIRTY(0)

 Q

TYPE() ; Return Provider Type
 Q $G(^TMP($J,"WVECNAV","TYPE"))
PAGE() ; Return Current Page
 Q +$G(^TMP($J,"WVECNAV","PAGE"))

SETPAGE(PAGE) ; Set Current Page
 S ^TMP($J,"WVECNAV","PAGE")=+PAGE
 Q

SIZE() ; Return Page Size
 Q +$G(^TMP($J,"WVECNAV","SIZE"))
RENDER ; Render Current Workspace
 ;
 ; Purpose
 ;   Display one page from the workspace.
 ;
 N COUNT
 N CURPAGE
 N PGSIZE
 N FIRST
 N LAST
 N I
 N TOTALPAGES

 D TRACE^WVECDBG("RENDER","ENTER")

 S COUNT=$$COUNT^WVECWS()
 S CURPAGE=$$PAGE()
 S PGSIZE=$$SIZE()

 S FIRST=((CURPAGE-1)*PGSIZE)+1
 S LAST=FIRST+PGSIZE-1

 S TOTALPAGES=COUNT\PGSIZE
 I COUNT#PGSIZE S TOTALPAGES=TOTALPAGES+1
 I TOTALPAGES<1 S TOTALPAGES=1

 ;
 ; Provider owns the screen header
 ;
 D HEADER^WVECPROV($$TYPE())

 D TRACE^WVECDBG("RENDER","HEADER COMPLETE")

 ;
 ; Generic navigator status
 ;
 W "Items    : ",COUNT,"        Page : ",CURPAGE," of ",TOTALPAGES
 W !!
 W "------------------------------------------------------------"
 W !

 ;
 ; Display current page
 ;
 F I=FIRST:1:LAST Q:I>COUNT  D
 . N X
 . S X=$$DISPLAY^WVECWS(I)
 . I $L(X)>70 S X=$E(X,1,67)_"..."
 . W !,$J(I,3),") ",X
 D TRACE^WVECDBG("RENDER","LIST COMPLETE")

 W !!
 W "------------------------------------------------------------"
 W !
 W "N Next   P Prev   T Top   U Up   I Inspect   F Find   R Refresh   Q Quit"
 D TRACE^WVECDBG("RENDER","EXIT")

 Q

READ ; Read Command
 ;
 ; Purpose
 ;   Read one navigator command.
 ;

 R !!,"Select: ",^TMP($J,"WVECNAV","CMD"):300

 Q

EXEC ; Execute Command
 ;
 ; Purpose
 ;   Execute one navigator command.
 ;

 N CMD

 S CMD=$$UP^XLFSTR($G(^TMP($J,"WVECNAV","CMD")))

 I CMD="Q" D  Q
 . S ^TMP($J,"WVECNAV","QUIT")=1
 I CMD="R" D  Q
 . D SETDIRTY(1)
 I CMD="N" D NEXT Q
 I CMD="P" D PREV Q
 I CMD="T" D TOP Q
 I CMD="U" D UP Q
 I CMD="I" D INSPECT^WVECPROV($$TYPE()) Q
 I CMD="F" D FIND^WVECPROV($$TYPE()) Q
 I CMD?1.N D ENTER(+CMD) Q
 Q

NEXT ; Next Page
 D SETPAGE($$PAGE()+1)
 D SETDIRTY(1)
 Q
PREV ; Previous Page
 I $$PAGE()>1 D
 . D SETPAGE($$PAGE()-1)
 . D SETDIRTY(1)
 Q
TOP ; Top Level

 D TOP^WVECPROV($$TYPE())

 D SETDIRTY(1)

 Q
UP ; Up One Level

 D UP^WVECPROV($$TYPE())

 D SETDIRTY(1)

 Q

ENTER(NUMBER) ; Enter Selected Item
 S ^TMPXX($J,"NAV","TYPE")=$$TYPE()
 S ^TMPXX($J,"NAV","NUMBER")=NUMBER
 S ^TMPXX($J,"NAV","BEFORE")=1
 D OPEN^WVECPROV($$TYPE(),NUMBER)
 S ^TMPXX($J,"NAV","AFTER")=1
 D SETDIRTY(1)

 Q

QUIT() ;
 Q +$G(^TMP($J,"WVECNAV","QUIT"))


DIRTY() ;
 Q +$G(^TMP($J,"WVECNAV","DIRTY"))


SETDIRTY(VALUE) ;
 S ^TMP($J,"WVECNAV","DIRTY")=+VALUE
 Q
GLOB ; Global Provider
 D INIT^WVECGLOB
 Q

RTN ; Routine Provider
 D LIST^WVECRTN
 Q

KIDS ; KIDS Provider
 D LIST^WVECKIDS
 Q

FM ; FileMan Provider
 D LIST^WVECFM
 Q
M ; M Explorer
 D INIT^WVECM
 Q
