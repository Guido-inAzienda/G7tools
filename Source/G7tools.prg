// Vedi Help ODBC DatabaseEngine - OdbcManager 
// Vedi Help ODBC DatabaseEngine - Data type mapping su help ODBC
#INCLUDE "COMMON.CH"
#INCLUDE "COLLAT.CH"
#INCLUDE "DIRECTRY.CH"
#INCLUDE "GET.CH"
#INCLUDE "MEMVAR.CH"
#INCLUDE "NATMSG.CH"
#INCLUDE "PROMPT.CH"
#INCLUDE "SET.CH"
#INCLUDE "STD.CH"
#INCLUDE "XBP.CH"
#INCLUDE "DAC.CH"
#INCLUDE "DLL.CH"
#INCLUDE "FILEIO.CH"              
#INCLUDE "ODBCDBE.CH"
#INCLUDE "SQLCMD.CH"

//#DEFINE NULL 0

STATIC __G7PPArea := {}      

FUNCTION G7GetFileName(cTitle,defFile,xSalva,aFileFilters)          
   LOCAL oDlg  := XbpFiledialog():New()
   LOCAL cFile := ""

   oDlg:Title := cTitle
   oDlg:restoreDir = .T.
   IF !Empty(aFileFilters)
     oDlg:fileFilters  := aFileFilters
     oDlg:defExtension := aFileFilters[1,2]
   ENDIF
   oDlg:Create()
   IF Empty(xSalva)
     cFile := oDlg:Open( defFile )
   ELSE
     cFile := oDlg:SaveAs( defFile )
   ENDIF
   oDlg:Destroy()

RETURN cFile

FUNCTION G7Log(Mes,Par,nLog,LogPre,LogPath)
  LOCAL fLog := ""  ,;
        mdFi := 0   ,;
        nHan := 0   ,;
        sInf := ""  ,;
        lRet := .F.
  
  DEFAULT Mes TO "*** MESSAGGIO NON DEFINITO ***"
  DEFAULT Par TO ""
  
  DO CASE
    CASE Empty(nLog)
      fLog := AppName()+".log"
    CASE nLog == 1
      fLog := "OperazioniNonRiuscite.log"
    CASE nLog == 2
      fLog := "AggiornamentoSoftware.log"
      mdFi :=  2
    CASE nLog == 3 //Log per Giorno      
      fLog := AllTrim(LogPre) + DtoS(Date()) + ".log"    
    OTHERWISE  
      fLog := "app.log"
  ENDCASE    
 
  IF FExists(fLog) 
    nHan := FOpen(fLog,FO_READWRITE+FO_DENYWRITE)
  ELSE
    nHan := FCreate(fLog, FC_NORMAL ) 
  ENDIF
  IF nhan > 0
    FSeek(nHan,0,FS_END)
    
    IF mdFi == 2
      sInf := DtoC(Date())+" "+Time()+" "+RTrim(Mes)+RTrim(Par)+Chr(13)+Chr(10)
      IF Len(sInf) > 250
        sInf := sInf + Chr(13)+Chr(10)+"*** FINE RIGA DI LOG MAGGIORE DI 250 CARATTERI***"+Chr(13)+Chr(10)
      ENDIF
    ELSE
      //sInf := DtoC(Date())+" "+Time()+" "+Left(AllTrim(Mes)+Space(40),40)+"-"+Par+Chr(13)+Chr(10)
      sInf := DtoC(Date())+" "+Time()+" "+AllTrim(Mes)+IIf(Empty(Par),"","<<<")+Par+IIf(Empty(Par),"",">>>")+Chr(13)+Chr(10)
    ENDIF
    IF FWrite(nHan,sInf) >= Len(sInf)
      lRet := .T.
    ENDIF
    
    FClose(nHan)
  ENDIF
RETURN lRet

FUNCTION G7FWriteLn(nFile,sRiga)
  LOCAL nHan := 0
    
  IF FExists(AllTrim(nFile)) 
    nHan := FOpen(AllTrim(nFile),FO_READWRITE+FO_DENYWRITE)
  ELSE
    nHan := FCreate(AllTrim(nFile), FC_NORMAL ) 
  ENDIF
  IF nhan > 0
    FSeek(nHan,0,FS_END)
    FWrite(nHan,sRiga+Chr(13)+Chr(10))
    FClose(nHan)
  ENDIF
RETURN NIL

FUNCTION G7Zip2Bin(nFile) //Maschera un file (di sofito .Zip) in un formato proprietario
  LOCAL lRet := .F. ,;
        nHan := 0
        
  nHan := FOpen(nFile,FO_READWRITE+FO_DENYWRITE)
  IF nHan > 0
    FSeek(nHan,0,FS_SET) 
    FWrite(nHan,"G7")
    FClose(nHan)    
    lRet := .T.
  ENDIF
RETURN lRet

FUNCTION G7Bin2Zip(nFile)
// Header del file ZIP da Ripristinare
// p.01 = 80
// p.02 = 75
  LOCAL lRet    := .F. ,;
        nHan    := 0   ,;
        sHeader := Space(2)
        
  nHan := FOpen(nFile,FO_READWRITE+FO_DENYWRITE)
  IF nHan > 0
    FSeek(nHan,0,FS_SET) 
    FRead(nHan,@sHeader,2)
    IF sHeader == "G7"
      FSeek(nHan,0,FS_SET) 
      FWrite(nHan,Chr(80)+Chr(75))
      lRet := .T.
    ENDIF
    FClose(nHan)    
  ENDIF
RETURN lRet

FUNCTION G7TimeFix(xTime,conSS,sepC) //Riformatto una stringa orario di tipo xx:xx:xx  
  LOCAL pHH1 := 0 ,;
        pHH2 := 0
  LOCAL cHH := "00" ,;
        cMM := "00" ,;
        cSS := "00" ,;
        rTT := ""
        
  DEFAULT conSS TO .T.
  DEFAULT sepC  TO ":"
          
  pHH1 :=  At(":",xTime)
  pHH2 := RAt(":",xTime)
    
  IF pHH1<=0 .AND. pHH2<=0 //C'Š solo l'ORA
    cHH := AllTrim(Str(Val(xTime),,0))
  ENDIF
  IF pHH1>0 .AND. pHH1 == pHH2 //C'Š l'ORA ed i MINUTI
    cHH := SubStr(xTime,1,pHH1-1)
    cHH := AllTrim(Str(Val(cHH),,0))
    cMM := SubStr(xTime,pHH1+1)
    cMM := StrZero(Val(cMM),2,0)
    cSS := "00" 
  ENDIF
  IF pHH1>0 .AND. pHH1 != pHH2 //C'Š l'ORA, i MINUTI ed i SECONDI
    cHH := SubStr(xTime,1,pHH1-1)
    cHH := AllTrim(Str(Val(cHH),,0))
    cMM := SubStr(xTime,pHH1+1,pHH2-pHH1-1)
    cMM := StrZero(Val(cMM),2,0)
    cSS := SubStr(xTime,pHH2+1)
    cSS := StrZero(Val(cSS),2,0)
  ENDIF
  
  IF Len(cHH) <= 2
    cHH := AllTrim(StrZero(Val(cHH),2,0))
  ENDIF
  
  rTT := (cHH+sepC+cMM+IIf(conSS,sepC+cSS,""))
  IF Len(xTime) > Len(rTT)
    rTT := G7StrPack(rTT,Len(xTime),,.T.)
  ENDIF  
RETURN rTT

FUNCTION G7Time2Sec(xTime)
  LOCAL xSeconds := 0
  LOCAL pHH1 := 0    ,;
        pHH2 := 0
  LOCAL cHH  := "00" ,;
        cMM  := "00" ,;
        cSS  := "00" 
  
  xTime := G7TimeFix(xTime)

  pHH1 :=  At(":",xTime)
  pHH2 := RAt(":",xTime)
  
  cHH := SubStr(xTime,1,pHH1-1)
  cHH := AllTrim(Str(Val(cHH),,0))
  cMM := SubStr(xTime,pHH1+1,pHH2-pHH1-1)
  cMM := StrZero(Val(cMM),2,0)
  cSS := SubStr(xTime,pHH2+1)
  cSS := StrZero(Val(cSS),2,0)

  xSeconds := Val(cHH)*3600 + ;
              Val(cMM)*60   + ;
              Val(cSS)
    
RETURN xSeconds

FUNCTION G7Sec2Time(xSeconds)
  LOCAL vHH := 0 ,;
        vMM := 0 ,;
        vSS := 0 ,;
        xSS := 0
  LOCAL cHH := "00" ,;
        cMM := "00" ,;
        cSS := "00" 
                
  xSS := xSeconds
  
  vSS := xSS % 60
  xSS := xSS - vSS
  cSS := StrZero(vSS,2,0)
  
  vMM := xSS % 3600
  xSS := xSS - vMM
  vMM := Int(vMM / 60)
  cMM := StrZero(vMM,2,0)
   
  vHH := Int(xSS / 3600)
  cHH := IIf(vHH>=100,Str(vHH,,0),StrZero(vHH,2,0))
                  
RETURN cHH+":"+cMM+":"+cSS

FUNCTION G7TimeGetHelp(oGet,nnPos)
  LOCAL cBuffer := ""
  
  IF M->A==43 .OR. M->A==45
    cBuffer := StrTran(oGet:Buffer,Chr(M->A)," ")
    cBuffer := G7StrPack(AllTrim(Left(cBuffer,(nnPos-2))),(nnPos-2),,.T.) + SubStr(cBuffer,(nnPos-1))
    oGet:Get:SLE:Buffer := cBuffer
    oGet:Buffer         := cBuffer

    oGet:pos := nnPos    
    //oGet:Display()
    //oGet:updateBuffer()
  ENDIF
RETURN NIL

FUNCTION G7TimeValid(xTime,HH24)
  LOCAL pHH1 := 0 ,;
        pHH2 := 0
  LOCAL nHH  := "00" ,;
        nMM  := "00" ,;
        nSS  := "00"
  LOCAL lRet := .T.
  
  DEFAULT HH24 TO .F.
  
  xTime := G7TimeFix(xTime) //Formatto la stringa in un orario di tipo xx:xx:xx
  
  pHH1 := At(":",xTime)
  pHH2 := RAt(":",xTime)

  nHH := Val(SubStr(xTime,1,pHH1-1))
  nMM := Val(SubStr(xTime,pHH1+1,pHH2-pHH1-1))
  nSS := Val(SubStr(xTime,pHH2+1))
   
  //Verifico le ore
  IF HH24
    IF nHH < 0 .OR. nHH > 23
      lRet := .F.
    ENDIF
  ENDIF
  
  IF lRet
    IF nMM < 0 .OR. nMM > 59
      lRet := .F.
    ENDIF
  ENDIF
  
  IF lRet
    IF nSS < 0 .OR. nSS > 59
      lRet := .F.
    ENDIF
  ENDIF  
RETURN lRet

FUNCTION G7TimeAdd(QTempo1,QTempo2,xDiv,xOpe)     
  LOCAL xAdd0 := 0  ,;
        xAdd1 := 0  ,;
        xAdd2 := 0  ,;
        xRet  := ""
  
  DEFAULT xOpe TO "+"             
 
  IF Empty(xDiv)
    xDiv := 1
  ENDIF
  
  DO CASE
    CASE xOpe == "+"
      xAdd1 := G7Time2Sec(QTempo1)
      xAdd2 := G7Time2Sec(QTempo2)/xDiv
      xAdd0 := xAdd1+xAdd2
    CASE xOpe == "-"
      xAdd1 := G7Time2Sec(QTempo1)
      xAdd2 := G7Time2Sec(QTempo2)/xDiv
      xAdd0 := xAdd1-xAdd2
  ENDCASE
                                      
  xRet := G7StrPack(G7Sec2Time(xAdd0),Len(QTempo1),,.T.)
RETURN xRet
    
FUNCTION G7TimeTxV(BaseOMS,xTime,ValoreUN,xDiv) //Riporta il Valore Moltiplicato per il Tempo
  LOCAL vRitorno := 0 ,;
        TimeHH   := 0 ,;
        TimeMM   := 0 ,;
        TimeSS   := 0 
  LOCAL pHH1 := 0 ,;
        pHH2 := 0

  xTime  := AllTrim(xTime)
  pHH1   := At(":",xTime)
  pHH2   := RAt(":",xTime)  
  //xTime  := G7TimeFix(xTime)
  TimeHH := Val(Left(xTime,pHH1-1))
  TimeMM := Val(SubStr(xTime,pHH1+1,2))
  DO CASE
    CASE BaseOMS == "O" //Ore
      vRitorno := TimeHH*ValoreUN + TimeMM*(ValoreUN/60) 
  ENDCASE
RETURN IIf(Empty(xDiv),vRitorno,vRitorno/xDiv)

FUNCTION G7TimeVdT(BaseOMS,ValoreTT,xTime) //Riporta il Valore Diviso per il Tempo
  LOCAL vRitorno := 0 ,;
        TimeHH   := 0 ,;
        TimeMM   := 0 ,;
        TimeSS   := 0 
  LOCAL pHH1 := 0 ,;
        pHH2 := 0
  
  xTime  := AllTrim(xTime)
  pHH1   := At(":",xTime)
  pHH2   := RAt(":",xTime)  
  //xTime  := G7TimeFix(xTime)
  TimeHH := Val(Left(xTime,pHH1-1))
  TimeMM := Val(SubStr(xTime,pHH1+1,2))
  TimeMM := (TimeMM/60*100)/100
  DO CASE
    CASE BaseOMS == "O" //Ore
      vRitorno := ValoreTT/(TimeHH+TimeMM)
  ENDCASE
RETURN vRitorno

FUNCTION G7DateTime2S(xDate,xTime)
  LOCAL StrSer := ""
  
  StrSer := DtoS(xDate) + G7TimeFix(xTime,.T.,"")  
RETURN StrSer  

FUNCTION G7DateTime2DateSec(xDate,xTime)
  LOCAL StrSer := ""
  
  StrSer := DtoS(xDate) + StrZero(G7Time2Sec(xTime),5,0)
RETURN StrSer  

FUNCTION G7DateSec2DateTime(xDateSec)
  LOCAL StrDateTime := "" ,;
        Strdate     := "" ,;
        StrTime     := ""
  
  IF Len(xDateSec)==13   
    
    StrDate := DtoC(StoD(Right(xDateSec,8))) 
    StrTime := G7Sec2Time(Right(xDateSec,5))
    
    StrDateTime := StrDate+StrTime
  ENDIF
RETURN StrDateTime

FUNCTION G7Time2Num(xTime,xBase) //Riporta un Time in Numerico a Base 100
  LOCAL vRitorno := 0 ,;
        TimeHH   := 0 ,;
        TimeMM   := 0 ,;
        TimeSS   := 0 
  LOCAL pHH1 := 0 ,;
        pHH2 := 0
  
  DEFAULT xBase TO 100
  
  xTime  := G7TimeFix(xTime)
  pHH1   := At(":",xTime)
  pHH2   := RAt(":",xTime)  

  TimeHH := Val(Left(xTime,pHH1-1))
  TimeMM := Val(SubStr(xTime,pHH1+1,2))
  TimeMM := (TimeMM/60*100)/xBase

  vRitorno := TimeHH+TimeMM        
  
RETURN vRitorno

FUNCTION G7Num2Time(xTime,lTime) //Riporta un Numerico a Base 100 in Time 
  LOCAL vRitorno := 0 ,;
        TimeHH   := 0 ,;
        TimeMM   := 0 ,;
        TimeSS   := 0 
  LOCAL pHH1 := 0 ,;
        pHH2 := 0
  
  DEFAULT lTime TO 10
  
  pHH1   := Int(xTime)
  pHH2   := xTime-pHH1
  
  TimeHH := G7TimeFix(Str(pHH1,lTime,0))
  TimeMM := pHH2*60/100

  vRitorno := Stuff(TimeHH,Len(TimeHH)-4,2,StrZero(TimeMM,2,0))
  
RETURN vRitorno

FUNCTION G7MemoGetVar(xMemo,xVar,xPackLen)
  LOCAL StrVar := "" ,;
        axMemo := {} ,;
        i      := 0  ,;
        j      := 0

  xMemo  := Upper(MemoTran(xMemo,Chr(13)))
  xVar   := Upper(xVar)
  axMemo := G7Str2Arr(xMemo,Chr(13))
  FOR i := 1 TO Len(axMemo)
    IF xVar+"=" $ axMemo[i]
      j := At("=",axMemo[i])
      StrVar := AllTrim(SubStr(axMemo[i],j+1))
      IF !Empty(xPackLen) //Tratto il risultato come un numero da pacchettizare a DX
        StrVar := StrZero(Val(StrVar),xPackLen,0)
      ENDIF
    ENDIF
  NEXT
RETURN StrVar

FUNCTION G7Str2Arr(xStr,xDiv,xType,aDiv)
  LOCAL aRit := {} ,;
        iDiv := 0  ,;
        sStr := ""    
  LOCAL jDiv := 0  ,;
        sTp  := ""    
  
  DEFAULT xDiv  TO ";"
  DEFAULT aDiv  TO ""
  DEFAULT xType TO .F.
  
  IF xType 
    WHILE Len(xStr) > 0
      jDiv := At(xDiv,xStr)
      IF jDiv > 0
        sTp  := Left(xStr,jDiv-1)  
        xStr := SubStr(xStr,jDiv+1)
      ELSE
        sTp := ""
      ENDIF

      IF     sTp == "~C~"   
        AAdd(aRit,     G7Str2Arr_GetVar(@xStr,xDiv))                      
      ELSEIF sTp == "~M~"
        AAdd(aRit,     G7Str2Arr_GetVar(@xStr,xDiv))                      
      ELSEIF sTp == "~D~"
        AAdd(aRit,CtoD(G7Str2Arr_GetVar(@xStr,xDiv)))                      
      ELSEIF sTp == "~L~"  
        AAdd(aRit, IIf(G7Str2Arr_GetVar(@xStr,xDiv)==".T.",.T.,.F.))                      
      ELSEIF sTp == "~N~"
        AAdd(aRit, Val(G7Str2Arr_GetVar(@xStr,xDiv)))                      
      ELSEIF sTp == "~A~"
        AAdd(aRit,G7Str2Arr(G7Str2Arr_GetArr(@xStr,xDiv,aDiv),xDiv,xType,aDiv))
      ENDIF    
    ENDDO    
    
    //xStr := SubStr(xStr,jDiv+1) 
  ELSE  
    WHILE Len(xStr) > 0
      iDiv := At(xDiv,xStr)
      IF iDiv > 0
        sStr := Left(xStr,iDiv-1)
      ELSE
        sStr := xStr
      ENDIF
  
      AAdd(aRit,sStr)
  
      xStr := SubStr(xStr,iDiv+Len(xDiv))
      IF iDiv <= 0
        xStr := ""
      ENDIF
    ENDDO  
  ENDIF 
RETURN aRit

STATIC FUNCTION G7Str2Arr_GetVar(xStr,xDiv)
  LOCAL cRet := "",;
        iDiv := 0   
        
  iDiv := At(xDiv,xStr)
  IF iDiv > 0
    cRet := Left(xStr,iDiv-1)
    xStr := SubStr(xStr,iDiv+1)
  ELSE
    cRet := xStr
    xStr := ""
  ENDIF    
RETURN cRet

STATIC FUNCTION G7Str2Arr_GetArr(xStr,xDiv,aDiv)
  LOCAL cRet := "",;   
        nApe := 0 ,;
        nChi := 0   
  LOCAL i := 2
  
  IF xStr[1] == aDiv[1]      
    nApe := 1
    WHILE nChi<nApe
      IF xStr[i]==aDiv[1]
        nApe++
      ELSEIF xStr[i]==aDiv[2]
        nChi++
      ENDIF              
      
      i++
    ENDDO  
  ENDIF
  
  cRet := SubStr(xStr,2,i-3)
  xStr := SubStr(xStr,i+1)       
RETURN cRet

FUNCTION G7Arr2Str(xArr,xDiv,NLen,NDec,xType,aDiv)
  LOCAL cRit := "" ,;
        lArr := {} ,;
        i    := 0
  
  DEFAULT xDiv  TO ";"        
  DEFAULT NLen  TO 10
  DEFAULT NDec  TO 0
  DEFAULT aDiv  TO ""
  DEFAULT xType TO .F.
  
  IF !Empty(aDiv) ; xType := .T. ; ENDIF
    
  //Se voglio gestire gli Array annidati devo gestire anche il tipo del dato
  
  lArr := AClone(xArr)
  
  FOR i:=1 TO Len(lArr)
    IF     ValType(lArr[i]) == "C"
      lArr[i] := IIf(xType,"~C~"+xDiv,"")+AllTrim(lArr[i])
    ELSEIF ValType(lArr[i]) == "M"
      lArr[i] := IIf(xType,"~M~"+xDiv,"")+AllTrim(MemoTran(lArr[i]))
    ELSEIF ValType(lArr[i]) == "D"
      lArr[i] := IIf(xType,"~D~"+xDiv,"")+AllTrim(DtoC(lArr[i]))
    ELSEIF ValType(lArr[i]) == "L"  
      IF lArr[i]
        lArr[i] := IIf(xType,"~L~"+xDiv,"")+".T."
      ELSE 
        lArr[i] := IIf(xType,"~L~"+xDiv,"")+".F."
      ENDIF  
    ELSEIF ValType(lArr[i]) == "N"
      lArr[i] := IIf(xType,"~N~"+xDiv,"")+AllTrim(Str(lArr[i],NLen,NDec))
    ELSEIF ValType(lArr[i]) == "A"
      lArr[i] := IIf(xType,"~A~"+xDiv,"")+aDiv[1]+G7Arr2Str(lArr[i],xDiv,NLen,NDec,xType,aDiv)+aDiv[2]
    ENDIF
    cRit += (lArr[i]+IIf(i<Len(lArr),xDiv,""))
  NEXT  
RETURN cRit

FUNCTION G7Arr2Memo(xArr,xDiv)
  LOCAL cRit := "" ,;
        lArr := {} ,;
        i    := 0

  DEFAULT xDiv TO ";"
  
  lArr := AClone(xArr)
  
  FOR i:=1 TO Len(lArr)
    IF ValType(lArr[i]) == "A"
      lArr[i] := G7Arr2Str(lArr[i],xDiv)
    ENDIF
  NEXT  
  
  cRit := G7Arr2Str(lArr,Chr(13)+Chr(10))
RETURN cRit

FUNCTION G7Memo2Arr(cMemo,xDiv) 
  LOCAL cRit := "" ,;
        lArr := {} ,;
        i    := 0

  DEFAULT xDiv TO ";"

  lArr := G7Str2Arr(cMemo,Chr(13)+Chr(10))
  
  FOR i:=1 TO Len(lArr)
    IF ValType(lArr[i]) == "C"
      lArr[i] := G7Str2Arr(lArr[i],xDiv)
    ENDIF
  NEXT    
RETURN lArr

FUNCTION G7StrPack(xStr,xStrLen,xStrFill,posR,cutR)
  LOCAL sRit := ""
  
  DEFAULT posR TO .F.  
  DEFAULT cutR TO .F.
  
  DEFAULT xStrFill TO " "
  DEFAULT xStrLen  TO Len(xStr)
  
  IF ValType(xStrLen) != "N"
    xStrLen := Len(xStrLen)                    
  ENDIF
  
  IF Len(xStr) <= xStrLen
    IF posR
      sRit := Right(Replicate(xStrFill,xStrLen)+AllTrim(xStr),xStrLen)
    ELSE
      sRit := Left(AllTrim(xStr)+Replicate(xStrFill,xStrLen),xStrLen)
    ENDIF
  ELSE
    IF cutR
      sRit = Left(xStr,xStrLen)
    ELSE
      sRit = Right(xStr,xStrLen)
    ENDIF
  ENDIF
  
RETURN sRit

FUNCTION G7IsStrZero(xStr)
  LOCAL lRet := .F.
  
  xStr := AllTrim(xStr)
  IF xStr == Replicate("0",Len(xStr))
    lRet := .T.
  ENDIF
RETURN lRet

//Funzioni di Utilty per Importazione da File di Testo
FUNCTION G7GetStrItem(xStr,xItemMask,sRetSep,cInfo1) 
  //Interpreta una stringa di descrizione di importazione dati 
  //1: Stringa con "@"
  //   es: "@|;|10|C"
  //2: Stringa con "." posizionamento fisso al carattere per caratteri tipo SubStr
  //   es: ".|57|70" oppure ".ToOem|57|70"
  LOCAL sRet   := "" ,;
        xsRet  := "" ,;
        sRSep  := "" ,;
        aField := {} ,;
        xField := ""
  LOCAL aMask    := {} ,;
        aMasks   := {} ,;
        ItemMask := ""
   
  DEFAULT sRetSep TO ""
    
  aMasks := G7Str2Arr(xItemMask,"&")
  
  FOR i:=1 TO Len(aMasks)
    ItemMask := aMasks[i]
    IF !Empty(ItemMask)
      aMask := G7Str2Arr(ItemMask,"|")
    
      IF Left(ItemMask,1) == "@"
        aField := G7Str2Arr(xStr,aMask[2])    
        IF Len(aField) >= Val(aMask[3])
          xField := aField[Val(aMask[3])]
          
          DO CASE
            CASE AllTrim(Upper(aMask[4])) == "C" //Trattato come un campo carattere con doppi apici 
              xField := AllTrim(xField)
              IF (Left(xField,1) == Chr(34) .AND. Right(xField,1) == Chr(34)) .OR. ;
                 (Left(xField,1) == Chr(39) .AND. Right(xField,1) == Chr(39))
                 
                xsRet := AllTrim(SubStr(xField,2,Len(xField)-2))
              ELSE
                xsRet := AllTrim(xField)
              ENDIF
      
            CASE AllTrim(Upper(aMask[4])) == "N"  
              xField := StrTran(xField,",",".")
              xsRet  := Str(Val(xField),20,10)
      
            CASE AllTrim(Upper(aMask[4])) == "L"
              xsRet := SubStr(xField,3)
      
            OTHERWISE
              xsRet := AllTrim(xField)
      
          ENDCASE
        ENDIF
      ELSEIF Left(ItemMask,1) == "."
        SupRit  := SubStr(xStr,Val(aMask[2]),Val(aMask[3]))
        /*IF Upper(SubStr(aMask[1],2)) == "i1" //Informazioni da Memo 1
          aInfo1 := G7Str2Arr(MemoTran(cInfo1,"|"),"|")
          FOR i:=1 TO Len(aInfo1)
            
          NEXT
        ENDIF*/
        
        xsRet := AllTrim(SupRit)
      ELSE
        xsRet := ""
      ENDIF
      IF Upper(SubStr(aMask[1],2)) == "TOOEM" //ToOem
        xsRet := ConvToOemCP(xsRet)
      ENDIF
    ENDIF
    
    sRet  := sRet+sRSep+xsRet
    sRSep := sRetSep
  NEXT
RETURN sRet

FUNCTION G7GetStrMask(xStr,ChrMask,StrMask)
  //Riporta una sringa passata la str origine il carattere da cercare e la maschera 
  //es. G7GetStrItem("1234567890ABCDE","F","PPPPPXXXXXFFFFF") =>> "ABCDE"
  LOCAL StrInfo := "" ,;
        StrPos  := 0  ,;
        StrLen  := 0

  StrPos  := At(ChrMask,StrMask)
  StrMask := SubStr(StrMask,StrPos)
  StrLen  := CountLeft(StrMask,ChrMask)

  StrInfo := SubStr(xStr,StrPos,StrLen)
RETURN StrInfo

FUNCTION G7MakeStrMask(xStr,ChrMask,StrMask)
  LOCAL StrInfo := "" ,;
        StrPos  := 0  ,;
        StrLen  := 0

  StrPos  := At(ChrMask,StrMask)
  StrInfo := SubStr(StrMask,StrPos)
  StrLen  := CountLeft(StrInfo,ChrMask)
  StrInfo := Left(StrInfo,StrLen)

  StrInfo := G7StrPack(AllTrim(xStr),StrLen,,.T.,.T.)  
  StrInfo := Stuff(StrMask,StrPos,StrLen,StrInfo)
RETURN StrInfo


FUNCTION G7dbAreaReset()
  __G7PPArea := {}
RETURN NIL

FUNCTION G7dbAreaPush()
  LOCAL lRet  := .F. ,;
        nArea := 0
        
  nArea := Select() 
  IF nArea > 0 //L'Area Š in uso    
    lRet := .T.
    AAdd(__G7PPArea , { (nArea)->(Alias())     ,;
                        (nArea)->(OrdNumber()) ,;
                        (nArea)->(RecNo())     ,;
                        (nArea)->(Found())      ;
                                               })
  ENDIF   
RETURN lRet

FUNCTION G7dbAreaPop(perAlias) 
  LOCAL lRet   := .T. ,;
        nArea  := 0   ,; 
        iAlias := 0   
  
  DEFAULT perAlias TO .F.
   
  nArea := Select()
  IF nArea > 0 //L'Area Š in uso    
    lRet := .T.

    iAlias := Len(__G7PPArea)
     
    (nArea)->(OrdSetFocus(__G7PPArea[iAlias,2]))
    (nArea)->(     dbGoto(__G7PPArea[iAlias,3]))
    (nArea)->( dbSetFound(__G7PPArea[iAlias,4]))
  
    ARemove(__G7PPArea,iAlias,1)
  ENDIF
RETURN lRet

FUNCTION G7dbAreaLen()
RETURN Len(__G7PPArea)

FUNCTION G7dbAreaArray()
RETURN (__G7PPArea)
             
/*FUNCTION G7dbAreaRestore()
  LOCAL lRet   := .T. ,;
        iAlias := 0

  FOR i:=1 TO Len(__G7PPArea)
    iAlias := Select(__G7PPArea[i,1])
    
    (iAlias)->(dbSetOrder(__G7PPArea[i,2]))
    (iAlias)->(    dbGoto(__G7PPArea[i,3]))
    (iAlias)->(dbSetFound(__G7PPArea[i,4]))
  NEXT   
  
  G7dbAreaReset()   
RETURN lRet*/
                                                
FUNCTION G7dbIsRecord(xP1,xP2,xP3,xP4)
  LOCAL lRet := .F. ,;
        nArea := 0
        
  nArea := Select() 

  (nArea)->(G7dbAreaPush())        
  lRet := (nArea)->(dbSeek(xP1,xP2,xP3,xP4))
  (nArea)->(G7dbAreaPop())            
RETURN lRet

FUNCTION G7TrueName(cFile,AddBS) 
  LOCAL cRet := "" ,;
        cCurDir   := "" ,;
        cCurDrv   := "" ,;
        aCurPath  := {} ,;
        aFilePath := {}

  DEFAULT AddBS TO .F.
  
  cFile := AllTrim(cFile)     
  
  DO CASE  
    CASE Left(cFile,2)=="\\" .OR. SubStr(cFile,2,1)==":" //Percorso Assoluto
      cCurDir    := SubStr(cFile,3)
      cCurDrv    := Left(cFile,2)

      aCurPath   := {}
      aFilePath  := G7Str2Arr(SubStr(cFile,3) ,"\") 
    CASE Left(cFile,1)=="\" .AND. SubStr(cFile,2,1)!="\"
      cCurDir    := CurDir()
      cCurDrv    := CurDrive()
      IF Left(cCurDir,2) == "\\"
        cCurDrv  := "\\"
        aCurPath := G7Str2Arr(SubStr(cCurDir,3),"\")
        aCurPath := {aCurPath[1],aCurPath[2]}
      ELSE
        cCurDrv  := cCurDrv+":"
        cCurDir  := SubStr(cFile,3)
        aCurPath := {}
      ENDIF
      
      aFilePath  := G7Str2Arr(AllTrim(cFile) ,"\")       
    OTHERWISE //Percorso Relativo
      cCurDir    := CurDir()
      cCurDrv    := CurDrive()

      IF Left(cCurDir,2) == "\\"
        cCurDir  := SubStr(cCurDir,3)
        cCurDrv  := "\\"
      ELSE
        cCurDrv  := cCurDrv+":"
      ENDIF

      aCurPath   := G7Str2Arr(cCurDir,"\")
      aFilePath  := G7Str2Arr(AllTrim(cFile) ,"\") 
  ENDCASE
       
  
  FOR i:=1 TO Len(aFilePath)
    DO CASE
      CASE (aFilePath[i] == "." .OR. Empty(aFilePath[i]))
        
      CASE aFilePath[i] == ".."
        ARemove(aCurPath)
        
      OTHERWISE
        AAdd(aCurPath,aFilePath[i])
        
    ENDCASE
  NEXT
  
  cRet := IIf(Right(cCurDrv,1)=="\",cCurDrv,cCurDrv+"\") +G7Arr2Str(aCurPath,"\") + IIf(AddBS,"\","")
RETURN cRet

                      
FUNCTION G7FileNameChk(fName,xChr,nChr)
  LOCAL fNameRet
  LOCAL cCanc := {"\","/",":","*","?","<",">","|",Chr(34)} ,;
        iCanc := 0
     
  DEFAULT xChr TO "_"   
  DEFAULT nChr TO .F.
  
  fNameRet := fName
  
  FOR iCanc:=1 TO Len(cCanc)
    fNameRet := StrTran(fNameRet,cCanc[iCanc],IIf(nChr,Replicate(xChr,iCanc),xChr))
  NEXT     
  
RETURN fNameRet
                                 
FUNCTION G7DirRemove(cDir)
  LOCAL aFiles := {} ,;
        iCanc  := 0
  
  IF lIsDir(cDir)
    cDir := cPathAddBackslash(cDir)
    aFiles := Directory(cDir+"*.*")
    
    AEval( aFiles, { |a| FErase(cDir+a[1]) } )  
    
    DirRemove(cDir)
  ENDIF
  
RETURN NIL
                                 
FUNCTION G7DoW(xData)
  LOCAL nGG := 0
  
  nGG := DoW(xData)
  IF nGG==1
    nGG := 7
  ELSE
    nGG--
  ENDIF  
RETURN nGG                                 
                                 
/*FUNCTION G7dBs_Tooltip(cStr) 
  xRet := ""
  
  IF IsMemVar("dBs_Tooltip") .AND. M->dBs_Tooltip
    
  ENDIF
RETURN xRet*/