//////////////////////////////////////////////////////////////////////
//
//  MAIN.PRG
//
//  Copyright:
//       Alaska Software, (c) 1997-2003. All rights reserved.         
//         
//  Contents:
//       Example of a program that uses Xbase++ DLLs 
//       static binding and dynamic binding
//   
//////////////////////////////////////////////////////////////////////
#include "ot4xb.ch"

#pragma Library( "Asinet10.lib" )
#pragma Library( "Asiutl10.lib" )

INIT PROCEDURE modInit()
   ? PROCNAME()
RETURN

EXIT PROCEDURE modExit()
   ? PROCNAME()
RETURN

PROCEDURE main( cCallParameter )
LOCAL aInfo1 := {} ,;
      aInfo2 := {} ,;
      cRit   := "" ,;
      cHeader:=""
LOCAL oRecDipende
  
      
  IF IsDebug()
    DllLoad( "dbInfo.dll" )
  ENDIF
                        
  oRecDipende := PGSqlRecord:new("DIPENDE")


//----------------------------------------------------------------------------------------------------------------------
  //cRit := G7BrowseFolder()
  //?cRit
  
  
  //G7ShellOpenFile("cmd.exe","/C dir c:\tmp /s > k:\123.txt")
  //G7ShellOpenFile("cmd.exe","/C dir c:\ /s > k:\123.txt",,0)
  //G7ShellOpenFile("notepad.exe","k:\123.txt")
  //G7ShellOpenFile("notepad.exe")      
  //G7AGP_RunShell("TaskKill.exe", "/F /IM EXCEL.EXE /T")       
  
  //LOCAL oExcel := CreateObject("com.sun.star.ServiceManager") 
   
  //G7exportXLS("X:\WC\PROVA.XLS")
   
  //cRit := ShellDefaultProgram("x:\wc\2007.0405 18.16.31.ZIP")
  //DllLoad( "XDLL2" )
  //&("fun2")( "FROM "+PROCNAME(), cCallParameter ) 
  //DllUnload( "XDLL2" )
   
  //RunShell("", "notepad.EXE" , .F. , .F.)
  //RunShell("", "notepad.EXE" , .T. , .F.)
   
  /*cRit := FileStr("X:\XPP\INTEMPO\EXE\Dipende.txt")
  cRit := StrTran(cRit,"&","#AND#")
  cRit := ConvToAnsiCP(cRit)*/
  //cRit := 'content-disposition: form-data; name="pics"; filename="Dipende.txt"/r/n Content-Type: text/plain/n/n' +cRit
  
  /*cHeader := ''                             + ;
  'POST /inTempo/ReceiverData HTTP/1.1/r/n' + ;
  'Host: 192.168.0.70/r/n'                  + ;
  'Content-type: multipart/form-data/r/n'   + ;
  'Content-lenght: '+AllTrim(Str(Len(cRit),,0))+'/r/n'                   + ;
  'name="pics"; filename="Dipende.txt"/r/n Content-Type: text/plain/r/n' + ;
  'Connection: close/r/n/r/n'*/
  
  //cRit := LoadFromUrl("http://192.168.0.70/test.php?a=1&t",80,,,,"POST","ciccio=Ciao")
  //cRit := LoadFromUrl("http://192.168.0.70/inTempo/ReceiverData",8080,,,,"POST","dipende="+cRit)
  //cRit := G7LoadFromUrl("http://192.168.0.70/inTempo/ReceiverData",8080,NIL,NIL,NIL,"POST",cRit,cHeader)
  
  /*
  Strfile(cRit,"x:\wc\return.html")
  */ 
  
  IF .T.
   AAdd(aInfo2,{"p1_r1D","p1_r1I","p1_r1II"})
   aadd(aInfo2,{"p1_r2D","p1_r2I"})
   aadd(aInfo1,aInfo2)

   aInfo2 := {}
   aadd(aInfo2,{"p2_r1D","p2_r1I"})
   aadd(aInfo2,{"p2_r2D","p2_r2I"})
   aadd(aInfo1,aInfo2)
  
   dbUseArea( .T. ,"DBFNTX","xlsExport1.DBF" , "xlsExport1", .T. , .F.)
   dbUseArea( .T. ,"DBFNTX","xlsExport2.DBF" , "xlsExport2", .T. , .F.)
   
   
   G7dbx2excel({"xlsExport1","xlsExport2"},,"..\PROVA.XLS",aInfo1,.F.,.T.,.T.)

   dbCloseArea("xlsExport1")
   dbCloseArea("xlsExport2")
   
  ELSEIF .F.
  
   AAdd(aInfo2,{"GIUS001HH","GIUS001GG","STRAORDI  ","StraOrdinario      ","Presenza","0,00","240,00","0,00"})
   aadd(aInfo2,{"GIUS002HH","GIUS002GG","STRAORDISM","StraOrdi. Rip. Mat.","Presenza","0,00","189,42","0,00"})
   aadd(aInfo2,{"GIUS003HH","GIUS003GG","STRAORDISP","StraOrdi. Rip. Pom.","Presenza","0,00","128,00","0,00"})
   aadd(aInfo1,aInfo2)

   aInfo2 := {}
   aadd(aInfo2,{"Intestazione, riga 1","Imballcanter srl                             "})
   aadd(aInfo2,{"Intestazione, riga 2","Via s quasimodo, 1/3-55023 Diecimo Lucca (LU)"})
   aadd(aInfo2,{"Descrizione Stampa","Totali ore e giorni per dipendente / giustificativo"})
   aadd(aInfo2,{"Filtro stampa riga 1","dalla matricola [         01] all [       1082]"})
   aadd(aInfo2,{"Filtro stampa riga 2","per il reparto [         01] all [       1082]"})
   aadd(aInfo2,{"Filtro stampa riga 3","incluse  [         01] all [       1082]"})
   aadd(aInfo2,{"Filtro stampa riga 4","Dalla data 01-05-2013 alla data 31-05-2013"})
   aadd(aInfo2,{"Filtro stampa riga 5","."})
   aadd(aInfo1,aInfo2)

   dbUseArea( .T. ,"DBFNTX","xlsExport.DBF" , "xlsExport", .T. , .F.)
   dbUseArea( .T. ,"DBFNTX","SUPTCALC.DBF" , "SUPTCALC", .T. , .F.)
   dbUseArea( .T. ,"DBFNTX","DIPENDE.DBF" , "DIPENDE", .T. , .F.)
   dbUseArea( .T. ,"DBFNTX","GIUSTIFI.DBF" , "GIUSTIFI", .T. , .F.)
   
   
   //G7dbx2excel({"xlsExport","SUPTCALC","DIPENDE","GIUSTIFI"},"K:\Dati Clienti\Imbal Center\AnalisiSTR.XLS","K:\WC\PROVA.XLS",aInfo1,.F.,.T.,.T.)
   G7dbx2excel({"xlsExport","SUPTCALC","DIPENDE","GIUSTIFI"},,,aInfo1,.F.,.T.,.T.)
   //G7dbx2excel({"xlsExport","SUPTCALC","DIPENDE","GIUSTIFI"},"k:\wc\x.ods",,aInfo1,.F.,.T.,.T.)
   G7dbx2excel({"xlsExport","SUPTCALC","DIPENDE","GIUSTIFI"},"k:\wc\x.ods","k:\wc\y.ods",aInfo1,.F.,.T.,.T.)
   
   
   dbCloseArea("xlsExport")
   dbCloseArea("SUPTCALC")
   dbCloseArea("DIPENDE")
   dbCloseArea("GIUSTIFI")

ENDIF


   MsgBox("Finito")   
   //ShellOpenFile("C:\MICROCOM\MICROCOM.EXE","C:\MICROCOM")
RETURN
