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
BUILD ; Build Workspace
 N MODE,FILE,NAME,COUNT,FIELD

 D CLEAR^WVECWS

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"),"FILES")

 I MODE="FILES" D  Q
 . S COUNT=0
 . S FILE=0
 . F  S FILE=$O(^DIC(FILE)) Q:'FILE  D
 . . S NAME=$P($G(^DIC(FILE,0)),U)
 . . Q:NAME=""
 . . S COUNT=COUNT+1
 . . D ADDITEM^WVECWS(COUNT,NAME,"","FILE",FILE)
 . D SETSTATE^WVECWS("COUNT",COUNT)

 I MODE="FIELDS" D
 . S FILE=+$G(^TMP($J,"WVECNAV","FM","FILE"))
 . S COUNT=0
 . S FIELD=0
 . F  S FIELD=$O(^DD(FILE,FIELD)) Q:FIELD=""  D
 . . Q:FIELD?1A.A
 . . S NAME=$P($G(^DD(FILE,FIELD,0)),U)
 . . Q:NAME=""
 . . S COUNT=COUNT+1
 . . D ADDITEM^WVECWS(COUNT,FIELD_"  "_NAME,"","FIELD",FIELD)
 . D SETSTATE^WVECWS("COUNT",COUNT)
 I MODE="FIELD" D
 . N ZERO,NAME,TYPE,LOC
 . S FILE=+$G(^TMP($J,"WVECNAV","FM","FILE"))
 . S FIELD=$G(^TMP($J,"WVECNAV","FM","FIELD"))
 . S ZERO=$G(^DD(FILE,FIELD,0))
 .
 . S COUNT=0
 .
 . S NAME=$P(ZERO,U)
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Name: "_NAME,"","PROP",NAME)
 .
 . S TYPE=$P(ZERO,U,2)
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Type: "_TYPE,"","PROP",TYPE)
 .
 . S LOC=$P(ZERO,U,4)
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Location: "_LOC,"","PROP",LOC)
 .
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Field Number: "_FIELD,"","PROP",FIELD)
 .
 . D SETSTATE^WVECWS("COUNT",COUNT)
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
UP ;
 N MODE

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"))

 I MODE="FIELD" D  Q
 . K ^TMP($J,"WVECNAV","FM","FIELD")
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"

 I MODE="FIELDS" D  Q
 . K ^TMP($J,"WVECNAV","FM","FILE")
 . S ^TMP($J,"WVECNAV","FM","MODE")="FILES"

 Q
 ;
TOP ;
 K ^TMP($J,"WVECNAV","FM")
 S ^TMP($J,"WVECNAV","FM","MODE")="FILES"
 Q
 ;
VERSION() ;
 Q "1.0"
 ;
HEADER ;
 N MODE,FILE,NAME

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"),"FILES")

 W @IOF
 W !,"============================================================"
 W !,"                  WVEC FileMan Explorer"
 W !,"============================================================"

 I MODE="FIELDS" D
 . S FILE=$G(^TMP($J,"WVECNAV","FM","FILE"))
 . S NAME=$P($G(^DIC(FILE,0)),U)
 . W !,"File #: ",FILE,"   ",NAME

 W !
 Q
 ;
REFRESH ;
 Q
 ;
OPEN(NUMBER) ;
 N MODE,VALUE

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"),"FILES")
 S VALUE=$$DATA^WVECWS(NUMBER)

 I MODE="FILES" D  Q
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"
 . S ^TMP($J,"WVECNAV","FM","FILE")=VALUE

 I MODE="FIELDS" D  Q
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELD"
 . S ^TMP($J,"WVECNAV","FM","FIELD")=VALUE

 Q
 ;
