#INCLUDE "COMMON.CH"
#INCLUDE "COLLAT.CH"
#INCLUDE "MEMVAR.CH"
#INCLUDE "PROMPT.CH"
#INCLUDE "SET.CH"
#INCLUDE "STD.CH"
#INCLUDE "XBP.CH"
#INCLUDE "FILEIO.CH"

STATIC __G7RecArr := {}

FUNCTION G7RecReset()
  
  __G7RecArr := {}               
RETURN NIL

FUNCTION G7RecPush()
  LOCAL aRec  := {} ,;
        nArea := 0  ,;
        i     := 0
        
  nArea := Select() 
  IF nArea > 0 //L'Area Š in uso      
    FOR i:=1 TO (nArea)->(FCount()) 
      AAdd(aRec,{(nArea)->(FieldName(i)),(nArea)->(FieldGet(i))})        
    NEXT       
  ENDIF                         
  
  IF !Empty(aRec)
    AAdd(__G7RecArr,aRec)
  ENDIF
RETURN aRec    

FUNCTION G7RecPop(n1,aEsclusi)
  LOCAL aRec  := {} ,;        
        aFie  := {} ,;
        nArea := 0  ,;
        i     := 0  ,;
        k     := 0
            
  DEFAULT n1 TO 1
  DEFAULT aEsclusi TO {}
            
  nArea := Select() 
  IF nArea > 0 //L'Area Š in uso      
    aFie := {}
    FOR i:=1 TO (nArea)->(FCount()) 
      AAdd(aFie,(nArea)->(FieldName(i)))        
    NEXT       
    
    aRec := G7RecArray()    
    IF Len(aRec) > 0
      FOR i:=n1 TO Len(aRec)  
        k := AScan(aEsclusi,{|x|Upper(AllTrim(x))==Upper(AllTrim(aRec[i]))}) 
        IF k <= 0        
          k := AScan(aFie,{|x|Upper(AllTrim(x))==Upper(AllTrim(aRec[i][1]))}) 
          IF k > 0                                        
            (nArea)->(FieldPut(k,aRec[i][2]))
          ENDIF  
        ENDIF
      NEXT
      ASize(__G7RecArr,Len(__G7RecArr)-1)       
    ENDIF    
  ENDIF                           
RETURN aRec    
                  
FUNCTION G7RecArray(a1)
  LOCAL aRec  := {} 
  
  DEFAULT a1 TO .F.
  
  IF a1
    aRec := __G7RecArr
  ELSEIF Len(__G7RecArr) > 0
    aRec := __G7RecArr[Len(__G7RecArr)]
  ENDIF         
RETURN aRec
