#INCLUDE "FILEIO.CH"

INIT PROCEDURE modInit()
   ? "Stampa Avviata..." //PROCNAME()
RETURN

EXIT PROCEDURE modExit()
   ? "Stampa Terminata." //PROCNAME()
RETURN

PROCEDURE Main( cfilePath,nCOM,COM_Baudrate,COM_Parity,COM_BitLength,COM_StopBits )
  LOCAL xStr  := ""
  LOCAL xLock := 0
  LOCAL xTest := .T.
  LOCAL xTime := Seconds()*100
  LOCAL xLog  := ""
  
  xLock := FCreate("G7PrintCOM.log")
  IF xLock > 0
    IF !Empty(cfilePath) .AND. !Empty(nCOM) .AND. !Empty(COM_Baudrate) .AND. !Empty(COM_Parity) .AND. !Empty(COM_BitLength) .AND. !Empty(COM_StopBits) 
      xStr := FileStr(cfilePath)
      
      xLog := _G7PrintCOM(xStr,Val(nCOM),Val(COM_Baudrate),COM_Parity,Val(COM_BitLength),Val(COM_StopBits))
        
      FWrite(xLock, xLog)
    ELSE 
      FWrite(xLock, "Stampa NON Inviata")
    ENDIF
    FClose(xLock)
    //FErase("G7PrintCOM.log")
  ENDIF
RETURN
