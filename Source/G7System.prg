#INCLUDE "COMMON.CH"
#INCLUDE "DLL.CH"
/*#INCLUDE "COLLAT.CH"
#INCLUDE "GET.CH"
#INCLUDE "MEMVAR.CH"
#INCLUDE "NATMSG.CH"
#INCLUDE "PROMPT.CH"
#INCLUDE "SET.CH"
#INCLUDE "STD.CH"
#INCLUDE "XBP.CH"
#INCLUDE "DAC.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "ODBCDBE.CH"
#INCLUDE "SQLCMD.CH"*/

FUNCTION G7LinkApp2Desktop(lnkFile,lnkDesc)
  LOCAL cLinkTarget := "" ,;
        cLinkFile   := "" ,;
        sysUserHome := ""
  LOCAL lRet := .F.

  sysUserHome := Getenv("HOMEDRIVE")+Getenv("HOMEPATH")+"\Desktop"
  cLinkFile   := AppName(.T.)
  cLinkTarget := Left(AppName(.T.),Len(AppName(.T.))-Len(AppName(.F.)))

  IF File(sysUserHome,"DH")
    lRet := ShellLinkCreate( cLinkFile                      ,;
                             sysUserHome+"\"+lnkFile+".lnk" ,;
                             cLinkTarget                   ,,;
                             lnkDesc )
  ENDIF
RETURN lRet

/*#DEFINE SW_HIDE 0

FUNCTION G7AGP_RunShell(cFile, cParameters, cDir, nMode, oDlg)
  LOCAL cStartDir := IIf(empty(cDir) , CurDir(), cDir )
  LOCAL nWinMode  := IIf(nMode == NIL, SW_HIDE , nMode)
  LOCAL nHandle   := IIf(oDlg  == NIL, AppDesktop():GetHWnd(), oDlg:GetHWnd())
  LOCAL nError    := DllCall("Shell32.dll", DLL_STDCALL, "ShellExecuteA", nHandle, "open", cFile, cParameters, cStartDir, nWinMode)
RETURN (nError)*/

FUNCTION G7ShellOpenFile(cFile,cPar,cDir,nMode,oDlg)
#define SW_HIDE             0
#define SW_NORMAL           1
#define SW_SHOWMINIMIZED    2
#define SW_SHOWMAXIMIZED    3
#define SW_MAXIMIZE         3
#define SW_SHOWNOACTIVATE   4
#define SW_SHOW             5
#define SW_MINIMIZE         6
#define SW_SHOWMINNOACTIVE  7
#define SW_SHOWNA           8
#define SW_RESTORE          9
#define SW_SHOWDEFAULT      10

  LOCAL nHandle := 0 ,;
        nError  := 0
  
  cDir     := IIf(Empty(cDir) , CurDir(), cDir )
  nMode    := IIf(nMode == NIL, SW_MAXIMIZE , nMode)
  nHandle  := IIf(oDlg  == NIL, AppDesktop():GetHWnd(), oDlg:GetHWnd())
  
  IF !Empty(cFile)
    nError := DllCall("SHELL32.DLL", DLL_STDCALL, "ShellExecuteA", nHandle, "open", cFile, cPar, cDir, nMode)
  ENDIF
  
  /*IF !Empty(cFile)
    IF Empty(cDir)
      cDir := AllTrim(CurDir())
    ENDIF
    DllCall( "SHELL32.DLL"  , DLL_STDCALL, ;
             "ShellExecuteA", AppDesktop():GetHWND(), "open", cFile, cPar, cDir, SW_MAXIMIZE )
  ENDIF           */
RETURN nError

FUNCTION G7ShellDefaultProgram(cFile)
  LOCAL cExe:= Replicate(CHR(0),254), cDir:= ".\\", nDll
  
  IF File(cFile)
    nDll := DllLoad("shell32.dll")
    IF nDll <> 0
      DllCall(nDll,DLL_STDCALL,"FindExecutableA",@cfile,@cdir,@cExe)
      DllUnLoad( nDll )
    ENDIF
  ENDIF
RETURN (IIf(!Empty(cExe),cExe,""))

FUNCTION G7AppDesktopDPI()
  LOCAL nHWnd   := AppDesktop():GetHWnd()
  LOCAL nHDC    := DllCall("User32.DLL", DLL_STDCALL, "GetDC", nHWnd)
  LOCAL nLogPix := 96 // Default for Small Fonts
  
  IF nHDC != 0
    nHDC    := DllCall("User32.DLL", DLL_STDCALL, "GetDC"        , nHWnd     )
    nLogPix := DllCall("GDI32.DLL" , DLL_STDCALL, "GetDeviceCaps", nHDC , 88 ) //LOGPIXELSY=88
    DllCall("User32.DLL", DLL_STDCALL, "ReleaseDC", nHWnd, nHDC)
  ENDIF
RETURN (nLogPix)

DLLFUNCTION SetProcessAffinityMask(hProcess,dwProcessAffinityMask) USING STDCALL FROM Kernel32.DLL
DLLFUNCTION GetProcessAffinityMask(hProcess,@lpProcessAffinityMask,@lpSystemAffinityMask) USING STDCALL FROM Kernel32.DLL
DLLFUNCTION GetCurrentProcess() USING STDCALL FROM Kernel32.DLL

FUNCTION G7CPUGetAffinity()
  LOCAL ProcMask := 0
  LOCAL SysMask  := 0
  LOCAL lSuccess := GetProcessAffinityMask(GetCurrentProcess(),@ProcMask,@SysMask)
RETURN ProcMask

FUNCTION G7CPUSetAffinity(nProc) 
  //nProc = Processore da impostare, NIL per random da Timer
  LOCAL aProc := {} ,;
        tProc := 0  ,;
        rProc := 0
  
  tProc := Val(Getenv("NUMBER_OF_PROCESSORS")) //Recupero il numero di processori con il sistema dei poveri
  IF !Empty(tProc) .AND. tProc >= 1
    FOR i:=1 TO tProc
      AAdd(aProc,2^(i-1))
    NEXT

    IF Empty(nProc) //Assegnazione random da Timer
      nProc := Int(Seconds()%tProc)+1
    ENDIF

    IF !Empty(nProc) .AND. (SetProcessAffinityMask(GetCurrentProcess(),aProc[nProc]) > 0)
      rProc := nProc
    ENDIF
  ENDIF  
RETURN rProc


/*  RunDefaultShellProg( cFile, SHELL_PRINT, SW_MINIMIZE )
    RunDefaultShellProg( cFile, SHELL_OPEN , SW_MAXIMIZE )


    ******************************************************************************
    FUNCTION RunDefaultShellProg( cFile, cMode, nShow )
     * Ein Standardprogramm öffnen oder über ein Standardprogramm drücken
     * Parameter: cFile -> Datei welche geöffnet oder gedruckt werden soll
     *            cMode -> SHELL_OPEN  für Datei öffnen
     *                  -> SHELL_PRINT für Datei drucken
     *            nShow -> SW_MAXIMIZE
     *                  -> SW_MINIMIZE
     * Return   : NIL
    ******************************************************************************

       LOCAL  nRet := 0

       DO CASE
          CASE cMode == SHELL_PRINT
             // Druck im Hintergrund starten
             nRet := WinAPIPrint( cFile, , , nShow )
             IF ! (nRet > 32)
                MsgBox( ... )
               nRet := -1
             ENDIF

          CASE cMode == SHELL_OPEN
             nRet := WinAPIOpen( cFile, , , nShow )
             IF ! nRet
                MsgBox( ... )
               nRet := -1
             ENDIF
       ENDCASE

    RETURN nRet


    FUNCTION WinAPIPrint( cFile, cParms, cDirectory, nOpenMode )

       DEFAULT nOpenMode  TO SW_HIDE, ;
               cDirectory TO CurDir()

    RETURN wapiShellExecute( AppDesktop():GetHWND(), "print", cFile, cParms, CurDir(), nOpenMode )



    FUNCTION WinAPIOpen( cFile, cParms, cDirectory, nOpenMode )

       DEFAULT nOpenMode  TO SW_HIDE, ;
               cDirectory TO CurDir()

    RETURN wapiShellExecute( AppDesktop():GetHWND(), "open", cFile, cParms, CurDir(), nOpenMode ) > 32



    FUNCTION wapiShellExecute( nHWND,cOperation,cFile,cParms,cDirectory,nOpenMode)

       STATIC cTpl := NIL
       LOCAL nDll  :=DllLoad("SHELL32.DLL")
       LOCAL xRet  := NIL

       if cTpl == NIL
          cTpl := DllprepareCall(nDll,32 ,"ShellExecuteA")
       endif

       xRet := DLLExecuteCall( cTpl , nHWND,cOperation,cFile,cParms,cDirectory,nOpenMode )

    RETURN xRet
    
#DEFINE SPIF_SENDCHANGE      0x0002	 2
#DEFINE SPI_SETWORKAREA      0x002F	 47
#DEFINE SPI_GETWORKAREA      0x0030	 48
#DEFINE TOGGLE_HIDEWINDOW    0x0080	 64
#DEFINE TOGGLE_UNHIDEWINDOW  0x0040	 128

FUNCTION WindowsWorkArea(aArea)
// If "aArea" is supplied, the Windows WorkArea is set to the new area,   
// as if the left-out area is occupied by Taskbar(s) or other things, but 
// no TaskBar(s) is (are) moved. After setting the Windows WorkArea, all  
// Applications recognize this area for functions such as maximizing a    
// Window. The Parameter "aArea" must be NIL or an Array of the following 
// format: "aArea" ==> {"nLeftPos", "nTopPos", "nRightPos", "nBottomPos"} 
// defining the new Workarea in Windows (Pixel) coordinates (Left and Top 
// are both "0", while in Xbase usually Left and Bottom are "0")!!!       

// The current Windows WorkArea (not occupied by Taskbar(s)) is returned  
// as a two-dimensional Array {"aPos", "aSize"}, of the following format: 
// "aPos"  ==> an Array in Xbase coordinates {"nLeft", "nBottom"}, and    
// "aSize" ==> an Array of two numbers of Pixels {"nWidth", "nHeight"}.   

LOCAL nSetOrGet := iif(aArea == NIL, SPI_GETWORKAREA, SPI_SETWORKAREA)
LOCAL nSetFlag  := iif(aArea == NIL, 0, SPIF_SENDCHANGE)
LOCAL nLeft     := iif(aArea == NIL, 0, aArea[1])
LOCAL nTop      := iif(aArea == NIL, 0, aArea[2])
LOCAL nRight    := iif(aArea == NIL, 0, aArea[3])
LOCAL nBottom   := iif(aArea == NIL, 0, aArea[4])
LOCAL cBuffer   := iif(aArea == NIL, Space(16), U2Bin(nLeft) + U2Bin(nTop) + U2Bin(nRight) + U2Bin(nBottom))
LOCAL aPos      := {0, 0}
LOCAL aSize     := GetDeskTopSize()
   DllCall("User32.DLL", DLL_STDCALL, "SystemParametersInfoA", nSetOrGet, 0, @cBuffer, nSetFlag)
   nLeft    := Bin2U(substr(cBuffer,  1, 4))
   nTop     := Bin2U(substr(cBuffer,  5, 4))
   nRight   := Bin2U(substr(cBuffer,  9, 4))
   nBottom  := Bin2U(substr(cBuffer, 13, 4))
   aPos[1]  := nLeft
   aPos[2]  := aSize[2] - nBottom
   aSize[1] := nRight   - nLeft
   aSize[2] := nBottom  - nTop
RETURN ({aPos, aSize})

FUNCTION HideWindowsTaskbar(lHide)
LOCAL nShowIt := iif(lHide, TOGGLE_HIDEWINDOW, TOGGLE_UNHIDEWINDOW)
LOCAL nHandle := FindWindow('Shell_traywnd', '')
LOCAL lResult := .f.
   if nHandle # 0
      lResult := (DllCall("User32.DLL", DLL_STDCALL, "SetWindowPos", nHandle, 0, 0, 0, 0, 0, nShowIt) # 0)
   endif
RETURN (lResult)*/

