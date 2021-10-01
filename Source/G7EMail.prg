#INCLUDE "ot4xb.ch"
#INCLUDE "ot4xb_mini_rt_asm.ch"
// ---------------------------------------------------------------------------
/*PROCEDURE Main()
local cCmd := "Uno.txt "
cCmd += " -ti 90 -noh -noh2 -r -d -ur -debug "
//cCmd += ' -server "smtp.yourmailserver.com" -u "username" -pw "SmtpPasswordIfRequired" -port 25 '
cCmd += ' -server "192.168.0.10" -u "guido@miaazienda.it" -pw "1nculO" -port 25 '
//cCmd += ' -serverIMAP "192.168.0.10" -iu "guido@miaazienda.it" -ipw "1nculO" -portIMAP 143 '
cCmd += " -subject " + Chr(34) + "[Testing blat]" + Chr(34) + Chr(32)
cCmd += ' -f "My Name<name@domain.com>" '
cCmd += ' -i "guido@miaazienda.it" '
//cCmd += ' -attach "Uno.txt","Dos.txt","Tres.txt" '
//cCmd += ' -attacht "Uno.txt","Dos.txt","Tres.txt" '
//cCmd += ' -attachi "Uno.txt","Dos.txt","Tres.txt" '
cCmd += ' -to  "Receiver name <info@miaazienda.it>" '
//cCmd += ' -bcc "Receiver name <receiver@server.com>" '
cCmd += ' -x "X-Mailer: My Program" '
cCmd += ' -x "X-OtraMas: Anything else you want as an extra header" '
cCmd += ' -replyto guido@miaazienda.it '
? G7EMailBlat():Send( cCmd )
? G7EMailBlat:cLog
? "---------"
Inkey(0)
RETURN*/
//-------------------------------------------------------------------------------------------------------------------------
CLASS G7EMailBlat
EXPORTED:
CLASS VAR cLog
CLASS VAR hLib                                                       
CLASS VAR cs
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass()
       LOCAL __asm__ := ""
       LOCAL n := 0
       LOCAL fp
       ::cLog := ""
       ::hLib := nLoadLibrary( "blat.dll" )
       __asm __stdcall_prolog_(0)
       __asm mov eax , arg 1
       __asm push eax
       __asm push dword _xgrab("StrOut")
       __asm push dword _var2con( Self )
       __asm __call__cdecl(nGetProcAddress(GethOt4xb(),"?_conMCallVoid@@YAXPAUMomHandleEntry@@PAD1@Z"),3)
       __asm __stdcall_epilog_( 1 )
       fp := _xgrab(__asm__,@n)
       @kernel32:VirtualProtect(fp,n,64,@n)
       @blat:SetPrintFunc(fp)
       ::cs := TCriticalSection():New() 
       // as blat.dll don't support multithread. Calls are serialized with a critical section   
       ot4xb_push_exit_cb( {|| ::cs:Destroy() , ::cs := NIL } )
RETURN self
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD Send(cCmd)
       LOCAL result := -1 // unable to load blat.dll
       LOCAL eb
       
       IF( !Empty(::hLib).and. !Empty( cCmd ) )                                                           
          IF !::cs:TryLock()
             return -2 // busy
          ENDIF
          eb := ErrorBlock( {|| result := -3 , Break() } )
          BEGIN SEQUENCE
             result := @blat:Send(cCmd)
          END SEQUENCE
          eb := ErrorBlock( eb )
          ::cs:unlock()
       ENDIF
RETURN result
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD StrOut( cStr )
       // modify this method to send the output elsewhere ( ex: PostAppEvent(.... ) )
       //? cStr
       ::cLog += cStr
       RETURN NIL
       // ---------------------------------------------------------------------------------
ENDCLASS
// ---------------------------------------------------------------------------
