WVECFM ; WorldVistA FileMan Explorer Provider
 ;;1.0;WORLDVISTA ENGINEERING CONSOLE;;
 ;
 ;---------------------------------------------------------
 ; WorldVistA Engineering Console
 ;
 ; FileMan Explorer Provider
 ;
 ; Provider Interface
 ;   EN
 ;   TITLE()
 ;   INIT()
 ;   LIST()
 ;   SELECT()
 ;   UP()
 ;   TOP()
 ;
 ;---------------------------------------------------------
 ;
EN ;
 Q
 ;
TITLE(CTX) ;
 Q "FileMan Explorer"
 ;
INIT(CTX) ;
 K CTX("STACK")
 S CTX("LEVEL")=0
 S CTX("MODE")="FILES"
 S CTX("PAGE")=1
 K CTX("FILE")
 Q
 ;
BUILD ; Build File List
 N FILE,NAME,COUNT

 D CLEAR^WVECWS

 S COUNT=0
 S FILE=0

 F  S FILE=$O(^DIC(FILE)) Q:'FILE  D
 . S NAME=$P($G(^DIC(FILE,0)),U)
 . Q:NAME=""
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,NAME,FILE,"F")

 D SETSTATE^WVECWS("COUNT",COUNT)

 Q
 ;
LIST(CTX,LIST,COUNT) ;
 N FILE,NAME,U
 S U="^"

 K LIST
 S COUNT=0

 I $G(CTX("MODE"))="FILES" D  Q
 . S FILE=0
 . F  S FILE=$O(^DIC(FILE)) Q:'FILE  D
 . . S NAME=$P($G(^DIC(FILE,0)),U)
 . . Q:NAME=""
 . . S COUNT=COUNT+1
 . . S LIST(COUNT)=FILE_" "_NAME

 Q
 ;
SELECT(CTX,ITEM) ;
 Q
 ;
UP(CTX) ;
 Q
 ;
TOP(CTX) ;
 Q
 ;
VERSION() ;
 Q "1.0"
 ;
HEADER ;
 W @IOF
 W !,"============================================================"
 W !,"                  WVEC FileMan Explorer"
 W !,"============================================================"
 W !
 Q
 ;
REFRESH ;
 Q
 ;
OPEN(NUMBER) ;
 Q
 ;
