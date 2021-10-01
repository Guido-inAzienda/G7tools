#include "ot4xb.ch"       
#include "ot4xb_mini_rt_asm.ch"
//----------------------------------------------------------------------------------------------------------------------
#ifndef BFFM_INITIALIZED
#define BFFM_INITIALIZED        1
#define BFFM_SELCHANGED         2
#define BFFM_VALIDATEFAILED     3
#define BFFM_IUNKNOWN           5
#define BFFM_SETSTATUSTEXT      0x464
#define BFFM_ENABLEOK           0x465
#define BFFM_SETSELECTION       0x466
#define BIF_RETURNONLYFSDIRS   0x0001
#define BIF_DONTGOBELOWDOMAIN  0x0002
#define BIF_STATUSTEXT         0x0004
#define BIF_RETURNFSANCESTORS  0x0008
#define BIF_EDITBOX            0x0010
#define BIF_VALIDATE           0x0020
#define BIF_NEWDIALOGSTYLE     0x0040
#define BIF_USENEWUI           nOr(BIF_NEWDIALOGSTYLE , BIF_EDITBOX)
#define BIF_BROWSEINCLUDEURLS  0x0080
#define BIF_UAHINT             0x0100
#define BIF_NONEWFOLDERBUTTON  0x0200
#define BIF_NOTRANSLATETARGETS 0x0400
#define BIF_BROWSEFORCOMPUTER  0x1000
#define BIF_BROWSEFORPRINTER   0x2000
#define BIF_BROWSEINCLUDEFILES 0x4000
#define BIF_SHAREABLE          0x8000  
#endif
//----------------------------------------------------------------------------------------------------------------------
BEGIN STRUCTURE BROWSEINFO_struct
   MEMBER HWND        hwndOwner
   MEMBER POINTER32   pidlRoot
   MEMBER LPSTR       pszDisplayName  DYNSZ cDisplayName
   MEMBER LPSTR       lpszTitle       DYNSZ cTitle
   MEMBER UINT        ulFlags
   MEMBER DWORD       lpfn
   MEMBER LONG        lParam
   MEMBER LONG        iImage
END STRUCTURE
//----------------------------------------------------------------------------------------------------------------------
CLASS TBrowseForFolder  FROM BROWSEINFO_struct
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR cFolder
       // ---------------------------------------------------------------------------------
INLINE CLASS METHOD initclass ; return NIL // required on 1st gwst subclass even if empty
       // ---------------------------------------------------------------------------------
INLINE METHOD _gen_callback_()
       local pSelf               :=  _var2con( Self )
       local pMethodName         :=  _xgrab("callback")
       local hXppRt1             :=  @kernel32:GetModuleHandleA("xpprt1.dll")
       local p__conNew           :=  nGetProcAddress(hXppRt1,"__conNew")
       local p__conPutNL         :=  nGetProcAddress(hXppRt1,"__conPutNL")
       local p__conCallMethodPa  :=  nGetProcAddress(hXppRt1,"__conCallMethodPa")
       local p__conGetNL         :=  nGetProcAddress(hXppRt1,"__conGetNL")
       local p__conRelease       :=  nGetProcAddress(hXppRt1,"__conRelease")
       local __asm__ := ""
       local n,p

       __asm __stdcall_prolog_(7)        // v1_conr,v2_p4,v3_p3,v4_p2,v5_p1,v6_Self,v7_retval
       
       // v1_conr
       __asm push dword 0
       __asm push dword 0
          __asm __call__cdecl( p__conPutNL , 2 )
       __asm mov var 1 , eax
       // v2_p4 to v5_p1
       for n := 2 to 5
          __asm mov  eax , arg (6-n)
          __asm push eax
          __asm push dword 0
          __asm __call__cdecl( p__conPutNL , 2 )
          __asm mov var n , eax
       next
       // v6_Self
       __asm push dword pSelf
       __asm __call__cdecl( p__conNew , 1 )
       __asm mov var 6 , eax
       
       // v7_retval
       __asm mov  dword var 7 , val 0                                                          
       
       // call the xb method
       __asm lea eax , var 6                     
       __asm push eax
       __asm push dword 5
       __asm push dword pMethodName
       __asm mov eax , var 1
       __asm push eax
       __asm __call__cdecl( p__conCallMethodPa , 4 )
       
       // store result from con v1 into v7
       __asm lea eax , var 7
       __asm push eax
       __asm mov eax , var 1
       __asm push eax
       __asm __call__cdecl( p__conGetNL , 2 )
       // release all the xb containers
       for n := 1 to 6
          __asm mov  eax , var n
          __asm push eax
          __asm __call__cdecl( p__conRelease , 1 )
       next
       // return v7
       __asm mov eax , var 7
       __asm __stdcall_epilog_( 4 )  
       // store and make the callback                                                                       
       n := Len(__asm__)                              
       p := _xgrab( nOr(n,15) + 1 + 16)
       PokeStr(p,16,__asm__)
       PokeDWord(p,0,n)
       PokeDWord(p,4,pMethodName)
       PokeDWord(p,8,pSelf)
       @kernel32:VirtualProtect(p+16,n,64,p+12)
       return p+16
       // ---------------------------------------------------------------------------------
INLINE METHOD _destroy_callback_(pcbk)
       local p
       if Empty(pcbk) ; return NIL ; end
       p := pcbk-16
       _xfree( PeekDWord(p,4) )
       _conRelease( PeekDWord(p,8) )
       @kernel32:VirtualProtect(p+16,PeekDWord(p),PeekDWord(p,12),p+12)
       _xfree(p)
       pcbk := 0
       return NIL
       // ---------------------------------------------------------------------------------
INLINE METHOD callback( hWnd,nMsg,lp,pData) 
       local p
       if nMsg == BFFM_INITIALIZED                      
          if !Empty( ::cFolder )
             @user32:SendMessageA(hWnd,BFFM_SETSELECTION,1,::cFolder)
          end                               
          @user32:SetForegroundWindow( hWnd)
          
          return 0
       elseif nMsg = BFFM_SELCHANGED
          p := _xgrab(512)
          if( @shell32:SHGetPathFromIDListA(lp,p) != 0)
             @user32:SendMessageA(hWnd,BFFM_SETSTATUSTEXT,0,p)
          end
          _xfree(p)
          return 0
       end
       return 0
       // ---------------------------------------------------------------------------------
INLINE METHOD run( cFolder )
       local pidl
       local cResult := NIL   
       BYNAME cFolder
       @ole32:OleInitialize(0)
       ::ulFlags := nOr( ::ulFlags,BIF_RETURNONLYFSDIRS,BIF_STATUSTEXT)
       ::lpfn := ::_gen_callback_()
       pidl := @shell32:SHBrowseForFolderA(Self)
       if pidl != 0  
          cResult := ChrR(0,384)
          if @shell32:[__bo__sl__pt]:SHGetPathFromIDListA(pidl,@cResult)
             cResult := TrimZ(cResult)
          else
             cResult := NIL
          end
          @ole32:CoTaskMemFree(pidl)
       end
       @ole32:OleUninitialize()
       ::_destroy_callback_( ::lpfn ) ; ::lpfn := 0
       ::cDisplayName := NIL
       ::cTitle       := NIL
       return cResult
       // ---------------------------------------------------------------------------------

ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
