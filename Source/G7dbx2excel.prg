#INCLUDE "Common.ch"
#INCLUDE "ActiveX.ch"
#INCLUDE "Excel.ch"
#INCLUDE "dbStruct.ch"
#INCLUDE "Dll.ch"

//#DEFINE xlMaximized  -4137

FUNCTION G7dbx2excel(adbArea,cExcelModello,cExcelSalva,aInformazioni,ExcelChiudi,ExcelVisibile,ForzaOO)
  LOCAL lRet := .F.

  DEFAULT ForzaOO TO .F.

  IF !ForzaOO .AND. G7dbx2xlsMS(adbArea,cExcelModello,cExcelSalva,aInformazioni,ExcelChiudi,ExcelVisibile)
    lRet := .T.    
  ELSE
    lRet := G7dbx2xlsOO(adbArea,cExcelModello,cExcelSalva,aInformazioni,ExcelChiudi,ExcelVisibile)               
  ENDIF
RETURN lRet

STATIC FUNCTION G7dbx2xlsOO(adbArea,cExcelModello,cExcelSalva,aInformazioni,ExcelChiudi,ExcelVisibile)
  //  Esporta su OO Calc

  LOCAL oOO
  LOCAL oCoreReflection
  LOCAL oDesktop
  LOCAL oSheets
  LOCAL oSheet 
  LOCAL aSheetCanc := {} 
  LOCAL oDocument
  LOCAL oColumns
  LOCAL aBooleans  := {} ,;
        aDates     := {}
  
  LOCAL aVuoto       := VTType():New( {}, VT_ARRAY+VT_VARIANT )
  LOCAL aSheet       := {} ,;
        aSheetRec    := {} ,;
        nSheet       := "" ,;
        iSheet       := 0  ,;
        nR := 0 , nC := 0  ,;
        nHDim:= 0, nVDim := 0
  LOCAL aStruttura   :=  {},;
        aXlsStruttura:=  {},;
        aIStruttura  :=  {},;
        aTemp        :=  {},;
        idInfoSheet  := ""
  LOCAL i:=0,j:=0,k:=0     ,;
        numCampi     := 0  
  LOCAL _dbOrigine   := 0 
  LOCAL cRet         := "" ,;
        Par1,Par2 
  LOCAL bPrevHandler 
  LOCAL lRet         := .T.
     
  DEFAULT ExcelChiudi   TO .F.
  DEFAULT ExcelVisibile TO .T.

  bPrevHandler := ERRORBLOCK({|objError|NewErrorHandler(objError,bPrevHandler)})
   
  BEGIN SEQUENCE

    oOO := CreateObject("com.sun.star.ServiceManager")
    IF !Empty(oOO)
  
      oCoreReflection := oOO:createInstance("com.sun.star.reflection.CoreReflection")
      oDesktop        := oOO:createInstance("com.sun.star.frame.Desktop")
      
      IF FExists(cExcelModello)
        oDocument := oDesktop:loadComponentFromURL(Path2SURL(cExcelModello) , "_blank", 0, aVuoto)
      ELSE
        oDocument := oDesktop:loadComponentFromURL("private:factory/scalc"  , "_blank", 0, aVuoto )
        k := oDocument:getSheets():getCount()
        FOR i:=0 TO k-1
          AAdd(aSheetCanc,oDocument:getSheets():getByIndex(i):getName())
        NEXT
      ENDIF
  
      //Create a sheet      
      oSheets = oDocument:getSheets()
            
      k := oDocument:getSheets():getCount()
      FOR i:=0 TO k-1
        AAdd(aSheet,oDocument:getSheets():getByIndex(i):getName())
      NEXT
      
      IF ValType(adbArea) != "A" 
        IF ValType(adbArea) == "C" 
          adbArea := {adbArea}
        ELSE
          adbArea := {""}
        ENDIF
      ENDIF
      idInfoSheet := Upper(adbArea[1])
  
      FOR i:=1 TO Len(adbArea)
      
        _dbOrigine := Select(adbArea[i])
        
        IF !Empty(_dbOrigine)         
          aStruttura := (_dbOrigine)->(dbStruct())
          AAdd(aStruttura,NIL) ; AIns(aStruttura,1,{ "_numRec", "N", 10, 0})      
          
          //Crea il foglio di lavoro necessario
          
          nSheet := Alias(_dbOrigine)+"_db"        
          
          iSheet := AScan(aSheet, {|x| Upper(AllTrim(x))==Upper(nSheet)} )
          
          //se non lo trova lo crea
          IF iSheet <= 0 
            oSheet := oSheets:insertNewByName(nSheet, Len(aSheet)) 
            AAdd(aSheet,nSheet)
            iSheet := Len(aSheet)
            oSheet := oSheets:getByIndex(iSheet - 1) 
          ELSE
            oSheet := oSheets:getByIndex(iSheet - 1) 
          ENDIF
          
          IF !Empty(oSheet)
            
            (_dbOrigine)->(dbGoTop())
            
            nR := 2
                      
            nHDim        := (_dbOrigine)->(FCount()  + 1)
            nVDim        := (_dbOrigine)->(LastRec() + 1)
            aSheetRec    := Array(nHDim,nVDim)
            
            oColumns := oSheet:getColumns()
            
            aDates := {}
            aBooleans := {}
            
            WHILE !(_dbOrigine)->(Eof())   
              aSheetRec[1,nR] := (_dbOrigine)->(RecNo())
              FOR nC := 1 TO nHDim - 1
                  DO CASE
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "C"
                        aSheetRec[nC+1,nR] := AllTrim((_dbOrigine)->(FieldGet(nC)))
                        
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "M"
                        aSheetRec[nC+1,nR] := AllTrim(MemoTran((_dbOrigine)->(FieldGet(nC))))
                        
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "D" 
                        //date
                        IF AScan(aDates, {|x| x==nC }) <= 0
                          AAdd(aDates,nC)
                        ENDIF
                        
                        IF Year((_dbOrigine)->(FieldGet(nC))) < 1900 // Verifica di non registrare Date inferiori al 1900 altrimenti Excel si pianta
                          aSheetRec[nC+1,nR] :=DtoS(CtoD(""))
                        ELSE
                          aSheetRec[nC+1,nR] :=DtoC((_dbOrigine)->(FieldGet(nC)))
                        ENDIF
                        
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "L"   
                        //logici
                        IF AScan(aBooleans, {|x| x==nC }) <= 0
                          AAdd(aBooleans,nC)
                        ENDIF
                        
                        aSheetRec[nC+1,nR] := IIF((_dbOrigine)->(FieldGet(nC)),1,0)
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "N"
                        aSheetRec[nC+1,nR] := (_dbOrigine)->(FieldGet(nC))  
                      OTHERWISE
                        aSheetRec[nC+1,nR] := (_dbOrigine)->(FieldGet(nC))
                  ENDCASE 
              NEXT
              nR++
              (_dbOrigine)->(dbSkip())
            ENDDO
            
            //inserisco i dati
            
            FOR b:=1 TO Len(aBooleans)
              oColumns:getByIndex(aBooleans[b]):setPropertyValue( "NumberFormat", 99 )
            NEXT
            FOR b:=1 TO Len(aDates)
              oColumns:getByIndex(aDates[b]):setPropertyValue( "NumberFormat", 36 )
            NEXT
            
            oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+AllTrim(Str(nVDim,,0))):setDataArray(VTType():New( aSheetRec, VT_ARRAY+VT_VARIANT ))
            
            //inserisco i nomi delle colonne
            aXlsStruttura := Array(nHDim)
            FOR nC:=1 TO Len(aStruttura)
              aXlsStruttura[nC] := {aStruttura[nC,1]}
            NEXT
                      
            oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+"1"):setDataArray(VTType():New( aXlsStruttura,  VT_ARRAY+VT_VARIANT ))
            //oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+AllTrim(Str(nVDim,,0))):AutoFit()
          ENDIF
        ENDIF
      NEXT
      
      //Export dell'Array informazioni nei relativi Fogli XLS
      IF ValType(aInformazioni) == "A"
        FOR i:=1 TO Len(aInformazioni)
          IF ValType(aInformazioni[i]) == "A"            
            numCampi := 0
            AEval(aInformazioni[i],{|x| numCampi := IIF(Len(x)>numCampi,Len(x),numCampi)}) //Cerca il numero di campi da scrivere
            
            aIStruttura := {"_numRec"} //Campi fissi nella struttura 
            FOR j:=1 TO (numCampi)                    //Aggiunge i campi Informazione
              AAdd(aIStruttura,"_Info"+AllTrim(Str(j,10,0)))
            NEXT
  
            //Crea il foglio di lavoro necessario
            nSheet := idInfoSheet+"_info"+AllTrim(Str(i,,0))
            iSheet := AScan(aSheet, {|x| Upper(AllTrim(x))==Upper(nSheet)} )
            IF iSheet <= 0 
              oSheets:insertNewByName(nSheet, Len(aSheet)) 
              AAdd(aSheet,nSheet)
              iSheet := Len(aSheet)
              oSheet := oSheets:getByIndex(iSheet - 1) 
            ELSE
              oSheet := oSheets:getByIndex(iSheet - 1) 
            ENDIF
                      
            IF !Empty(oSheet)
              nVDim := Len(aInformazioni[i]) + 1
              nHDim := numCampi + 1
              aSheetRec    := Array(nHDim,nVDim)
              
              FOR nR:= 1 TO Len(aInformazioni[i])                 
                aSheetRec[1,nR+1] := nR              
                FOR nC := 1 TO numCampi                
                  IF nC > Len(aInformazioni[i][nR])
                    aSheetRec[nC+1,nR+1] := ""
                  ELSE
                    aSheetRec[nC+1,nR+1] := aInformazioni[i][nR][nC]
                  ENDIF
                NEXT
              NEXT
            
            //inserisco i dati
            oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+AllTrim(Str(nVDim,,0))):setDataArray(VTType():New( aSheetRec, VT_ARRAY+VT_VARIANT ))
            
            //inserisco i nomi delle colonne
            aXlsStruttura := Array(nHDim)
            FOR nC:=1 TO Len(aIStruttura)
              aXlsStruttura[nC] := {aIStruttura[nC]}
            NEXT
                      
            oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+"1"):setDataArray(VTType():New( aXlsStruttura,  VT_ARRAY+VT_VARIANT ))
            //oSheet:getCellRangeByName("A1:"+calcolaCellaHXls(nHDim)+"1"):AutoFit()
            
            ENDIF
          ENDIF
        NEXT         
      ENDIF
      
      IF FExists(cExcelModello)
        oSheet := oSheets:getByIndex(0) 
      ENDIF
      
      FOR i:=1 TO Len(aSheetCanc)
        oSheets:removeByName(aSheetCanc[i])        
      NEXT

      IF !Empty(cExcelSalva)
        /*aSaveArgs:=Array(2)  
        aSaveArgs[1]:=oOO:Bridge_GetStruct("com.sun.star.beans.PropertyValue")
        aSaveArgs[1]:Name  = "FilterName" 
        aSaveArgs[1]:Value = ".ods"
        aSaveArgs[2]:=oOO:Bridge_GetStruct("com.sun.star.beans.PropertyValue")
        
        AAdd(aSaveArgs,oOO:Bridge_GetStruct("com.sun.star.beans.PropertyValue"))
        aSaveArgs[1]:Name  = "FilterName" 
        aSaveArgs[1]:Value = "MS Excel 97" 
        oDocument:storeToURL("file:///"+cExcelSalva+".ods", VTType():New(aSaveArgs, VT_ARRAY+VT_VARIANT) )*/


        IF Upper(Right(cExcelSalva,4)) != ".ODS"
          cExcelSalva := AllTrim(cExcelSalva)+".ODS"
        ENDIF
        
        oDocument:storeAsURL(Path2SURL(cExcelSalva),aVuoto)        
        
        //cRet := oDocument:callMethod("storeToURL",Par1,aSaveArgs)
      ENDIF
  
      /*IF ExcelChiudi
        oDocument:Quit()
      ENDIF */
      
      oCoreReflection:destroy()
      oDesktop:destroy()
      oDocument:destroy()
      oOO:destroy()    
    ELSE
      lRet := .F.
    ENDIF
  
  RECOVER 
    lRet := .F.

  ENDSEQUENCE
    
  ERRORBLOCK(bPrevHandler) //Ripristina il Vecchio Gestore di Errori

RETURN lRet


STATIC FUNCTION G7dbx2xlsMS(adbArea,cExcelModello,cExcelSalva,aInformazioni,ExcelChiudi,ExcelVisibile)
  // Esporta su MS Excel

  LOCAL oExcel, oBook, oSheet
  LOCAL aSheet       := {} ,;
        aSheetRec    := {} ,;
        aSheetCanc   := {} ,;
        nSheet       := "" ,;
        iSheet       := 0  ,;
        nR := 0 , nC := 0  ,;
        nHDim:= 0, nVDim := 0
  LOCAL aStruttura   := {} ,;
        aXlsStruttura:= {} ,;
        aIStruttura  := {} ,;
        aTemp        :=  {},;
        idInfoSheet  := ""
  LOCAL i:=0,j:=0,k:=0     ,;
        numCampi     := 0  
  LOCAL _dbOrigine   := 0 
  LOCAL lRet         := .T.
  
  LOCAL bPrevHandler 
   
  DEFAULT ExcelChiudi   TO .F.
  DEFAULT ExcelVisibile TO .T.

  bPrevHandler := ERRORBLOCK({|objError|NewErrorHandler(objError,bPrevHandler)})
   
  BEGIN SEQUENCE

    oExcel := CreateObject("Excel.Application")     
    IF !Empty(oExcel)
      oExcel:DisplayAlerts := .F.
      oExcel:Visible       := ExcelVisibile
      //oExcel:windowState   := xlMaximized
      //__SetForegroundWindow( oExcel:hwnd )
  
      IF FExists(cExcelModello)
        oBook := oExcel:Workbooks:Open(cExcelModello)
      ELSE
        oBook := oExcel:Workbooks:Add()
        k := oBook:WorkSheets:Count
        FOR i:=1 TO k
          AAdd(aSheetCanc,oBook:WorkSheets(i):Name)
        NEXT
      ENDIF
      
      k := oBook:WorkSheets:Count
      FOR i:=1 TO k
        AAdd(aSheet,oBook:WorkSheets(i):Name)
      NEXT
      
      IF ValType(adbArea) != "A" 
        IF ValType(adbArea) == "C" 
          adbArea     := {adbArea}
        ELSE
          adbArea := {""}
        ENDIF
      ENDIF
      idInfoSheet := Upper(adbArea[1])
  
      FOR i:=1 TO Len(adbArea)
      
        _dbOrigine := Select(adbArea[i])
        
        IF !Empty(_dbOrigine)         
          aStruttura := (_dbOrigine)->(dbStruct())
          AAdd(aStruttura,NIL) ; AIns(aStruttura,1,{ "_numRec", "N", 10, 0})      
          
          //Crea il foglio di lavoro necessario
          nSheet := Alias(_dbOrigine)+"_db"
          iSheet := AScan(aSheet, {|x| Upper(AllTrim(x))==Upper(nSheet)} )
          IF iSheet <= 0 
            oBook:WorkSheets:Add(,oBook:WorkSheets(Len(aSheet))):Name := nSheet
            AAdd(aSheet,nSheet)
            iSheet := Len(aSheet)
          ENDIF
          oBook:WorkSheets(iSheet):Activate()
          oSheet := oBook:ActiveSheet 
          
          IF !Empty(oSheet)
            (_dbOrigine)->(dbGoTop())
            
            nR := 2
            
            nHDim        := (_dbOrigine)->(FCount()  + 1)
            nVDim        := (_dbOrigine)->(LastRec() + 1)
            
            aSheetRec    := Array(nVDim,nHDim)
            aSheetRec[1] := Array(nHDim)
            
            WHILE !(_dbOrigine)->(Eof())   
              FOR nC:=1 TO nHDim - 1
                  DO CASE
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "C"
                        aSheetRec[nR,nC] := "'"+AllTrim((_dbOrigine)->(FieldGet(nC)))
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "M"
                        aSheetRec[nR,nC] := "'"+AllTrim(MemoTran((_dbOrigine)->(FieldGet(nC))))
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "D" .AND. Year((_dbOrigine)->(FieldGet(nC))) < 1900 // Verifica di non registrare Date inferiori al 1900 altrimenti Excel si pianta
                        aSheetRec[nR,nC] := CtoD("") 
                      CASE ValType((_dbOrigine)->(FieldGet(nC))) == "N"
                        aSheetRec[nR,nC] := (_dbOrigine)->(FieldGet(nC))                    
                      OTHERWISE
                        aSheetRec[nR,nC] := (_dbOrigine)->(FieldGet(nC))
                  ENDCASE 
              NEXT
              AIns(aSheetRec[nR],1, (_dbOrigine)->(RecNo()))
              
              nR++
              (_dbOrigine)->(dbSkip())
            ENDDO
            
            //inserisco intestazione riga 1
            /*FOR j:=1 TO Len(aSheetRec[1])
              aSheetRec[1][j] := "'"+aStruttura[j][1]
            NEXT*/
            
            //inserisco i dati
            oSheet:Range("A1",calcolaCellaHXls(nHDim)+AllTrim(Str(nVDim,,0))):Value := aSheetRec
            
            //inserisco i nomi delle colonne
            aXlsStruttura := Array(nHDim)
            FOR nC:=1 TO Len(aStruttura)
              aXlsStruttura[nC] := "'"+aStruttura[nC,1]
            NEXT
            oSheet:Range("A1",calcolaCellaHXls(nHDim)+"1"):Value := aXlsStruttura
            
            //autofit delle colonne
            oSheet:Range("A1",calcolaCellaHXls(nHDim)+"1"):EntireColumn:AutoFit
            
          ENDIF
        ENDIF
      NEXT
      
      //Export dell'Array informazioni nei relativi Fogli XLS
      IF ValType(aInformazioni) == "A"
        FOR i:=1 TO Len(aInformazioni)
          IF ValType(aInformazioni[i]) == "A"            
            numCampi := 0
            AEval(aInformazioni[i],{|x| numCampi := IIF(Len(x)>numCampi,Len(x),numCampi)}) //Cerca il numero di campi da scrivere
              
            aIStruttura := {"_numRec"} //Campi fissi nella struttura 
            FOR j:=1 TO (numCampi)                    //Aggiunge i campi Informazione
              AAdd(aIStruttura,"_Info"+AllTrim(Str(j,10,0)))
            NEXT
  
            //Crea il foglio di lavoro necessario
            nSheet := idInfoSheet+"_info"+AllTrim(Str(i,,0))
            //nSheet := "_info"+AllTrim(Str(i,,0))
            iSheet := AScan(aSheet, {|x| Upper(AllTrim(x))==Upper(nSheet)} )
            IF iSheet <= 0 
              oBook:WorkSheets:Add(,oBook:WorkSheets(Len(aSheet))):Name := nSheet
              AAdd(aSheet,nSheet)
              iSheet := Len(aSheet)
            ENDIF
            oBook:WorkSheets(iSheet):Activate()
            oSheet := oBook:ActiveSheet 
                      
            IF !Empty(oSheet)
              
              FOR c:= 1 TO Len(aInformazioni[i])
                aTemp := aInformazioni[i][c]
                AAdd(aTemp,"")
                aInformazioni[i][c] := AIns(aTemp,1,c)
              NEXT
              
              nVDim := Len(aInformazioni[i]) 
              nHDim := numCampi
              
              oSheet:Range("A2",calcolaCellaHXls(nHDim+1)+AllTrim(Str(nVDim+1,,0))):Value := aInformazioni[i]
             
              oSheet:Range("A1",calcolaCellaHXls(Len(aIStruttura))+"1"):Value := aIStruttura
            
              //autofit delle colonne
              oSheet:Range("A1",calcolaCellaHXls(Len(aIStruttura))+"1"):EntireColumn:AutoFit
              
            ENDIF
          ENDIF
        NEXT         
      ENDIF
      
      FOR i:=1 TO Len(aSheetCanc)
        oBook:WorkSheets(aSheetCanc[i]):Delete()
      NEXT

      IF FExists(cExcelModello)
        oBook:WorkSheets(1):Activate()   
      ENDIF
      
      IF !Empty(cExcelSalva)
        IF Val(oExcel:Version) < 12  //Sono dal 2003 in giu
          IF Upper(Right(cExcelSalva,4)) != ".XLS"
            cExcelSalva := AllTrim(cExcelSalva)+".XLS"
          ENDIF
        ELSE
          IF Upper(Right(cExcelSalva,5)) != ".XLSX"
            cExcelSalva := AllTrim(cExcelSalva)+".XLSX"
          ENDIF
        ENDIF
        
        IF FExists(cExcelModello)
          oBook:Save()
        ELSE  
          oBook:SaveAs(cExcelSalva,xlWorkbookNormal)         
        ENDIF
      ENDIF
      IF ExcelChiudi
        oExcel:Quit()
      ELSE
        oExcel:Visible := .T.
      ENDIF 
      oExcel:Destroy()
    ELSE
      lRet := .F.
    ENDIF
    
  RECOVER 
    lRet := .F.
    
  ENDSEQUENCE
    
  ERRORBLOCK(bPrevHandler) //Ripristina il Vecchio Gestore di Errori
RETURN lRet

/*STATIC FUNCTION calcolaCellaHXls(dim)
  //Calcola la lettera della cella in orizonatle per excel con ingresso il numero della colonna

  LOCAL sRet := ""
  LOCAL aWord := Array(26)
  LOCAL nResto := 0,;
        nCount := 0
  
  aWord[1]  := "A"
  aWord[2]  := "B"
  aWord[3]  := "C"
  aWord[4]  := "D"
  aWord[5]  := "E"
  aWord[6]  := "F"
  aWord[7]  := "G"
  aWord[8]  := "H"
  aWord[9]  := "I"
  aWord[10] := "J"
  aWord[11] := "K"
  aWord[12] := "L"
  aWord[13] := "M"
  aWord[14] := "N"
  aWord[15] := "O"
  aWord[16] := "P"
  aWord[17] := "Q"
  aWord[18] := "R"
  aWord[19] := "S"
  aWord[20] := "T"
  aWord[21] := "U"
  aWord[22] := "V"
  aWord[23] := "W"
  aWord[24] := "X"
  aWord[25] := "Y"
  aWord[26] := "Z"
  
  IF dim <= 26
    sRet := aWord[dim]  
  ELSE
    nCount := dim / 26    
    nResto := dim % 26
    sRet := aWord[nCount]+IIf(nResto>0,aWord[nResto],"")
  ENDIF
  
RETURN sRet */

FUNCTION calcolaCellaHXls( i )

  LOCAL cAlpha := "ABCDEFGHIJKLMNOPQRSTUVWXYZ", cLastRow := ""
  
  IF i > 26
    cLastRow := Substr(cAlpha,Int(i/26),1) + Substr(cAlpha,Mod(i,26),1)
  ELSE
    cLastRow := Substr(cAlpha,i,1)
  ENDIF

RETURN cLastRow

STATIC FUNCTION Path2SURL(xStr)
  
  xStr := StrTran(xStr,":","|")
  xStr := StrTran(xStr,"\","/")
RETURN "file:///"+xStr

STATIC FUNCTION NewErrorHandler(objError,bPrevHandler)    // error routine - Non controllo errorri mentre sono nella procedura di esportazione
  BREAK
RETURN .F.

DLLFUNCTION __SetForegroundWindow( nHwnd ) USING STDCALL FROM USER32.DLL

/*FUNCTION createStruct( oCoreReflection, cTypeName )

    LOCAL oClass  := oCoreReflection:forName( cTypeName )
    LOCAL oStruct := VTType():New( 0, VT_DISPATCH )      // ???

    oClass:createObject( oStruct )

RETURN oStruct*/





/*

      oExcel := CreateObject("Excel.Application")
      IF Empty( oExcel )
         dbMsgErr( "Excel NON Š installato!" )
         Break
      ENDIF

      // Avoid message boxes such as "File already exists". Also,
      // ensure the Excel application is visible.
      oExcel:DisplayAlerts := .F.
      oExcel:Visible       := .F.

      oBook  := oExcel:workbooks:Add()

      // lascio solo il primo foglio
      DO WHILE oBook:Sheets():Count() > 1
         oBook:sheets(2):delete()
      ENDDO

      oSheet := oBook:ActiveSheet
      oSheet:PageSetup:Orientation := xlLandscape

      aStruct := Tabella->(ddFileStruct())
      nCOLMax := LEN(aStruct) 
      FOR nCol := 1 TO nCOLMax
          oSheet:Cells(1,nCol):Value := Alltrim(aStruct[nCol][DBS_ALEN+2])
          IF aStruct[nCol][DBS_TYPE] == "N"
             IF aStruct[nCol][DBS_DEC] > 0
                oSheet:Columns( nCol ):NumberFormat := "0."+Replicate("0",aStruct[nCol][DBS_DEC] )
             ELSE
                oSheet:Columns( nCol ):NumberFormat := "00000000"
             ENDIF
          ELSE
             oSheet:Columns( nCol ):NumberFormat := "000000"
          ENDIF
          oSheet:Columns( nCol ):AutoFit()
      NEXT

      FOR nRow := 1 TO LEN(aTagdiRECORD)
                   _ADDROW(oSheet,aTagANAG[nRow], nRow+1, nCOLMax )
      NEXT

      oSheet:Cells(nRow+2,1):Value := notefiltro
      oBook:SaveAs( cFile, xlWorkbookNormal )

      oExcel:Quit()
      oExcel:Destroy()





STATIC FUNCTION _ADDROW(oSheet,nRecNO, nRow, nCOLMax )
  LOCAL nCol := 1

  IF nRow <= 0 .OR. EMPTY(nRecNO)
    RETURN NIL
  ENDIF

  IF TABELLA->(dbgoto(nRecNO))
    FOR nCol := 1 TO nCOLMax
      oSheet:Cells(nRow,nCol):Value := TABELLA->(FIELDGET(nCol))
    NEXT
  ENDIF
RETURN NIL*/

