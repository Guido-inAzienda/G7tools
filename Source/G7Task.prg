...
         CloseIt({"Nachricht lesen"     ,;
                  "Nachricht schreiben" ,;
                  "Nachrichten Eingang" ,;
                  "Nachrichten gesendet" })
...

FUNCTION  CloseIt( aNaam )
LOCAL i, nMax

nMax := LEN(aNaam)
FOR i = 1 To nMax
   CloseNow( aNaam[i] )
NEXT
RETURN NIL

#define WM_CLOSE        0x0010
#define WM_QUIT         0x0012

FUNCTION  CloseNow( cNaam )
LOCAL nEvent, mp1, mp2
LOCAL oDlg
LOCAL aTasklist
LOCAL aSize   := {0,0}
LOCAL aPos    := {0,0}
LOCAL lRunnin := .F.
LOCAL i
LOCAL nHwnd,cWind

oDlg := XbpDialog():new( AppDesktop(), , aPos, aSize, , .F.)
oDlg:clipSiblings := .T.
oDlg:drawingArea:ClipChildren := .T.
oDlg:create()

SETAPPFOCUS(oDlg)

aTasklist := GetTaskList( oDlg:gethWnd( ) )

FOR i = 1 to LEN( aTasklist )
    cWind := TRIM( UPPER( SUBSTR( aTasklist[i], 9 ) ) )
    cWind := SUBSTR( cWind, 1, LEN( cWind ) - 1 )
    If cWind == TRIM( UPPER( cNaam ) )
       lRunnin := .T.
       nHwnd := VAL( LEFT( aTasklist[i], 8 ) )

// hier wird nun die Application "abgeschossen"
///
       SendMessageA( nHwnd, WM_CLOSE ,0,0)
       RETURN lRunnin
    EndIf
Next

Return lRunnin

#include "DLL.ch"

#define GW_HWNDFIRST        0
#define GW_HWNDLAST         1
#define GW_HWNDNEXT         2
#define GW_HWNDPREV         3
#define GW_OWNER            4
#define GW_CHILD            5
#define GW_MAX              5

FUNCTION GetTaskList( hWnd )
LOCAL aList:={}
LOCAL cWindowName
LOCAL nVisible
DO WHILE hWnd != 0
   cWindowname := space(100)
   IF ( getwindowtexta( hWnd, @cWindowName, LEN( cWindowName ) ) <> 0 )
       nVisible := IsWindowVisible(hWnd)
       IF nVisible == 1
          AADD( aList, Str( hWnd, 8 )+cWindowname )
       ENDIF
   ENDIF
   hWnd = GetWindow( hWnd, GW_HWNDNEXT )
ENDDO
RETURN aList

FUNCTION GetWindow( hWnd, uCmd )
LOCAL nDll:=DllLoad("USER32.DLL")
LOCAL xRet:=DllCall(nDll,DLL_STDCALL,"GetWindow", hWnd,uCmd)
DllUnLoad(nDll)
RETURN xRet

FUNCTION GetWindowTextA( hWnd, lPstring, nMax )
LOCAL nDll:=DllLoad("USER32.DLL")
LOCAL xRet:=DllCall(nDll,DLL_STDCALL,"GetWindowTextA", hWnd, @lPstring, nMax )
DllUnLoad(nDll)
RETURN xRet

FUNCTION IsWindowVisible( hWnd)
LOCAL nDll:=DllLoad("USER32.DLL")
LOCAL xRet:=DllCall(nDll,DLL_STDCALL,"IsWindowVisible", hWnd)
DllUnLoad(nDll)
RETURN xRet




// Altro approccio dal forum di alaska software
Alaska Software Inc. - KillPrevPID (thanks Pablo)

Forum Index
public.xbase++.generic



Username:  Password:  



Author

Topic: KillPrevPID (thanks Pablo)

 Claudio Driussi  KillPrevPID (thanks Pablo)
 on Wed, 01 Aug 2012 10:30:51 +0200
Thanks to Pablo Botella's ot4xb and excellent
samples: TestListProcesses and TRunProcess
I wrote this function which allow a single
instance of my application, but the last one
so it kill the previous (this was my special need)

8<--------8<--------8<--------8<--------8<--------8<--------
function KillPrevPID(lAsk)
   local hp := NIL
   local dw := 0
   local aList := GetProcessList()
   local i
   default lAsk to .t.
   for i := 1 to len(aList)-1
     if aList[i,1] = appname()
        if lAsk
             put your ask logic here
            return nil
            endif
          lAsk := .f.
          endif
        hp := @kernel32:OpenProcess(1,0,aList[i,2])
        if( empty(hp) ) ; return nil ; end
        @kernel32:TerminateProcess(hp , -1 )
        @kernel32:CloseHandle(hp)
        endif
     next i
return nil
#define TH32CS_SNAPPROCESS  0x00000002
function GetProcessList()
   local aList := {}
   local hps := @kernel32:CreateToolhelp32Snapshot( TH32CS_SNAPPROCESS, 0 )
   local pe  := PROCESSENTRY32():New()
   local lLoop, aa

   if hps == -1 ; return NIL ; end   to-do: put some err handling here
   pe:dwSize = pe:_sizeof_()

   lLoop := ( @kernel32:Process32First(hps,pe) != 0 )
   while lLoop
     aa    := Array(5)
     aa[1] := pe:szExeFile
     aa[2] := pe:th32ProcessID
     aa[3] := pe:cntThreads
     aa[4] := pe:th32ParentProcessID
     aa[5] := pe:pcPriClassBase
     aadd( aList , aa )
     lLoop := ( @kernel32:Process32Next(hps,pe) != 0 )
     end
   @kernel32:CloseHandle( hps)
return aList
BEGIN STRUCTURE PROCESSENTRY32
    MEMBER DWORD  dwSize
    MEMBER DWORD  cntUsage
    MEMBER DWORD  th32ProcessID
    MEMBER HANDLE th32DefaultHeapID
    MEMBER DWORD  th32ModuleID
    MEMBER DWORD  cntThreads
    MEMBER DWORD  th32ParentProcessID
    MEMBER LONG   pcPriClassBase
    MEMBER DWORD  dwFlags
    MEMBER SZSTR  szExeFile SIZE 260
END STRUCTURE
8<--------8<--------8<--------8<--------8<--------8<--------

thanks again

Claudio Driussi
 
 Pablo Botella Navarro Re: KillPrevPID (thanks Pablo)
 on Wed, 01 Aug 2012 16:17:51 +0200
Hi Claudio,

Nice stuff. 

Just 1 tip to avoid shot yourself. Even most times you will retrieve a list of processes in creation order and usually your process will be the last of the list, don't assume it

  for i := 1 to len(aList)  -1  eval also sthe last item
>     if aList[i,1] = appname()

.and. aList[n][2] != @kernel32:GetCurrentProcessId()  and check not the current process

Regards,
Pablo
 
 Claudio Driussi  Re: KillPrevPID (thanks Pablo)
 on Thu, 02 Aug 2012 14:09:10 +0200
Il 01/08/2012 16:17, Pablo Botella Navarro ha scritto:
> Hi Claudio,
>
> Nice stuff.
>
> Just 1 tip to avoid shot yourself. Even most times you will retrieve a list of processes in creation order and usually your process will be the last of the list, don't assume it
>
>    for i := 1 to len(aList)  -1  eval also sthe last item
>>      if aList[i,1] = appname()
>
> .and. aList[n][2] != @kernel32:GetCurrentProcessId()  and check not the current process

Better.

>
> Regards,
> Pablo
>
>
 
 Pablo Botella Navarro Re: KillPrevPID (thanks Pablo)
 on Wed, 01 Aug 2012 16:47:30 +0200
Hi,

Just an alternate aproach, giving the previous app a chance to terminate by its own feed, if the app not finished after the timeout will be killed.

Regards,
Pablo



#include "ot4xb.ch"
#define MY_APP_GUID "7f66dd8e-c489-4970-abec-e877be1fec68"
//-----------------------------------------------------------
proc main
? Seconds()
RenewApp_InstanceHandler():OnStart( MY_APP_GUID , 10000 )
? "press a key to exit"
inkey(0)
return
//-----------------------------------------------------------
CLASS RenewApp_InstanceHandler
EXPORTED:
        ---------------------------------------------------
INLINE CLASS METHOD OnStart(cAppUuid,nTimeOut)
       local dwProc := 0
       local hProc  := -1
       DEFAULT nTimeOut := 60000  1 minute
       DEFAULT cAppUuid := lower(AppName() + ".single.instance")
       while ot4xb_single_instance(cAppUuid,Self,,@dwProc)
          hProc := @kernel32:OpenProcess(0x100001,0,dwProc)
          if !Empty( hProc )
             if @kernel32:WaitForSingleObjectEx(hProc, nTimeOut,.F.) != 0
                @kernel32:TerminateProcess(hProc, -1 )
             end
             @kernel32:CloseHandle(hProc)
          end
       end
       return NIL
        ---------------------------------------------------
INLINE CLASS METHOD OnNewInstance()
       QUIT
       return NIL
        ---------------------------------------------------
ENDCLASS
//-----------------------------------------------------------
 
 Claudio Driussi  Re: KillPrevPID (thanks Pablo)
 on Thu, 02 Aug 2012 14:08:03 +0200
Il 01/08/2012 16:47, Pablo Botella Navarro ha scritto:
> Hi,
>
> Just an alternate aproach, giving the previous app a chance to terminate by its own feed, if the app not finished after the timeout will be killed.

Yeah, i will try, may be better

Claudio

> Regards,
> Pablo
>
>
>
> #include "ot4xb.ch"
> #define MY_APP_GUID "7f66dd8e-c489-4970-abec-e877be1fec68"
> //-----------------------------------------------------------
> proc main
> ? Seconds()
> RenewApp_InstanceHandler():OnStart( MY_APP_GUID , 10000 )
> ? "press a key to exit"
> inkey(0)
> return
> //-----------------------------------------------------------
> CLASS RenewApp_InstanceHandler
> EXPORTED:
>          ---------------------------------------------------
> INLINE CLASS METHOD OnStart(cAppUuid,nTimeOut)
>         local dwProc := 0
>         local hProc  := -1
>         DEFAULT nTimeOut := 60000  1 minute
>         DEFAULT cAppUuid := lower(AppName() + ".single.instance")
>         while ot4xb_single_instance(cAppUuid,Self,,@dwProc)
>            hProc := @kernel32:OpenProcess(0x100001,0,dwProc)
>            if !Empty( hProc )
>               if @kernel32:WaitForSingleObjectEx(hProc, nTimeOut,.F.) != 0
>                  @kernel32:TerminateProcess(hProc, -1 )
>               end
>               @kernel32:CloseHandle(hProc)
>            end
>         end
>         return NIL
>          ---------------------------------------------------
> INLINE CLASS METHOD OnNewInstance()
>         QUIT
>         return NIL
>          ---------------------------------------------------
> ENDCLASS
> //-----------------------------------------------------------
>
 

===============================================================================================================

FUNCTION GetTaskList( hWnd )
LOCAL aList       := {}
LOCAL cWindowName
LOCAL nVisible
  DO WHILE hWnd != 0
    cWindowname := SPACE( 100 )
    IF ( getwindowtexta(hWnd,@cWindowName,LEN(cWindowName))<>0)
       nVisible := IsWindowVisible( hWnd )
      IF nVisible == 1
         AADD( aList, STR( hWnd, 8 ) + cWindowname )
      ENDIF
    ENDIF
    hWnd = GetWindow( hWnd, GW_HWNDNEXT )
  ENDDO
RETURN aList


FUNCTION ProcTask()
  LOCAL dwProcId := @kernel32:GetCurrentProcessId()
  LOCAL hRet  := 0
  LOCAL i,iMax
  LOCAL aWnd  := {}
  
  aWnd  := aGetProcessWindows(dwProcId)
  iMax  := Len(aWnd)
  FOR i := 1 TO iMax
    IF DisplayWndInfo(aWnd[i]) > 0
      hRet := aWnd[i]
      EXIT
    ENDIF
  NEXT
RETURN hRet

