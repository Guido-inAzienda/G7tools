// Vedi Help ODBC DatabaseEngine - OdbcManager 
// Vedi Help ODBC DatabaseEngine - Data type mapping su help ODBC
#INCLUDE "COMMON.CH"
#INCLUDE "COLLAT.CH"
#INCLUDE "GET.CH"
#INCLUDE "DLL.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "ODBCDBE.CH"
#INCLUDE "SQLCMD.CH"

#DEFINE NULL 0

PROCEDURE G7odbc2excel(cExcel,aInformazioni,bFiltro)
   LOCAL cConnect     := "" ,;
         aStruttura   := {} ,;
         aIStruttura  := {}
   LOCAL i:=0,j:=0,k:=0     ,;
         numCampi     := 0  ,;
         TentaExport  := .T.,;
         retFiltro    := .T.
   LOCAL _dbOrigine   := 0 
   
   _dbOrigine = Select()
    
   WHILE TentaExport
     TentaExport = .F.
     cConnect := "DBE=ODBCDBE;DSN=Excel Files;ReadOnly=0;UID=;PWD=;DBQ="
     cConnect += cExcel
  
     oSession := DacSession():new(cConnect)
     IF oSession:isConnected()
       
       //Export del DB Origine nel foglio di XLS
       aStruttura := (_dbOrigine)->(dbStruct())

       AAdd(aStruttura,NIL) ; AIns(aStruttura,1,{ "_numRec", "F", 0, 0})
       FOR i:=1 TO len(aStruttura) //Cambia la mappatura dei Tipi per la connessione ODBC
         DO CASE
           CASE aStruttura[i,2] == "C"
             aStruttura[i,2] := "M"
           CASE aStruttura[i,2] == "N"
             aStruttura[i,2] := "F"
         ENDCASE
       NEXT
       
       dbCreate(Alias(_dbOrigine)+"_db",aStruttura,"ODBCDBE")
       
       dbUseArea( .T. , "ODBCDBE",Alias(_dbOrigine)+"_db","_dbDesti", .T. , .F.) 
       IF Select("_dbDesti") > 0
         _dbDesti->(DbInfo(ODBCDBO_UNIQUE_FIELDS, {1}))
     
         (_dbOrigine)->(dbGoTop())
         DO WHILE !(_dbOrigine)->(Eof())   
           retFiltro := .T.       
           IF !Empty(bFiltro) .AND. ValType(bFiltro)=="C" //Il filtro Š stato passato come Stringa da convertire
             retFiltro := (_dbOrigine)->(Eval( &("{||"+bFiltro+"}") ))
             IF ValType(retFiltro) != "L"
               retFiltro := .T.
             ENDIF
           ENDIF          
           IF retFiltro
             _dbDesti->(dbAppend())
             _dbDesti->(FieldPut(1, (_dbOrigine)->(RecNo())))
             FOR i:=1 TO (_dbOrigine)->(FCount())
               IF ValType((_dbOrigine)->(FieldGet(i))) == "M"
                 _dbDesti->(FieldPut(i+1, MemoTran((_dbOrigine)->(FieldGet(i)))))
               ELSE
                 IF ValType((_dbOrigine)->(FieldGet(i))) == "D" .AND. Year((_dbOrigine)->(FieldGet(i))) < 1900 // Verifica di non registrare Date inseriori al 1900 altrimenti Excel si pianta
                   _dbDesti->(FieldPut(i+1, CToD("") ))
                 ELSE
                   _dbDesti->(FieldPut(i+1, (_dbOrigine)->(FieldGet(i))))
                 ENDIF
               ENDIF
             NEXT
           ENDIF
           (_dbOrigine)->(dbSkip())
         ENDDO
         dbCloseArea("_dbDesti")
       ENDIF
       
       //Export dell'Array informazioni nei relativi Fogli XLS
       IF ValType(aInformazioni) == "A"
         FOR i:=1 TO len(aInformazioni)
           IF ValType(aInformazioni[i]) == "A"            
             numCampi := 0
             AEval(aInformazioni[i],{|x| numCampi := iif(len(x)>numCampi,len(x),numCampi)}) //Cerca il numero di campi da scrivere
             
             aIStruttura := {{ "_numRec", "F",   0,0}} //Campi fissi nella struttura 
             FOR j:=1 TO (numCampi)                    //Aggiunge i campi Informazione
               aadd(aIStruttura,{ "_Info"+alltrim(str(j,10,0)) , "M", 255,0})
             NEXT

             dbCreate(Alias(_dbOrigine)+"_info"+alltrim(str(i,,0)),aIStruttura,"ODBCDBE")
             dbUseArea( .T. , "ODBCDBE",Alias(_dbOrigine)+"_info"+alltrim(str(i,,0)),"_dbDesti", .T. , .F.) 
             IF Select("_dbDesti") > 0
               _dbDesti->(DbInfo(ODBCDBO_UNIQUE_FIELDS, {1}))
               FOR j:=1 TO len(aInformazioni[i])
                 IF ValType(aInformazioni[i,j]) == "A"
                   _dbDesti->(dbAppend())
                   _dbDesti->(FieldPut(1,j))
                   FOR k:=1 TO numCampi
                     IF len(aInformazioni[i,j])>=k ;_dbDesti->(FieldPut(k+1, aInformazioni[i,j,k])) ;ENDIF
                   NEXT
                 ENDIF
               NEXT
               dbCloseArea("_dbDesti")
             ENDIF
           ENDIF
         NEXT         
       ENDIF
       oSession:disConnect()
     ELSE
        IF Empty(oSession:getLastMessage())
          IF ConfirmBox(,"Impossibile aprire la connessione ODBC, Configurare il DSN","Errore di connessione",XBPMB_YESNO,XBPMB_QUESTION) == XBPMB_RET_YES ;
             .AND. G7ODBCexportDNS("Microsoft Excel Driver (*.xls)","Excel Files")
             
            TentaExport = .T.
          ENDIF
        ELSE
          MsgBox("Connessione fallita: " + oSession:getLastMessage(),"Errore di connessione")      
        ENDIF
     ENDIF
   ENDDO
RETURN

STATIC FUNCTION G7ODBCexportDNS(cDriver,cDsn) //Installa il DNS per Excel
   LOCAL oMgr
   LOCAL aDSNs := {}
   LOCAL Ritorno := .T.


   oMgr  := OdbcManager():new()

      aDSNs := DbeInfo( COMPONENT_DATA, ODBCDBE_DATASOURCES ) 

   DbeInfo(ODBCDBE_PROMPT_MODE,ODBC_PROMPT_NEVER )
   // check if name can be used
   IF !oMgr:validateDSNName(cDsn)
      MsgBox("Nome DSN NON Valido","Configurazione ODBC")
   ENDIF
   
   cDsn := "DSN="+cDsn+";DBQ=;Description=Connessione al File XLS"
   IF !oMgr:addUserDsn(cDriver, cDsn)
     MsgBox(  cDsn + ": NON Installato" ,"Configurazione ODBC")
     Ritorno := .F.
   ENDIF
RETURN Ritorno
