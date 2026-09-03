WVECNAV ; WorldVistA Engineering Console Controller
 ;;3.0;WORLDVISTA ENGINEERING CONSOLE;;

 ;===============================================================
 ; Component     : Controller
 ; MVC Role      : CONTROLLER
 ; Specification : ES-006
 ;
 ; Purpose:
 ;     Main application controller.
 ;===============================================================

START ;
 D INIT
 D MAIN
 Q

INIT ;
 ; Initialize workspace
 D INIT^WVECWS

 ; Default renderer
 S ^TMP($J,"WVEC","ACTIVE")="WVECGLOB"

 ; Build initial model
 D REFRESH

 Q

MAIN ;
 N DONE

 S DONE=0

 F  Q:DONE  D
 . D SHOW^WVECDSP
 . D READ^WVECCMD
 . D EXEC(.DONE)

 Q

EXEC(DONE) ;
 N ROOT,TYPE

 S ROOT=$$ROOT^WVECWS()
 S TYPE=$G(@ROOT@("CMD","TYPE"))

 I TYPE="QUIT" S DONE=1 Q

 I TYPE="NEXT" D NEXT Q
 I TYPE="PREV" D PREV Q
 I TYPE="UP" D UP Q
 I TYPE="TOP" D TOP Q
 I TYPE="REFRESH" D REFRESH Q

 I TYPE="SELECT" D SELECT($G(@ROOT@("CMD","NUMBER"))) Q

 Q

ACTIVE() ;
 Q $G(^TMP($J,"WVEC","ACTIVE"),"WVECGLOB")

REFRESH ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D REFRESH^WVECGLOB Q
 I R="WVECRTN" D REFRESH^WVECRTN Q
 I R="WVECKIDS" D REFRESH^WVECKIDS Q

 Q

NEXT ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D NEXT^WVECGLOB Q
 I R="WVECRTN" D NEXT^WVECRTN Q
 I R="WVECKIDS" D NEXT^WVECKIDS Q

 Q

PREV ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D PREV^WVECGLOB Q
 I R="WVECRTN" D PREV^WVECRTN Q
 I R="WVECKIDS" D PREV^WVECKIDS Q

 Q

UP ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D UP^WVECGLOB Q
 I R="WVECRTN" D UP^WVECRTN Q
 I R="WVECKIDS" D UP^WVECKIDS Q

 Q

TOP ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D TOP^WVECGLOB Q
 I R="WVECRTN" D TOP^WVECRTN Q
 I R="WVECKIDS" D TOP^WVECKIDS Q

 Q

SELECT(NUM) ;
 N R
 S R=$$ACTIVE()

 I R="WVECGLOB" D SELECT^WVECGLOB(NUM) Q
 I R="WVECRTN" D SELECT^WVECRTN(NUM) Q
 I R="WVECKIDS" D SELECT^WVECKIDS(NUM) Q

 Q

TEST ;
 D START
 Q

 ;===============================================================
 ; End of WVECNAV
 ;===============================================================
