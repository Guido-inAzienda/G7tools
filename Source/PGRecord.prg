//#INCLUDE "COMMON.CH"
//#INCLUDE "COLLAT.CH"
//#INCLUDE "MEMVAR.CH"
//#INCLUDE "PROMPT.CH"
//#INCLUDE "SET.CH"
//#INCLUDE "STD.CH"
//#INCLUDE "XBP.CH"
//#INCLUDE "FILEIO.CH"

CLASS PGRecord
  EXPORTED:                        

  VAR Table,aField
                 
  METHOD init
  METHOD FieldAdd
  METHOD RecordCommit

  //HIDDEN:                          
  
ENDCLASS

METHOD PGRecord:init(xTable)
 
  ::Table := xTable 

RETURN self

METHOD PGRecord:FieldAdd(xField,bData)       
  
  AAdd(::aField,{xField,bData})  
RETURN self

METHOD PGRecord:RecordCommit(oPostgreSql)
  LOCAL Command1 := "" ,;
        cSupp    := "" ,;
        cLine    := "" ,;
        cPref    := "" ,;
        xVal     := NIL
        
  FOR i := 1 TO Len(::aField)  
    
    IF Empty(lsFie)
      cPref := ""
    ELSE
      cPref := ","
    ENDIF
    
    xVal := Eval(::aField[i,2])
    
    DO CASE
      CASE ValType(xVal)=="C"      
        cSupp := StrTran(AllTrim(xVal),"'","''")
        cLine := ("'"+cSupp+"'")
      CASE ValType(xVal)=="N"
        cLine := Str(xVal)
      CASE ValType(xVal)=="L"
        cLine := IIf(xVal,"TRUE","FALSE")
      CASE ValType(xVal)=="D"    
        IF Empty(xVal)
          cLine := "NULL"
        ELSE
          cLine := "to_date('"+DtoS(xVal)+"','YYYYMMDD')" 
        ENDIF
      CASE ValType(xVal)=="M"   
        cSupp := StrTran(AllTrim(MemoTran(xVal)),"'","''")
        cLine := ("'"+cSupp+"'")
    ENDCASE

    lsFie := lsFie + cPref + AllTrim(::aField[i,1])
    lsVal := lsVal + cPref + cLine

  NEXT  
  
  Command1 := "INSERT INTO "+AllTrim(::Table)+"("+lsFie+") VALUES ("+lsVal+");"     
              
  /*            IF IsDebug() .OR. dfCRWDesign()
                StrFile(cSQLxIns,"cSQLxIns.txt")
              ENDIF
              
              lExec := oPG:exec(cOemToUtf8(cSQLxIns))
              oRes  := oPG:result
              cLine := oPG:errorMessage()    
              
              IF IsDebug() .OR. dfCRWDesign()
                StrFile(cLine,"cSQLxIns_error.txt")
              ENDIF*/

RETURN self
