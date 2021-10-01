#INCLUDE "COMMON.CH"
//#INCLUDE "COLLAT.CH"
//#INCLUDE "MEMVAR.CH"
//#INCLUDE "SET.CH"
//#INCLUDE "STD.CH"
//#INCLUDE "XBP.CH"
//#INCLUDE "DAC.CH" 
//#INCLUDE "DLL.CH"
//#INCLUDE "XBTBASE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "XBTCOM.CH"

#DEFINE  CRLF  Chr(13)+Chr(10)
        

FUNCTION G7PrintCOM(xStr,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits,xTimeOut,xThread,xRunShell,xPath)
  LOCAL oThread    := NIL
  LOCAL xStartTime := Seconds()
  LOCAL xCommand   := ""
  LOCAL xFileLock  := 0
  
  DEFAULT xThread     TO .F.
  DEFAULT xRunShell   TO .F.
  DEFAULT xPath       TO ""
  DEFAULT xTimeOut    TO 10
  
  IF xRunShell .AND. !Empty(xPath)
    IF StrFile(xStr, xPath) > 0
      FErase("G7PrintCOM.log")
      xCommand := xPath+" "+AllTrim(Str(nCOM))+" "+AllTrim(Str(COM_Baudrate))+" "+AllTrim(COM_Parity)+" "+AllTrim(Str(COM_BitLength))+" "+AllTrim(Str(COM_StopBits)) 
      RunShell(xCommand, "G7PrintCOM.EXE" , .T. , .T.)
      
      
      WHILE Seconds() < xStartTime + 30 .AND. !FExists("G7PrintCOM.log")
        Sleep(50)
      ENDDO
            
      WHILE Seconds() < xStartTime + xTimeOut .AND. (xFileLock := FOpen("G7PrintCOM.log",FO_READWRITE+FO_EXCLUSIVE)) < 0
        Sleep(50)
      ENDDO
      FClose(xFileLock)
      
      RunShell("/F /T /IM G7PrintCOM.EXE", "C:\WINDOWS\system32\taskkill.exe", .F. , .T. )

    ELSE
      MsgBox("Impossibile scrivere il file")
    ENDIF
  ELSE
    IF xThread
      oThread := Thread():new()
      oThread:setInterval( 10 )
      oThread:start( "_G7PrintCOM",xStr,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits)
      oThread:setInterval( NIL )
      oThread:synchronize( 0 )
    ELSE
    
      _G7PrintCOM(xStr,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits)
    
    ENDIF
  ENDIF
RETURN NIL


FUNCTION _G7PrintCOM(xStr,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits)
  LOCAL nInfo := 0 ,;
        sRet  := ""
  
  sRet := "Stampa Inviata alla Porta COM"+AllTrim(Str(nCOM,,0))  
  IF Com_Open(nCOM,,,,COM_OPEN_FASTUART) 
    IF Com_Init(nCOM, COM_Baudrate, COM_Parity, COM_BitLength, COM_StopBits)
      Com_SendMode(nCOM, WRITE_TIMEOUT, 0)
      Com_Hard(nCOM, .T.) 
      Com_Soft(nCOM, .F.)
      nInfo := Com_Send(nCOM,xStr)
    ELSE
      sRet := "ERRORE: Impossibile Inizializzare la Porta COM"+AllTrim(Str(nCOM,,0))  
    ENDIF
    Com_Close(nCOM,COM_CLOSE_NOFLUSH)
  ELSE
    sRet := "ERRORE: Impossibile Aprire la Porta COM"+AllTrim(Str(nCOM,,0))  
  ENDIF
RETURN sRet

/*CLASS COMThread FROM Thread 
  PROTECTED: 
     VAR terminated 
     VAR xStartTime 
     VAR xTimeOut
     VAR xStr
     VAR nCOM
     VAR COM_Baudrate
     VAR COM_Parity
     VAR COM_BitLength
     VAR COM_StopBits
     
  EXPORTED:  
     INLINE METHOD INIT(xStr,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits,xStartTime,xTimeOut) 
        ::Thread:init()
        ::xStr          := xStr
        ::nCOM          := nCOM
        ::COM_Baudrate  := COM_Baudrate
        ::COM_Parity    := COM_Parity
        ::COM_BitLength := COM_BitLength
        ::COM_StopBits  := COM_StopBits
        ::xStartTime    := xStartTime
        ::xTimeOut      := xTimeOut
        ::terminated    := .F. 
     RETURN self 
     
     METHOD execute, terminate
ENDCLASS 

METHOD COMThread:execute
  _G7PrintCOM(::xStr,::nCOM,::COM_Baudrate,::COM_Parity,::COM_BitLength,::COM_StopBits) 
  ::terminated := .T.
  ::terminate()
  Sleep(200)
RETURN self 

METHOD COMThread:terminate(xFlag)
  LOCAL lRet := .F.
  DEFAULT xFlag TO .F.
  IF ::terminated .OR. xFlag
    ::terminated := .T.
    ::setInterval( NIL )
      ::self:sincronize(0)
    ENDIF
    ::quit() 
    lRet := .T.
  ENDIF  
RETURN lRet
*/