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

//#pragma Library( "Asinet10.lib" )
//#pragma Library( "Asiutl10.lib" )

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
      cHeader:=""  ,;
      v1     := 0  ,;
      v2     := 0.00
  LOCAL cStdOut := ""
  LOCAL cStdErr := ""
  
      
  IF IsDebug()
    DllLoad( "dbInfo.dll" )
  ENDIF

cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
cRit := G7DocId()
  
//test_json()
  
//G7RunProcess( "X:\XPP\miaAzienda\EXE\_RT\Python3\python.exe py\ciao.py" , "" ,  , @cStdOut , @cStdErr)  //( cExe , cParams , cWorkDir , cStdOut , cStdErr, nBuffSize)
G7RunProcess( "G7DocId.exe 10"                                          , "" ,  , @cStdOut , @cStdErr)  //( cExe , cParams , cWorkDir , cStdOut , cStdErr, nBuffSize)
//ExecuteRedirect( 'python.exe hello.py' ,'', ,@cOut,@cErr)
//ExecuteRedirect( 'python.exe _ALTRO\STRCF\CORISTECH\zero55.py' ,'', ,@cOut,@cErr)

RETURN
             
FUNCTION test_json()
   LOCAL v := JSON_Container():New()
   LOCAL i,cJson

   v:string := "Test Json"
   v:int := 123
   v:num := 123.45
   v:array := {1,'abc',date(),{time()}}
   v:av := {}
   FOR i := 1 to 10
     AAdd(v:av, JSON_Container():New())
     ATail(v:av):num := i
     ATail(v:av):string := 'Ok'+Str(i)
   NEXT i

   cJson := json_serialize(v)
   MemoWrit( "json.txt" , json_pretty_out( cJson ) )
RETURN NIL
       