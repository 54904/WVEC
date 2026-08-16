WVECRTN ; WorldVistA Routine Explorer Provider
 ;;1.1;WORLDVISTA ENGINEERING CONSOLE;;
 ;
 ;===============================================================
 ; Component : Routine Explorer Provider
 ; Purpose   : Enumerate M routines for WVEC Navigator
 ;===============================================================
 ;

EN ;
 D START^WVECNAV("WVECRTN")
 Q

TITLE(CTX) ;
 Q "Routine Explorer"

INIT(CTX) ;
 K CTX("ROUTINE")
 S CTX("PAGE")=1
 Q
LIST(CTX,LIST,COUNT) ;
 ;
 N X
 ;
 K LIST
 S COUNT=0
 K %ZR
 D SILENT^%RSEL("*","SRC")
 ;
 S X=""
 F  S X=$O(%ZR(X)) Q:X=""  D
 . S COUNT=COUNT+1
 . S LIST(COUNT)=X
 ;
 Q

SELECT(CTX,ITEM) ;
 S CTX("ROUTINE")=ITEM
 Q

UP(CTX) ;
 K CTX("ROUTINE")
 Q

TOP(CTX) ;
 K CTX("ROUTINE")
 S CTX("PAGE")=1
 Q

NAME(FILE) ;
 ;
 ; Return routine name from a pathname
 ;
 N X

 S X=FILE

 ; Remove directory
 F  Q:X'["/"  S X=$P(X,"/",2,999)

 ; Remove extension
 I X["." S X=$P(X,".",1)

 Q X

TEST ;
 N CTX,LIST,COUNT,I

 D LIST(.CTX,.LIST,.COUNT)

 W !!,"Routine Count: ",COUNT,!!

 F I=1:1:20 Q:'$D(LIST(I))  D
 . W $J(I,4),"  ",LIST(I),!

 Q
BUILD ; Build Workspace
 N CTX,LIST,COUNT,I

 D CLEAR^WVECWS

 S COUNT=0
 D LIST(.CTX,.LIST,.COUNT)

 F I=1:1:COUNT D
 . D ADDITEM^WVECWS(I,LIST(I),"","R",LIST(I))

 D SETSTATE^WVECWS("TITLE","Routine Explorer")
 D SETSTATE^WVECWS("COUNT",COUNT)

 Q
OPEN(NUMBER) ;
 N RTN
 S RTN=$$DISPLAY^WVECWS(NUMBER)
 Q:RTN=""

 S ^TMP($J,"WVECM","ROUTINE")=RTN
 S ^TMP($J,"WVECM","MODE")="MENU"
 S ^TMP($J,"WVECM","PARENT")="WVECRTN"
 K ^TMP($J,"WVECM","LABEL")

 S ^TMP($J,"WVECNAV","TYPE")="WVECM"
 D SETPAGE^WVECNAV(1)
 S ^TMP($J,"WVECNAV","DIRTY")=1

 D LIST^WVECM
 Q
 ;
FIND ; Find Routine
 D BUILD
 N TEXT,I,X,MATCH,PAGE,SIZE
 R !!,"Find: ",TEXT:300
 Q:TEXT=""
 S TEXT=$$UP^XLFSTR(TEXT)
 S MATCH=0
 F I=1:1:$$COUNT^WVECWS() D  Q:MATCH
 . S X=$$DISPLAY^WVECWS(I)
 . I $$UP^XLFSTR(X)[TEXT S MATCH=I
 I 'MATCH W !,"Not found." H 2 Q
 S SIZE=+$G(^TMP($J,"WVECNAV","SIZE"))
 I SIZE<1 S SIZE=20
 S PAGE=((MATCH-1)\SIZE)+1
 D SETPAGE^WVECNAV(PAGE)
 Q
 ;

HEADER ; Display Header
 W @IOF
 W !,"============================================================"
 W !,"                  Routine Explorer"
 W !,"============================================================"
 W !
 Q

VERSION() ;
 Q "1.1"
