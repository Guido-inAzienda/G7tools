#INCLUDE "ot4xb.ch"
#INCLUDE "Common.ch"

FUNCTION G7FilePrintRaw( cFile , cPRN , cStp )     
  LOCAL lRet := .F.
  LOCAL oPrt := TPrintRaw():New() 
  
  DEFAULT cStp TO AppName()
  
  IF oPrt:Open( cPRN )
    IF oPrt:StartDoc( cStp )
      IF oPrt:StartPage()
         oPrt:Write(cFile)          
         oPrt:EndPage()
         
         lRet := .T.
      ENDIF
      oPrt:EndDoc()
    ENDIF
    oPrt:Close()
  ENDIF
RETURN lRet
                                                                      
FUNCTION G7BrowseFolder( cFile )     
  LOCAL cRet := ""
  LOCAL obff := TBrowseForFolder():New()   
                          
  DEFAULT cFile TO "_d\b"
  obff:hwndOwner := SetAppWindow():GetHWnd()
  
  cRet := obff:run( cFile ) 
  //cRit :=  obff:run( "C:\_d\b" )       
  //cRet :=  obff:run( "_d\b" ) 
  
RETURN IsNull(cRet,"",cRet)

///////////////////////////////////////////////////////////////////////////////
//
// TRunProcess
//
///////////////////////////////////////////////////////////////////////////////

BEGIN STRUCTURE  _TRunProcess_base_
   GWSTSKIPBYTES( 4 ) // DWORD   cb
   GWSTSKIPBYTES( 4 ) // LPTSTR  lpReserved
   MEMBER LPSTR     lpDesktop DYNSZ cDesktop
   MEMBER LPSTR     lpTitle   DYNSZ cTitle
   MEMBER DWORD     dwX
   MEMBER DWORD     dwY
   MEMBER DWORD     dwXSize
   MEMBER DWORD     dwYSize
   MEMBER DWORD     dwXCountChars
   MEMBER DWORD     dwYCountChars
   MEMBER DWORD     dwFillAttribute
   MEMBER DWORD     dwFlags
   MEMBER WORD      wShowWindow
   GWSTSKIPBYTES( 2 ) // WORD   cbReserved2
   GWSTSKIPBYTES( 4 ) // LPBYTE lpReserved2
   MEMBER HANDLE    hStdInput
   MEMBER HANDLE    hStdOutput
   MEMBER HANDLE    hStdError
   // ----------------
   MEMBER POINTER32 _lpAttributeList_  // STARTUPINFOEX // Vista or higher
   // ----------------   constants for wShowWindow
   DYNAMIC PROPERTY swHide             IS CONSTANT 0
   DYNAMIC PROPERTY swShowNormal       IS CONSTANT 1
   DYNAMIC PROPERTY swNormal           IS CONSTANT 1
   DYNAMIC PROPERTY swShowMinimized    IS CONSTANT 2
   DYNAMIC PROPERTY swShowMaximized    IS CONSTANT 3
   DYNAMIC PROPERTY swMaximize         IS CONSTANT 3
   DYNAMIC PROPERTY swShowNoActivate   IS CONSTANT 4
   DYNAMIC PROPERTY swShow             IS CONSTANT 5
   DYNAMIC PROPERTY swMinimize         IS CONSTANT 6
   DYNAMIC PROPERTY swShowMinNoActive  IS CONSTANT 7
   DYNAMIC PROPERTY swShowNA           IS CONSTANT 8
   DYNAMIC PROPERTY swRestore          IS CONSTANT 9
   DYNAMIC PROPERTY swShowDefault      IS CONSTANT 10
   DYNAMIC PROPERTY swForceMinimize    IS CONSTANT 11
   // ----------------   masks for dwFlags
   DYNAMIC PROPERTY lUseShowWindow    IS MASK 0x0001 OF dwFlags
   DYNAMIC PROPERTY lUseSize          IS MASK 0x0002 OF dwFlags
   DYNAMIC PROPERTY lUsePosition      IS MASK 0x0004 OF dwFlags
   DYNAMIC PROPERTY lUseCountChars    IS MASK 0x0008 OF dwFlags
   DYNAMIC PROPERTY lUseFillAttribute IS MASK 0x0010 OF dwFlags
   DYNAMIC PROPERTY lRunFullScreen    IS MASK 0x0020 OF dwFlags
   DYNAMIC PROPERTY lForceOnFeedback  IS MASK 0x0040 OF dwFlags
   DYNAMIC PROPERTY lForceOffFeedback IS MASK 0x0080 OF dwFlags
   DYNAMIC PROPERTY lUseStdHandles    IS MASK 0x0100 OF dwFlags
   // ----------------

END STRUCTURE
//-------------------------------------------------------------------------------------------------------------------------
CLASS TRunProcess FROM _TRunProcess_base_
EXPORTED:
VAR hProcess,hThread,dwProcessId,dwThreadId
VAR cCmdLine,cAppName,cWorkDir,cParams
VAR dwCreationFlags
VAR lInheritHandles
VAR _env_
VAR lBatFile
VAR cUser,cPwd
       // ---------------------------------------------------------------------------------
       // ---------------------------------------------------------------------------------
PROPERTY  lCreateBreakawayFromJob         IS MASK 0x01000000  OF dwCreationFlags
PROPERTY  lCreateDefaultErrorMode         IS MASK 0x04000000  OF dwCreationFlags
PROPERTY  lCreateNewConsole               IS MASK 0x00000010  OF dwCreationFlags
PROPERTY  lCreateNewProcessGroup          IS MASK 0x00000200  OF dwCreationFlags
PROPERTY  lCreateNoWindow                 IS MASK 0x08000000  OF dwCreationFlags
PROPERTY  lCreateProtectedProcess         IS MASK 0x00040000  OF dwCreationFlags
PROPERTY  lCreatePreserveCodeAuthzLevel   IS MASK 0x02000000  OF dwCreationFlags
PROPERTY  lCreateSeparateWowVdm           IS MASK 0x00000800  OF dwCreationFlags
PROPERTY  lCreateSharedWowVdm             IS MASK 0x00001000  OF dwCreationFlags
PROPERTY  lCreateSuspended                IS MASK 0x00000004  OF dwCreationFlags
PROPERTY  lCreateUnicodeEnvironment       IS MASK 0x00000400  OF dwCreationFlags
PROPERTY  lDebugOnlyThisProcess           IS MASK 0x00000002  OF dwCreationFlags
PROPERTY  lDebugProcess                   IS MASK 0x00000001  OF dwCreationFlags
PROPERTY  lDetachedProcess                IS MASK 0x00000008  OF dwCreationFlags
PROPERTY  lExtendedStartupInfoPresent     IS MASK 0x00080000  OF dwCreationFlags
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD CreateInputPipe(hRead,hWrite,nSize)
       local hcp := @kernel32:GetCurrentProcess()
       local hWriteTmp := 0
       DEFAULT nSize := 0
       hRead  := 0
       hWrite := 0
       if @kernel32:CreatePipe(@hRead,@hWriteTmp,{12,0,1},nSize) == 0 ; return .F. ; end
       @kernel32:DuplicateHandle(hcp,hWriteTmp,hcp,@hWrite,0,0,2)
       @kernel32:CloseHandle(hWriteTmp)
       return .T.
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD CreateOutputPipe(hRead,hWrite,nSize)
       local hcp := @kernel32:GetCurrentProcess()
       DEFAULT nSize := 0
       hRead  := 0 ; hWrite := 0
       if @kernel32:CreatePipe(@hRead,@hWrite,{12,0,1},nSize) == 0 ; return .F. ; end
       if @kernel32:SetHandleInformation(hRead,1,0) == 0
          @kernel32:CloseHandle(hRead ); hRead  := 0
          @kernel32:CloseHandle(hWrite); hWrite := 0
          return .F.
       end
       return .T.
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass ; return Self // required for gwst inheritance
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD _CreateProcess_(cUser,cPwd,app,cmd,pa,ta,ih,flags,env,cd,psi,ppi)
       DEFAULT pa :=  {12,0,0} ; DEFAULT ta :=  {12,0,0}
       if cUser == NIL
          return FpQCall( {"kernel32","CreateProcessA"} ,;
                          "__bo__pt__pt__pt__pt__bo__sl__pt__pt__pt__pt",;
                          app,cmd,pa,ta,ih,flags,env,cd,psi,@ppi ;
                        )
       end
       DEFAULT cUser := ""
       DEFAULT cPwd  := 0
       PokeStr(cmd,0,cSzAnsi2Wide(PeekStr(cmd,0,-1)))
       return FpQCall( {"advapi32","CreateProcessWithLogonW"} ,;
                      "__boc_swc_swc_sw__slc_sw__pt__sl__ptc_sw__pt__pt",;
                          cUser,".",cPwd,1,app,cmd,flags,env,cd,psi,@ppi ;
                     )
       // ---------------------------------------------------------------------------------
INLINE METHOD GetExitCodeById()
       local hp := NIL
       local dw := 0
       if Empty(::dwProcessId) ; return NIL ; end
       hp := @kernel32:OpenProcess(0x400,0,::dwProcessId)
       if( Empty(hp) ); return NIL; end
       if @kernel32:GetExitCodeProcess(hp,@dw) == 0 ; dw := NIL ; end
       @kernel32:CloseHandle(hp)
       return dw
       // ---------------------------------------------------------------------------------
INLINE METHOD lTestActiveById()
       local dw := ::GetExitCodeById()
       if dw == NIL ; return .F. ; end
       if dw == NIL ; return .F. ; end
       return (dw == 259)
       // ---------------------------------------------------------------------------------
INLINE METHOD KillById(nExitCode)
       local hp := NIL
       local dw := 0
       local lOk := .F.
       DEFAULT nExitCode := -1
       if Empty(::dwProcessId) ; return NIL ; end
       hp := @kernel32:OpenProcess(1,0,::dwProcessId)
       if( Empty(hp) ); return NIL; end
       lOk := !Empty(@kernel32:TerminateProcess(hp , nExitCode ))
       @kernel32:CloseHandle(hp)
       return dw
       // ---------------------------------------------------------------------------------
INLINE METHOD Release()
       if Valtype(::_env_) == "N" ; _hdict_destroy(::_env_) ; ::_env_ := NIL ; end
       if !Empty( ::hProcess) ; @kernel32:CloseHandle( ::hProcess) ; end
       if !Empty( ::hThread ) ; @kernel32:CloseHandle( ::hThread ) ; end
       ::hProcess := ::hThread := NIL
       ::cDesktop  := NIL ; ::cTitle    := NIL
       return Self
       // --------------------------------------------------------------------
INLINE METHOD init(cUser,cPwd)
       ::hProcess := ::hThread := ::dwProcessId := ::dwThreadId := NIL
       ::_gwst_() ; PokeDWord(Self,0,68)
       ::cCmdLine := ::cAppName := ::cWorkDir := ::cParams := NIL
       ::dwCreationFlags := 0
       ::lInheritHandles := .F.
       ::_env_    := NIL
       ::lBatFile := .F.
       if !lIsWin9x()
          ::cUser    := cUser
          ::cPwd     := cPwd
       end
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Start()
       local aProcInfo     := AFill(Array(4),0)
       local pCmdLine      := 0
       local n,nn,ct
       local lOk           := .F.
       local env           := NIL
       local pa := NIL
       local ta := NIL
       ::hProcess := ::hThread := ::dwProcessId := ::dwThreadId := NIL
       // ---------
       if (::cAppName == NIL) .and. ( ::cCmdLine == NIL ) ; return .F. ; end
       pCmdLine := _xgrab( 0x8000 )  ; n := 0
       if( ::cCmdLine == NIL )
           PokeStr( pCmdLine , @n , ::cAppName )
           if !Empty( ::cParams )
              PokeStr( pCmdLine , @n , Chr(32) + ::cParams )
           end
       else
          PokeStr( pCmdLine , @n , ::cCmdLine )
       end
       // ---------
       if !lIsVista()
          ::lExtendedStartupInfoPresent := .F.
          ::lCreateProtectedProcess     := .F.
       end
       if !lIsXp()
          ::lCreatePreserveCodeAuthzLevel := .F.
       end
       if lIsWin9x()
          ::lCreateBreakawayFromJob   := .F.
          ::lCreateNoWindow           := .F.
          ::lCreateSeparateWowVdm     := .F.
          ::lCreateUnicodeEnvironment := .F.
          ::lDebugProcess             := .F.
       end

       if ::lCreateNewConsole
          ::lDetachedProcess       := .F.
          ::lCreateNewProcessGroup := .F.
       end
       // ---------
       ct := Valtype( ::_env_ )
       if ::_env_ == NIL
          env := 0
       elseif ct == "A"
          env := "" ; nn := Len(::_env_)
          for n := 1 to nn
             if( Valtype(::_env_[n]) == "A" )
                env += AllTrim(::_env_[n][1]) + "=" + AllTrim(::_env_[n][2]) + Chr(0)
             else
                env += AllTrim(::_env_[n]) + Chr(0)
             end
          next
          env += Chrr(0,4)
       elseif ct == "C"
          env := ::_env_ + Chrr(0,4)
       elseif ct == "N"
          env := ""
          _hdict_iterate_cb( ::_env_ , {|_n,_k,_v,_x| _x += cPrintf("%s=%s",_k,_v) + Chr(0) , NIL},@env )
          _hdict_destroy(::_env_) ; ::_env_ := NIL
          env += Chrr(0,4)
       end
       // ---------
       // ---------
       lOk := ::_CreateProcess_(::cUser,::cPwd,::cAppName,pCmdLine,pa,ta,::lInheritHandles,::dwCreationFlags,;
                                 env,::cWorkDir,Self,@aProcInfo)
       _xfree( pCmdLine )
       if lOk
          ::hProcess     := aProcInfo[1]
          ::hThread      := aProcInfo[2]
          ::dwProcessId  := aProcInfo[3]
          ::dwThreadId   := aProcInfo[4]
       end
       return lOk
       // ---------------------------------------------------------------------------------
INLINE METHOD GetExitCode(lActive)
       local dw := 0
       lActive := NIL

       if Empty( ::hProcess ) ; return NIL ; end
       if @kernel32:GetExitCodeProcess(::hProcess,@dw) == 0
          dw := NIL
       elseif dw == 259
          lActive := .T.
       else
          lActive := .F.
       end
       return dw
       // ---------------------------------------------------------------------------------
INLINE METHOD Wait( nMilliseconds) // lComplete | NIL on error
       local oStartTime
       local dw := 0
       local nn := 0
       oStartTime := FileTime64():New():Now()
       DEFAULT nMilliseconds := 0
       if Empty( ::hProcess ) ; return NIL ; end
       while .T.
          dw := @kernel32:WaitForSingleObjectEx( ::hProcess , nMilliseconds - nn , .T.)
          if dw == 0 ; return .T. ; end  // object is signaled
          if dw == 0x102 ; return .F. ; end // WAIT_TIMEOUT
          if dw == 0x80  ; return NIL ; end // WAIT_ABANDONED // must never happen
          if dw == 0xC0  // WAIT_IO_COMPLETION
             if nMilliSeconds > 0
                nn := oStartTime:ElapMilliSeconds()
                if nn >= nMilliseconds ; return .F. ; end  // timeout
             end
          else
             return NIL  // WAIT_FAILED
          end
       end
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Kill(nExitCode)
       DEFAULT nExitCode := -1
       if Empty( ::hProcess ) ; return NIL ; end
       if !Empty(::wait(0)) ; return .T. ; end
       return !Empty(@kernel32:TerminateProcess(::hProcess , nExitCode ))
       // ---------------------------------------------------------------------------------
INLINE METHOD Cmd( cCmdLine , cParams)
       local np := PCount()
       local n,v
       ::lForceOnFeedback := .T.
       ::lForceOffFeedback := .T.
       ::lDetachedProcess := .F.
       if lIsWin9x()
          ::cAppName := GetEnv("comspec")
          if Empty( ::cAppName )
             ::cAppName := cPathCombine( GetWinDir() , "command.com")
          end
       else
          ::cAppName := cPathCombine( GetSysDir() , "cmd.exe")
       end
       ::cCmdLine := ::cAppName
       if !Empty( cCmdLine )
          if np > 1
             ::cCmdLine += cPrintf(," /c \q%s\q", cCmdLine )
          else
             ::cCmdLine += " /c " + cCmdLine
          end
       end
       for n := 2 to np
          v := PValue(n)
          if Valtype(v) == "C"
             ::cCmdLine += Chr(32) + PValue(n)
          end
       next
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD Start16( cApp16 , cParams )
       if Empty( cApp16 ) ; return .F. ; end
       ::cAppName := NIL
       ::cCmdLine := cApp16
       if !Empty( cParams ) ; ::cCmdLine += Space(1) + cParams ; end
       return ::Start()
       // ---------------------------------------------------------------------------------
INLINE METHOD ResetEnv(bClone)
       if Valtype(::_env_) == "N" ; _hdict_destroy(::_env_) ; ::_env_ := NIL ; end
       ::_env_ := _hdict_new()
       if( !Empty(bClone) )
          _hdict_add_env_strings(::_env_)
       end
       return Self
       // ---------------------------------------------------------------------------------
INLINE METHOD GetEnv( k )
       if Valtype(::_env_) != "N" ; ::_env_ := ::_env_ := _hdict_new(); end
       return _hdict_GetProp(::_env_,k)
       // ---------------------------------------------------------------------------------
INLINE METHOD SetEnv( k , v)
       if Valtype(::_env_) != "N" ; ::_env_ := ::_env_ := _hdict_new(); end
       if Valtype(v) == "C"
          _hdict_SetProp(::_env_,k,v)
       else
          _hdict_RemoveProp(::_env_,k)
       end
       return Self
       // ---------------------------------------------------------------------------------
ENDCLASS
//----------------------------------------------------------------------------------------------------------------------

FUNCTION G7RunProcess( cExe , cParams , cWorkDir , cStdOut , cStdErr, nBuffSize)
  LOCAL oProcess := TRunProcess():New()
  LOCAL lActive  := NIL
  LOCAL dwExitCode
  LOCAL hStdOut_read  := 0
  LOCAL hStdOut_write := 0
  LOCAL hStdErr_read  := 0
  LOCAL hStdErr_write := 0
  LOCAL cc,nn
  LOCAL lOk := .F.

  LOCAL oCount := _IO_COUNTERS():new()

  DEFAULT nBuffSize := 0x100000  
  
  oProcess:lInheritHandles := .T.
  oProcess:wShowWindow :=  oProcess:swHide
  oProcess:lUseShowWindow := .T.
  oProcess:lCreateNewConsole := .F.

  oProcess:CreateOutputPipe( @hStdOut_read , @hStdOut_write , nBuffSize )
  oProcess:CreateOutputPipe( @hStdErr_read , @hStdErr_write , nBuffSize )

  oProcess:hStdOutput   := hStdOut_write
  oProcess:hStdError    := hStdErr_write
  oProcess:hStdInput  := 0
  oProcess:lUseStdHandles := .T.

  oProcess:cCmdLine := cExe
  oProcess:cWorkDir := cWorkDir
  oProcess:cParams  := cParams
  cStdOut := ""
  cStdErr := ""

  cc := ChrR(0, nBuffSize )
  IF oProcess:Start()
     WHILE !oProcess:Wait(100)
       @kernel32:FlushFileBuffers(hStdOut_read)
//       nn := FRead(hStdOut_read , @cc , 16 )   // si pianta se non ci sono caratteri
       @kernel32:FlushFileBuffers(hStdErr_read)
//       nn := FRead(hStdErr_read , @cc , 16 )   // si pianta se non ci sono caratteri
//       @kernel32:GetProcessIoCounters(hStdErr_read, oCount) // dovrebbe di se ci sono caratteri nel buffer
     ENDDO
     @kernel32:CloseHandle(hStdOut_write) ; hStdOut_write := 0
     @kernel32:CloseHandle(hStdErr_write) ; hStdErr_write := 0
     cc := ChrR(0, nBuffSize )
     nn := FRead(hStdOut_read , @cc , nBuffSize ) ; if nn > 0 ; cStdOut := Left(cc,nn) ; end
     nn := FRead(hStdErr_read , @cc , nBuffSize ) ; if nn > 0 ; cStdErr := Left(cc,nn) ; end
     lOk := .T.
  ELSE
     @kernel32:CloseHandle(hStdOut_write) ; hStdOut_write := 0
     @kernel32:CloseHandle(hStdErr_write) ; hStdErr_write := 0
  ENDIF
  @kernel32:CloseHandle(hStdOut_read ) ; hStdOut_read  := 0
  @kernel32:CloseHandle(hStdErr_read ) ; hStdErr_read  := 0
  oProcess:Release()
RETURN lOk

BEGIN STRUCTURE _IO_COUNTERS
  MEMBER ULONG ReadOperationCount
  MEMBER ULONG WriteOperationCount
  MEMBER ULONG OtherOperationCount
  MEMBER ULONG ReadTransferCount
  MEMBER ULONG WriteTransferCount
  MEMBER ULONG OtherTransferCount
END STRUCTURE
         
