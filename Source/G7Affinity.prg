
#include 'common.ch'
#include 'FileIo.ch'
#INCLUDE 'set.ch'
#INCLUDE 'dmlb.ch'
#INCLUDE 'CdxDbe.ch'
#INCLUDE 'DbfDbe.ch'
#INCLUDE 'FoxDbe.ch'
#INCLUDE 'Ntxdbe.ch'
#INCLUDE '\msi\include\CabGui.ch'

#PRAGMA LIBRARY("ASCOM10.LIB")


FUNCTION ApiGetCPUSerial_(cStrComputer, nWichProcessor)
LOCAL  oWMIService, oSMBIOS, nLen, nInd, cSerial
IF cStrComputer == NIL
   cstrComputer := '.'           // It can be ie.: 'LocalHost'
ENDIF
cSerial     :=('winmgmts:{impersonationLevel=impersonate}\\' + cStrComputer + '\root\cimv2')
oWMIService := CreateObject(cSerial)
oSMBIOS     := oWMIService:execQuery("Select * from Win32_SystemEnclosure")
IF nWichProcessor <> NIL .and.;
   oSMBIOS:count  <= nWichProcessor
   cSerial       := oSMBIOS:Item(1):GetProperty('SerialNumber')
ELSE
   cSerial := ''
   nLen    := oSMBIOS:count
   FOR nInd := 1 to nLen
       IF nInd > 1
          cSerial += CR
       ENDIF 
       cSerial    += oSMBIOS:Item(nInd):GetProperty('SerialNumber')
   NEXT
ENDIF
oWMIService:destroy()
oSMBIOS:destroy()
RETURN cSerial


DLLFUNCTION SetProcessAffinityMask(hProcess,dwProcessAffinityMask) USING STDCALL FROM kernel32.DLL
DLLFUNCTION GetProcessAffinityMask(hProcess,@lpProcessAffinityMask,@lpSystemAffinityMask) USING STDCALL FROM kernel32.DLL
DLLFUNCTION GetCurrentProcess() USING STDCALL FROM kernel32.DLL

FUNCTION GetAffinity()
  LOCAL ProcMask := 0
  LOCAL SysMask  := 0
  LOCAL t := GetProcessAffinityMask(GetCurrentProcess(),@ProcMask,@SysMask)
RETURN ProcMask

FUNCTION SetAffinity(nProc)
   LOCAL aProc := {1,2,4,8}
   
   SetProcessAffinityMask(GetCurrentProcess(),aProc[nProc+1])  
RETURN NIL

FUNCTION AffinityTest(nProc)
   SetAffinity(nProc)
   MsgBox(GetAffinity(),"")
RETURN nil
