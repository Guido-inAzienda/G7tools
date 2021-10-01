#INCLUDE "ot4xb.ch"
//-------------------------------------------------------------------------------------------------------------------------
#XTRANSLATE _m_assert_( <cond> , <msg> ) => ;
            iif( <cond> ,,;
            ( TlsStackPush(Error():New()) ,TlsStackTop():severity := 2,;
              TlsStackTop():subsystem   := ::ClassName() ,;
              TlsStackTop():description := <msg> ,;
              Eval(ErrorBlock(),TlsStackPop() ) ))
//-------------------------------------------------------------------------------------------------------------------------
#XTRANSLATE  wsp.Open( [<params,...>])  => ;
             FpQCall({"winspool.drv","OpenPrinterA"} ,"__bo__pt_@sl__pt"  [,<params>] )
#XTRANSLATE  wsp.Close( [<params,...>])  => ;
             FpQCall({"winspool.drv","ClosePrinter"} ,"__bo__sl"  [,<params>] )
#XTRANSLATE  wsp.StartDoc( [<params,...>])  =>;
             FpQCall({"winspool.drv","StartDocPrinterA"} ,"__sl__sl__sl__pt"  [,<params>] )
#XTRANSLATE  wsp.EndDoc( [<params,...>])  =>;
             FpQCall({"winspool.drv","EndDocPrinter"} ,"__bo__sl"  [,<params>] )
#XTRANSLATE  wsp.Write( [<params,...>])  =>;
             FpQCall({"winspool.drv","WritePrinter"} ,"__bo__sl__pt__ul_@sl"  [,<params>] )
#XTRANSLATE  wsp.StartPage( [<params,...>])  =>;
             FpQCall({"winspool.drv","StartPagePrinter"} ,"__bo__sl"  [,<params>] )
#XTRANSLATE  wsp.EndPage( [<params,...>])  =>;
             FpQCall({"winspool.drv","EndPagePrinter"} ,"__bo__sl"  [,<params>] )
//-------------------------------------------------------------------------------------------------------------------------
CLASS TPrintRaw
EXPORTED:
VAR hPrt
VAR dwDocId                                  
VAR _nLastError_
VAR _nLanguageId_
       // ---------------------------------------------------------------------------------
INLINE ACCESS METHOD nLastError() ; return ::_nLastError_
       // ---------------------------------------------------------------------------------
INLINE ACCESS METHOD cLastError()
       DEFAULT ::_nLastError_ := 0
       RETURN cFmtSysMsg(::_nLastError_ , ::_nLanguageId_)
       // ---------------------------------------------------------------------------------
INLINE METHOD init(nLanguage,nSubLanguage)
       _m_assert_( ::hPrt == NIL , "Object already initialized" )
       _m_assert_( ::dwDocId == NIL , "Object already initialized" )
       ::hPrt := 0 ; ::dwDocId := 0
       ::_nLastError_ := 0                                  
       DEFAULT nLanguage     := LANG_NEUTRAL
       DEFAULT nSubLanguage  := SUBLANG_SYS_DEFAULT
       ::_nLanguageId_ := MAKELANGID(nLanguage,nSubLanguage) 
       RETURN Self
       // ---------------------------------------------------------------------------------
INLINE METHOD Open( cPrinterName )
       LOCAL result
       _m_assert_( Valtype(cPrinterName) == "C" , "Invalid Printer Name" )
       result := wsp.Open(cPrinterName, @Self:hPrt,0)
       ::_nLastError_ := nFpGetLastError()
       RETURN result
       // ---------------------------------------------------------------------------------
INLINE METHOD Close()
       LOCAL result := wsp.Close(::hPrt)
       ::_nLastError_ := nFpGetLastError()
       ::hPrt := 0
       RETURN result
       // ---------------------------------------------------------------------------------
INLINE METHOD StartDoc(cDocName)
       LOCAL p
       DEFAULT cDocName := cPathRemoveExt(AppName(.F.)) + " Print Job"
       p := _xgrab( "RAW" + Chr(0) + cDocName + Chr(0) )   
       ::dwDocId := wsp.StartDoc(::hPrt,1,{p+4,0,p})
       ::_nLastError_ := nFpGetLastError()
       _xfree(p)
       RETURN ( ::dwDocId != 0 )
       // ---------------------------------------------------------------------------------
INLINE METHOD EndDoc()
       LOCAL result
       ::dwDocId := 0
       result := wsp.EndDoc( ::hPrt )
       ::_nLastError_ := nFpGetLastError()
       RETURN result
       // ---------------------------------------------------------------------------------
INLINE METHOD StartPage()
       LOCAL result := wsp.StartPage( ::hPrt )
       ::_nLastError_ := nFpGetLastError()
       RETURN result
       // ---------------------------------------------------------------------------------
INLINE METHOD EndPage()
       LOCAL result := wsp.EndPage( ::hPrt )
       ::_nLastError_ := nFpGetLastError()
       RETURN result
       // ---------------------------------------------------------------------------------
INLINE METHOD Write(cStr,nWritten) 
       LOCAL result                   
       DEFAULT nWritten := 0
       ::_nLastError_ := 0
       if Valtype(cStr) != "C" ; return .T. ; end
       result := wsp.Write( ::hPrt , cStr ,Len(cStr),@nWritten)
       ::_nLastError_ := nFpGetLastError()
       RETURN result
       // ---------------------------------------------------------------------------------
ENDCLASS
//-------------------------------------------------------------------------------------------------------------------------
