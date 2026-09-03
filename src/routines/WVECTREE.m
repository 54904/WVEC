WVECTREE ; WorldVistA Engineering Console Tree Manager
 ;;1.4;WORLDVISTA ENGINEERING CONSOLE;;

 ;=============================================================
 ; WVECTREE
 ;
 ; Maintains navigation state for hierarchical browsers.
 ;
 ; Public API
 ;   INIT
 ;   OPEN(ROOT)
 ;   OPENNODE(SUB)
 ;   CURRENT()
 ;   LEVEL()
 ;   ROOT()
 ;   PATH()
 ;   TOP
 ;   POP
 ;   SHOW
 ;   TEST
 ;
 ;=============================================================

ROOT() ;
 Q $G(^TMP($J,"WVEC","TREE","ROOT"))

CURRENT() ;
 Q $G(^TMP($J,"WVEC","TREE","CURRENT"))

LEVEL() ;
 Q +$G(^TMP($J,"WVEC","TREE","LEVEL"))

ROOTNAME() ;
 Q $$ROOT()

INIT ;
 K ^TMP($J,"WVEC","TREE")
 Q

OPEN(ROOT) ;
 ;
 ; Open a new tree.
 ;
 D INIT

 I $E(ROOT,$L(ROOT))="(" S ROOT=$E(ROOT,1,$L(ROOT)-1)


 S ^TMP($J,"WVEC","TREE","ROOT")=ROOT
 S ^TMP($J,"WVEC","TREE","LEVEL")=0
 D UPDATE
 Q

OPENNODE(SUB) ;
 ;
 ; Public interface to descend one level.
 ;
 D PUSH(SUB)
 Q

PUSH(SUB) ;
 N LVL

 S LVL=$$LEVEL()+1
 S ^TMP($J,"WVEC","TREE","PATH",LVL)=SUB
 S ^TMP($J,"WVEC","TREE","LEVEL")=LVL

 D UPDATE
 Q
POP ;
 N LVL

 S LVL=$$LEVEL()
 S ^TMPXX($J,"POP","BEFORE")=$$LEVEL()

 Q:LVL=0

 K ^TMP($J,"WVEC","TREE","PATH",LVL)
 S ^TMP($J,"WVEC","TREE","LEVEL")=LVL-1
 S ^TMPXX($J,"POP","AFTER")=$$LEVEL()

 D UPDATE
 Q

TOP ;
 K ^TMP($J,"WVEC","TREE","PATH")
 S ^TMP($J,"WVEC","TREE","LEVEL")=0

 D UPDATE
 Q

UPDATE ;
 D SETCURR($$PATH())
 Q

SETCURR(REF) ;
 S ^TMP($J,"WVEC","TREE","CURRENT")=REF
 Q

PATH() ;
 N LVL,P,I

 S LVL=$$LEVEL()

 I LVL=0 Q $$ROOTNAME()

 F I=1:1:LVL S P(I)=^TMP($J,"WVEC","TREE","PATH",I)

 Q $$FORMAT^WVECREF($$ROOTNAME(),.P,LVL)

BREAD() ; Return breadcrumb string
 ;
 N LVL,I,S

 S S=$$ROOT()

 S LVL=$$LEVEL()
 I LVL=0 Q S

 F I=1:1:LVL D
 . S S=S_" > "_$$DISPLAY(^TMP($J,"WVEC","TREE","PATH",I))

 Q S

DISPLAY(X) ;
 ; Display one path component.
 ;
 I X'="",+X=X Q X
 Q """"_X_""""

SHOW ;
 W !
 W "Root    : ",$$ROOT(),!
 W "Current : ",$$CURRENT(),!
 W "Level   : ",$$LEVEL(),!
 W "Path    : ",$$PATH(),!
 Q

