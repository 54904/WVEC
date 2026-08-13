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
INIT ;
 K ^TMP($J,"WVECNAV","FM")
 S ^TMP($J,"WVECNAV","FM","MODE")="FILES"
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
 . D SETSTATE^WVECWS("COUNT",COUNT)
 . F  S FIELD=$O(^DD(FILE,FIELD)) Q:FIELD=""  D
 . . N ZERO,TYPE,SUBFILE
 . . Q:FIELD?1A.A
 . . S ZERO=$G(^DD(FILE,FIELD,0))
 . . S NAME=$P(ZERO,U)
 . . Q:NAME=""
 . . S TYPE=$P(ZERO,U,2)
 . . I TYPE?1.N.N.E,$D(^DD(+TYPE)) D
 . . . S SUBFILE=+TYPE
 . . . S NAME=NAME_" [MULTIPLE "_SUBFILE_"]"
 . . S COUNT=COUNT+1
 . . D ADDITEM^WVECWS(COUNT,FIELD_"  "_NAME,"","FIELD",FIELD)
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
 I TYPE?1"P".N.E D
 . N TARGET
 . S TARGET=+$E(TYPE,2,99)
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Open File "_TARGET,"","POINTER",TARGET)

 I +TYPE>0,$D(^DD(+TYPE)) D
 . S COUNT=COUNT+1
 . D ADDITEM^WVECWS(COUNT,"Open Subfile "_(+TYPE),"","SUBFILE",+TYPE)

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
UP ;
 N MODE

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"))

 I MODE="FIELD" D  Q
 . K ^TMP($J,"WVECNAV","FM","FIELD")
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"
 I MODE="FIELDS",$D(^TMP($J,"WVECNAV","FM","PARENT")) D  Q
 . S ^TMP($J,"WVECNAV","FM","FILE")=^TMP($J,"WVECNAV","FM","PARENT")
 . K ^TMP($J,"WVECNAV","FM","PARENT")
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"
 . D SETPAGE^WVECNAV(1)

 I MODE="FIELDS" D  Q
 . K ^TMP($J,"WVECNAV","FM","FILE")
 . S ^TMP($J,"WVECNAV","FM","MODE")="FILES"
 . D SETPAGE^WVECNAV(1)

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
 N MODE,VALUE,ITEMTYPE

 S MODE=$G(^TMP($J,"WVECNAV","FM","MODE"),"FILES")
 S VALUE=$$DATA^WVECWS(NUMBER)
 S ITEMTYPE=$$TYPE^WVECWS(NUMBER)
 I ITEMTYPE="SUBFILE" D  Q
 . S ^TMP($J,"WVECNAV","FM","PARENT")=$G(^TMP($J,"WVECNAV","FM","FILE"))
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"
 . S ^TMP($J,"WVECNAV","FM","FILE")=VALUE
 . K ^TMP($J,"WVECNAV","FM","FIELD")
 . D SETPAGE^WVECNAV(1)
 I MODE="FILES" D  Q
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELDS"
 . S ^TMP($J,"WVECNAV","FM","FILE")=VALUE
 . D SETPAGE^WVECNAV(1)

 I MODE="FIELDS" D  Q
 . S ^TMP($J,"WVECNAV","FM","MODE")="FIELD"
 . S ^TMP($J,"WVECNAV","FM","FIELD")=VALUE
 . D SETPAGE^WVECNAV(1)
 ;
FIND ; Find File or Field
 ;
 N TEXT,I,X,MATCH,PAGE
 ;
 R !!,"Find: ",TEXT:300
 Q:TEXT=""
 ;
 S TEXT=$$UP^XLFSTR(TEXT)
 S MATCH=0
 ;
 F I=1:1:$$COUNT^WVECWS() D  Q:MATCH
 . S X=$$DISPLAY^WVECWS(I)
 . I $$UP^XLFSTR(X)[TEXT S MATCH=I
 ;
 I 'MATCH W !,"Not found." H 2 Q
 ;
 S PAGE=((MATCH-1)\$$SIZE^WVECNAV())+1
 ;
 D SETPAGE^WVECNAV(PAGE)
 ;
 Q
