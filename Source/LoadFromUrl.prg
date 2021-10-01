/*****************************
* Source : LoadFromUrl.prg
* System : 
* Author : Phil Ide
* Created: 19-Aug-2004
*
* Purpose: 
* ----------------------------
* History:                    
* ----------------------------
* 19-Aug-2004 12:15:50 idep - Created
*
* ----------------------------
* Last Revision:
*    $Rev$
*    $Date$
*    $Author$
*    $URL$
*    
*****************************/

// in order to use the news:// protocol urls,
// make sure one of the appropriate libraries
// is declared.  Note that only ONE library
// can be declared!
//
#define __ILIB_INOLIB__     // No sockets library
//#define __ILIB_ASINET__   // ASINET library
//#define __ILIB_XB2NET__   // Xb2NET library


#include "Common.ch"
#include "dll.ch"
#include "Xbpcre.ch"
#include "LFromUrl.ch"

#ifdef __ILIB_ASINET__
   #include "asinetc.ch"
#endif
#ifdef __ILIB_XB2NET__
   #include "xb2net.ch"
   #pragma Library("XB2NET.LIB")
#endif
#ifdef __ILIB_INOLIB__
   #define AF_INET 0
   #define SOCK_STREAM 0
#endif

#pragma Library("XbPCRE.LIB")

#define CRLF Chr(13)+Chr(10)

#define USER_AGENT 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)'

#define CLASS_NAME LoadFromUrlObject

STATIC sDefHttpHeaders

/*#ifdef _TEST_
   Procedure Main( cUrl )
      local a
      local i

      //default cUrl to 'http://www.idep.org.uk/xbase/tencomm.html'
      default cUrl to 'news://news.alaska-software.com/alaska-software.news.3pp/15h6c878vias2.dlg@idep.org.uk'

      ? LoadFromUrl(cUrl)

      return
#endif*/

CLASS CLASS_NAME
   PROTECTED:
      VAR nStatus

   EXPORTED:
      VAR cUrl
      VAR nPortNumber
      VAR nProtocol
      VAR cProxyUrl
      VAR acByPass
      VAR cMethod
      VAR cPostString
      VAR cHttpHeaders
      VAR bPreCall
      VAR lHeadersOnly
      VAR aHeaders
      VAR aAuthInfo
      VAR aSendHeaders
      VAR bFTPCallBack
      VAR lIgnoreBadCerts

      VAR cResource

      METHOD init
      METHOD exec
      METHOD status
ENDCLASS

METHOD CLASS_NAME:init(  cURL       , ;
                        nPortNumber , ;
                        nProtocol   , ;
                        cProxyUrl   , ;
                        acByPass    , ;
                        cMethod     , ;
                        cPostString , ;
                        cHttpHeaders, ;
                        bPreCall    , ;
                        lHeadersOnly, ;
                        aHeaders    , ;
                        aAuthInfo   , ;
                        bProgress   , ;
                        lIgnoreBadCerts)

   ::cUrl            := cUrl
   ::nPortNumber     := nPortNumber
   ::nProtocol       := nProtocol
   ::cProxyUrl       := cProxyUrl
   ::acByPass        := acByPass
   ::cMethod         := cMethod
   ::cPostString     := cPostString
   ::cHttpHeaders    := cHttpHeaders
   ::bPreCall        := bPreCall
   ::lHeadersOnly    := lHeadersOnly
   ::aHeaders        := aHeaders
   ::aAuthInfo       := aAuthInfo
   ::aSendHeaders    := {}
   ::bFTPCallBack    := bProgress
   ::lIgnoreBadCerts := FALSE

   DEFAULT ::aHeaders TO {}

   return self

METHOD CLASS_NAME:exec()
   local aHeaders := {}
   local aSendHeaders := {}
   ::cResource := ''
   ::cResource := G7LoadFromUrl( ::cUrl        ,;
                               ::nPortNumber ,;
                               ::nProtocol   ,;
                               ::cProxyUrl   ,;
                               ::acByPass    ,;
                               ::cMethod     ,;
                               ::cPostString ,;
                               ::cHttpHeaders,;
                               ::bPreCall    ,;
                               ::lHeadersOnly,;
                               @aHeaders    ,;
                               ::aAuthInfo  ,;
                               @aSendHeaders,;
                               ::bFTPCallBack,;
                               ::lIgnoreBadCerts )
   ::nStatus := LoadFromUrlStatus()
   ::aHeaders := aHeaders
   ::aSendHeaders := aSendHeaders
   return !Empty(::cResource)

METHOD CLASS_NAME:status()
   return ::nStatus

Function LoadFromUrlStatus(nNewStatus)
   STATIC nStatus := 0
   local nRet := nStatus

   if !(nNewStatus == NIL) .and. ValType(nNewStatus) == 'N'
      nStatus := nNewStatus
   endif
   return nRet

Function SetHttpDefaultHeaders( cHeaders )
   local xRet := sDefHttpHeaders
   sDefHttpHeaders := cHeaders
   return xRet


// ftp://mirrors.rmplc.co.uk/pub/apache/apr/apr-0.9.6.tar.Z.asc
// gopher://gopher.l-w.ca/0/Theoretical%20Ramblings/A%20Calendrical%20Proposal.txt
// gopher://gopher.l-w.ca/0/Theoretical Ramblings/A Calendrical Proposal.txt

// All the following variations are legal URL's, and are happily accepted
// by this function.  You could of course use "https" instead of "http"
// if the server uses that protocol.
//
// http://www.idep.org.uk:80/xbase/tencomm.html <- no assumptions
// http://www.idep.org.uk/xbase/tencomm.html    <- assumes port 80 (443 for https)
// www.idep.org.uk:80/xbase/tencomm.html        <- assumes http (beware - even if port is 443)
// www.idep.org.uk/xbase/tencomm.html           <- assumes http on port 80
//
// You can also use an IP address instead of the server name in all situations,
// although this is not recommended (See W3C for why).
//
STATIC Function ChopUrlIntoLittleBits( cUrl )
   local aUrl[URL_SIZE]
   local o := RegExp():new('(http://|https://|ftp://|ftps://|gopher://|news://|)(.[^/:]+)(:[0-9]*|)(/.+|)', PCRE_CASELESS )
   local a

   if o:exec(cUrl) > 0
      a := o:result(2)
      if a[2] > 0
         aUrl[URL_PROTOCOL] := lower(SubStr( cUrl, a[1], a[2] ))
      endif

      a := o:result(3)
      if a[2] > 0
         aUrl[URL_HOST] := SubStr( cUrl, a[1], a[2] )
      endif

      a := o:result(4)
      if a[2] > 0
         aUrl[URL_PORT] := Val(SubStr( cUrl, a[1]+1, a[2]-1 ))
      endif
      a := o:result(5)
      if a[2] > 0
         aUrl[URL_URI] := SubStr( cUrl, a[1], a[2] )
      endif

      if ValType(aUrl[URL_PROTOCOL]) == 'C' .and. Empty(aUrl[URL_PROTOCOL])
         aUrl[URL_PROTOCOL] := NIL
      endif
   endif

   aUrl[URL_POSTSTRING] := ""

   // now work out proxy defaults...
   aUrl[URL_ACCESSTYPE] := INTERNET_OPEN_TYPE_PRECONFIG
   aUrl[URL_PROXY] := NULL
   aUrl[URL_BYPASS] := NULL

   return aUrl 

Function G7LoadFromUrl(  cURL       , ;
                        nPortNumber , ;
                        nProtocol   , ;
                        cProxyUrl   , ;
                        acByPass    , ;
                        cMethod     , ;
                        cPostString , ;
                        cHttpHeaders, ;
                        bPreCall    , ;
                        lHeadersOnly, ;
                        aHeaders    , ;
                        aAuthInfo   , ;
                        aSendHeaders, ;
                        bProgress   , ;
                        lIgnoreBadCerts  )

   local i, ic
   local nHTTPFile
   local cBuff
   local nRead    := 1
   local nToRead  := 0
   local cRet     := ''
   local aUrl     := ChopUrlIntoLittleBits( cUrl )
   local lOk      := FALSE
   local cTemp
   local lFetchHeaders
   local nErr := 0
   local cUserName
   local cUserPwd
   local nService
   local lCallBack := Valtype(bProgress) == 'B'
   local lContinue := TRUE
   local nTotSize := 0
   local nFlag := 0

   default  cHttpHeaders to "",;
            cMethod to 'GET',;
            lHeadersOnly to FALSE,;
            lIgnoreBadCerts to FALSE

   lFetchHeaders := TRUE

   if ValType(aAuthInfo) == 'A' .and. Len(aAuthInfo) == 2
      cUserName := aAuthInfo[1]
      cUserPwd  := aAuthInfo[2]
   else
      cUserName := NULL
      cUserPwd  := NULL
   endif

   // all we are doing here is configuring default values for the options.
   // the problem is that some settings can be specified in multiple places
   // and we have to negotiate which has priority.
   //
   // For example, the port can be set in these places:
   //  1. Default setting (http)
   //  2. Url protocol (if http:// or https:// is specified in the url)
   //  3. Port parameter in function call
   //  4. Port parameter in url (e.g. http://www.myhome.com:81/index.htm = port 81)
   //
   // We use the above order to set the value, so a port specified in
   // the url has highest priority.


   default aUrl[URL_PROTOCOL] TO 'http://'

   if left(aUrl[URL_PROTOCOL],3) == 'ftp'
      nService := INTERNET_SERVICE_FTP
   elseif left(aUrl[URL_PROTOCOL],3) == 'gop'
      nService := INTERNET_SERVICE_GOPHER
   elseif left(aUrl[URL_PROTOCOL],3) == 'new'
      nService := INTERNET_SERVICE_NEWS
   else
      nService := INTERNET_SERVICE_HTTP
   endif

   if !(nPortNumber == NIL) .and. (aUrl[URL_PORT] == NIL)
      aUrl[URL_PORT] := nPortNumber
   elseif (aUrl[URL_PORT] == NIL)
      if aUrl[URL_PROTOCOL] == 'https://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_HTTPS_PORT
      elseif aUrl[URL_PROTOCOL] == 'http://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_HTTP_PORT
      elseif aUrl[URL_PROTOCOL] == 'ftps://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_FTP_PORT
      elseif aUrl[URL_PROTOCOL] == 'ftp://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_FTP_PORT
      elseif aUrl[URL_PROTOCOL] == 'gopher://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_GOPHER_PORT
      elseif aUrl[URL_PROTOCOL] == 'news://'
         aUrl[URL_PORT] := INTERNET_DEFAULT_NEWS_PORT
      endif
   endif

   if !(nProtocol == NIL) .and. (aUrl[URL_PROTOCOL] == NIL)
      aUrl[URL_PROTOCOL] := nProtocol
   elseif (aUrl[URL_PROTOCOL] == NIL)
      aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_PUBLIC
   endif

   if ValType(aUrl[URL_PROTOCOL]) == 'C'
      if aUrl[URL_PROTOCOL] == 'https://'
         aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_SECURE
      elseif aUrl[URL_PROTOCOL] == 'http://'
         aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_PUBLIC
      elseif aUrl[URL_PROTOCOL] == 'ftps://'
         aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_SECURE
      elseif aUrl[URL_PROTOCOL] == 'ftp://'
         aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_PUBLIC
      elseif aUrl[URL_PROTOCOL] == 'gopher://'
         aUrl[URL_PROTOCOL] := INTERNET_COMMUNICATION_PUBLIC
      endif
   endif


   // OPTIONS,PUT,DELETE,TRACE,CONNECT not supported
   if !(cMethod == 'GET') .and. !(cMethod == 'POST')
      cMethod := 'GET'
   endif

   if lHeadersOnly
      cMethod := 'HEAD'
   endif

   aUrl[URL_METHOD] := cMethod

   if !(cPostString == NIL)
      aUrl[URL_POSTSTRING] := cPostString
   endif

   // proxy overrides...
   if !(cProxyUrl == NIL)
      aUrl[URL_PROXY] := cProxyUrl
      aUrl[URL_ACCESSTYPE] := INTERNET_OPEN_TYPE_PROXY
   endif

   if ValType(acByPass) == 'A' .and. Len(acByPass) > 0
      aUrl[URL_BYPASS] := ''
      for i := 1 to Len(acByPass)
         aUrl[URL_BYPASS] += acByPass[i]+' '
      next
      aUrl[URL_BYPASS] := Left(aUrl[URL_BYPASS], Len(aUrl[URL_BYPASS])-1 )
   endif

   // finally, see if any default HTTP headers have been configured...
   if !Empty(sDefHttpHeaders)
      cHttpHeaders := sDefHttpHeaders+CRLF+cHttpHeaders
      cHttpHeaders := StrTran( cHttpHeaders, CRLF+CRLF, CRLF )
   endif

   if (InternetAttemptConnect(0) == ERROR_SUCCESS)
      if nService == INTERNET_SERVICE_NEWS
         cRet := GetNewsArticle(aUrl)
      elseif (i := InternetOpenA( USER_AGENT, aUrl[URL_ACCESSTYPE], aUrl[URL_PROXY], aUrl[URL_BYPASS], NULL )) > 0

         ic := InternetConnectA( i, aUrl[URL_HOST], aUrl[URL_PORT], cUserName, cUserPwd, nService, 0, INTERNET_NO_CALLBACK )
         if ic > 0
            aUrl[URL_PROTOCOL] := iif( aUrl[URL_PROTOCOL] == INTERNET_COMMUNICATION_SECURE, INTERNET_FLAG_SECURE, 0 )
            if nService == INTERNET_SERVICE_FTP
               cRet := GetFTPFile(ic,aUrl[URL_URI], bProgress)
            elseif nService == INTERNET_SERVICE_GOPHER
               cRet := GetGopherFile(ic,cUrl, bProgress)
            else
               if lIgnoreBadCerts .and. aUrl[URL_PROTOCOL] == INTERNET_FLAG_SECURE
                  nFlag := INTERNET_FLAG_IGNORE_CERT_CN_INVALID + INTERNET_FLAG_IGNORE_CERT_DATE_INVALID
               endif
               nHTTPFile := HttpOpenRequestA( ic, aUrl[URL_METHOD], aUrl[URL_URI], NULL, NULL, NULL, INTERNET_FLAG_KEEP_CONNECTION+aUrl[URL_PROTOCOL]+nFlag, 0 )
               if nHTTPFile > 0
                  if ValType(bPreCall) == 'B'
                     Eval( bPreCall, nHTTPFile )
                  endif
                  if !HttpSendRequestA( nHTTPFile, cHttpHeaders+chr(0), Len(cHttpHeaders), aUrl[URL_POSTSTRING], Len(aUrl[URL_POSTSTRING]) ) > 0
                     cBuff := Space(8)
                     nRead := 8
                     HttpQueryInfoA( nHTTPFile, HTTP_QUERY_STATUS_CODE, @cBuff, @nRead, NULL )
                     LoadFromUrlStatus( Val(cBuff) )


                     // get SEND headers
                     cBuff := Space(4096)
                     nRead := 4096
                     HttpQueryInfoA( nHTTPFile, HTTP_QUERY_RAW_HEADERS+HTTP_QUERY_FLAG_REQUEST_HEADERS , @cBuff, @nRead, NULL )
                     aSendHeaders := HBuff2Array(cBuff)

                     nErr := GetLastError()
                     nRead := 4096*2
                     cBuff := Space(nRead)
                     HttpQueryInfoA( nHTTPFile, HTTP_QUERY_AUTHORIZATION, @cBuff, @nRead, NULL )
                     aHeaders := HBuff2Array(cBuff)

                  else
                     cBuff := Space(8)
                     nRead := 8
                     HttpQueryInfoA( nHTTPFile, HTTP_QUERY_STATUS_CODE, @cBuff, @nRead, NULL )
                     LoadFromUrlStatus( Val(cBuff) )
                     nErr := GetLastError()
                     nRead := 4096
                     cBuff := Space(nRead)

                     // get SEND headers
                     cBuff := Space(4096)
                     nRead := 4096
                     HttpQueryInfoA( nHTTPFile, HTTP_QUERY_RAW_HEADERS+HTTP_QUERY_FLAG_REQUEST_HEADERS , @cBuff, @nRead, NULL )
                     aSendHeaders := HBuff2Array(cBuff)

                     if !lHeadersOnly
                        if lFetchHeaders
                           nRead := 4096*2
                           cBuff := Space(nRead)
                           HttpQueryInfoA( nHTTPFile, HTTP_QUERY_RAW_HEADERS, @cBuff, @nRead, NULL )
                           aHeaders := HBuff2Array(cBuff)
                        endif
                        if HttpQueryInfoA( nHTTPFile, HTTP_QUERY_CONTENT_LENGTH, @cBuff, @nRead, NULL ) > 0
                           nToRead := Val(cBuff)
                           nTotSize := nToRead
                           nRead := 1
                           While lContinue .and. nRead > 0
                              cBuff := Space(4096)
                              if !(InternetReadFile( nHTTPFile, @cBuff, 4096, @nRead ) > 0)
                                 exit
                              endif
                              cRet += Left(cBuff,nRead)
                              nToRead -= nRead
                              if lCallBack
                                 lContinue := Eval(bProgress, nTotSize, Len(cRet))
                              endif
                           Enddo
                        else

                           nRead := 4096
                           nToRead := 4096
                           While nRead > 0 // keep going for chunked transfers
                              cBuff := Space(nToRead)
                              if !(InternetReadFile( nHTTPFile, @cBuff, nToRead, @nRead ) > 0)
                                 exit
                              endif
                              cRet += Left(cBuff,nRead)
                           Enddo
                        endif
                     else
                        nRead := 4096*2
                        cBuff := Space(nRead)
                        HttpQueryInfoA( nHTTPFile, HTTP_QUERY_RAW_HEADERS, @cBuff, @nRead, NULL )
                        aHeaders := HBuff2Array(cBuff)
                        cRet := aHeaders
                     endif
                     lOk := TRUE
                  endif
                  InternetCloseHandle(nHTTPFile)
               endif
            endif

            InternetCloseHandle(ic)
         endif
         InternetCloseHandle(i)
      endif
   endif
   cRet := iif(Empty(cRet) .and. !lOk, NIL, cRet )
   return cRet

STATIC Function w32_ff()
   local cRet := ''

   cRet += l2bin(0)
   cRet += l2bin(0)+l2bin(0)
   cRet += l2bin(0)+l2bin(0)
   cRet += l2bin(0)+l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)

   cRet += Replicate( Chr(0), MAX_PATH )
   cRet += Replicate( Chr(0), 14 )
   return cRet

STATIC Function gopher_ff()
   local cRet := ''

   cRet += Replicate(Chr(0),MAX_GOPHER_DISPLAY_TEXT+1)
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)
   cRet += l2bin(0)+l2bin(0)
   cRet += Replicate(Chr(0),MAX_GOPHER_LOCATOR_LENGTH+1)
   return cRet

// ftp://ftp.alaska-software.com/documents/mttutor1.pdf
// ftp://ftp.alaska-software.com/fixes/Xpp182/pfl182306.txt
// ftp://ftp.alaska-software.com/fixes/Xpp182/pfl182306.zip
STATIC Function GetFTPFile(nHInternet,cUri, bProgress)
   local hHandle
   local nBytes := 4096
   local cBuff
   local nOk := 1
   local cRet := ''
   local cW32FF := w32_ff() // fname_offset @45
   local nTotSize := 0
   local lCallBack := ValType(bProgress) == 'B'
   local lContinue := TRUE

   local hFFHandle := FtpFindFirstFileA( nHInternet, cUri, @cW32FF, INTERNET_FLAG_NEED_FILE+INTERNET_FLAG_RELOAD, NULL )

   if hFFHandle <> 0
      nTotSize := Bin2U( SubStr( cW32FF, 29, 4 ) )
      if nTotSize > 0
         nTotSize := nTotSize * (MAXDWORD+1)
      endif
      nTotSize += Bin2U( SubStr( cW32FF, 33, 4 ) )
      InternetCloseHandle(hFFHandle)
   endif

   hHandle := FtpOpenFileA(nHInternet, cUri, GENERIC_READ, FTP_TRANSFER_TYPE_BINARY+INTERNET_FLAG_RELOAD )

   if hHandle <> 0
      while lContinue .and. (nOk <> 0 .and. nBytes > 0)
         cBuff := Space(4096)
         nOk := InternetReadFile(hHandle, @cBuff, 4096, @nBytes)
         if nOk <> 0
            cRet += Left(cBuff, nBytes)
         endif
         if lCallBack
            lContinue := Eval(bProgress,nTotSize,Len(cRet))
         endif
      enddo
      InternetCloseHandle(hHandle)
      LoadFromUrlStatus(200)
   else
      LoadFromUrlStatus(404)
   endif
   return cRet


// gopher://gopher.l-w.ca/0/Theoretical Ramblings/A Calendrical Proposal.txt
// gopher://gopher.l-w.ca/0/Theoretical%20Ramblings/A%20Calendrical%20Proposal.txt
// This isn't working yet - I need to request a Gopher locator before continuing...

STATIC Function GetGopherFile(nHInternet,cUrl, bProgress)
   local czUrl := cUrl
   local nH

   altd()
   nH := InternetOpenUrlA(nHInternet, czUrl, NULL, NULL, NULL, NULL )
   InternetCloseHandle(nH)
   return ''

STATIC Function GetGopherFileAAA(nHInternet,aUrl, bProgress)
   local hHandle
   local nBytes := 4096
   local cBuff
   local nOk := 1
   local cRet := ''
   local cW32FF := gopher_ff()
   local nTotSize := 0
   local lCallBack := ValType(bProgress) == 'B'
   local lContinue := TRUE
   local nOffset
   local cGDir := aUrl[URL_URI]
   local cLocator := Replicate(' ',INTERNET_MAX_PATH_LENGTH)
   local cDocument := NULL
   local i
   local nSize := 0
   local hFFHandle
   local nFlags

   local cSrv  := aUrl[URL_HOST]
   local nPort := aUrl[URL_PORT]

   altd()

   if At('/',cGDir) > 0 .and. !(cGDir[-1] == '/')
      i := Rat('/',cGDir)
      cDocument := SubStr( cGDir, i+1 )
      cGDir := Left(cGDir, i-1)
   endif

   nOk := GopherCreateLocatorA(cSrv,nPort, cGDir, NULL, NULL, NULL, @nSize )
   cLocator := Space(nSize)
   nOk := GopherCreateLocatorA(cSrv,nPort, cGDir, NULL, NULL, @cLocator, @nSize )

   cGDir += '/'+cDocument
   hFFHandle := GopherFindFirstFileA( nHInternet, cLocator, NULL, @cW32FF, NULL, NULL )

   if hFFHandle <> 0
      nOffSet := MAX_GOPHER_DISPLAY_TEXT+1+9
      nTotSize := Bin2U( SubStr( cW32FF, nOffset, 4 ) )
      if nTotSize > 0
         nTotSize := nTotSize * (MAXDWORD+1)
      endif
      nOffset := MAX_GOPHER_DISPLAY_TEXT+1+5
      nTotSize += Bin2U( SubStr( cW32FF, nOffset, 4 ) )
      InternetCloseHandle(hFFHandle)
      cLocator := Right(cW32FF,MAX_GOPHER_LOCATOR_LENGTH + 1)
      WriteFile('locator.txt',cW32FF)
   endif

   nFlags := INTERNET_FLAG_HYPERLINK+;
             INTERNET_FLAG_NEED_FILE+;
             INTERNET_FLAG_NO_CACHE_WRITE+;
             INTERNET_FLAG_RELOAD+;
             INTERNET_FLAG_RESYNCHRONIZE

   hHandle := GopherOpenFileA(nHInternet, cW32FF, NULL, nFlags, NULL )

   if hHandle <> 0
      while lContinue .and. (nOk <> 0 .and. nBytes > 0)
         cBuff := Space(4096)
         nOk := InternetReadFile(hHandle, @cBuff, 4096, @nBytes)
         if nOk <> 0
            cRet += Left(cBuff, nBytes)
         endif
         if lCallBack
            lContinue := Eval(bProgress,nTotSize,Len(cRet))
         endif
      enddo
      InternetCloseHandle(hHandle)
      LoadFromUrlStatus(200)
   else
      LoadFromUrlStatus(404)
   endif
   return cRet



Function WriteFile( cFile, cData )
   local nH := FCreate(cFile)
   local i := 0

   if nH > 0
      i := FWrite(nH, cData)
      FClose(nH)
   endif
   return i == Len(cData)

STATIC Function HBuff2Array(cBuff)
   local aRet := {}
   local nStart := 1
   local c
   local i

   while (i := At(Chr(0),cBuff,nStart)) > 0
      c := SubStr( cBuff, nStart, i-nStart )
      if !Empty(c)
         aadd(aRet,c)
      endif
      nStart := i+1
   enddo
   return aRet
   
Function Array2File(cFile, a)
   local i
   local cBuff := ''

   for i := 1 to len(a)
      cBuff += a[i]+CRLF
   next
   WriteFile( cFile, cBuff )
   return NIL


// news url's:
// news://news.alaska-software.com/public.announcements/cCWZ2KEEFHA.6160@S15147418
// news://news.alaska-software.com/public.announcements/19

Function GetNewsArticle(aUrl)
   local cRet := ''
   local cGrp := aUrl[URL_URI]
   local cMsg
   local i
   local nErr := 0
   local nSock

   altd()

#ifdef __ILIB_INOLIB__
   return NIL
#endif
   if Rat('/',cGrp) > 1
      cGrp := SubStr(cGrp,2)
      i := Rat('/',cGrp)
      cMsg := SubStr( cGrp, i+1 )
      cGrp := Left(cGrp,i-1)

      nSock := _socketNew(AF_INET,SOCK_STREAM,0)

      if (ValType(nSock) == 'N' .and. nSock <> 0) .or. (Valtype(nSock) == 'O')
         if _SocketConnect(nSock,,aUrl[URL_HOST], aUrl[URL_PORT],@nErr)
            if Val(_sockrecv(nSock)) == 200
               _SocketSend(nSock,'GROUP '+cGrp)
               if Val(_sockrecv(nSock)) == 211
                  _SocketSend(nSock,'ARTICLE <'+cMsg+'>')
                  cRet := _sockrecv(nSock, TRUE)
                  if Val(cRet) == 220
                     i := At(CRLF,cRet)
                     cRet := SubStr(cRet,i+2)
                  endif
               endif
            endif
            _SocketClose(nSock)
         endif
      endif
   endif
   return cRet


STATIC Function _socketNew(nF,nT,nX)
#ifdef __ILIB_ASINET__
   return SocketNew(nF,nT,nX)
#endif
#ifdef __ILIB_XB2NET__
   return xbSocket():new(nF,nT,nX)
#endif
#ifdef __ILIB_INOLIB__
   return 0
#endif

STATIC Function _SocketConnect(nSock,nAddrF,cHost, nPort,nErr)
#ifdef __ILIB_ASINET__
   return SocketConnect(nSock,nAddrF,cHost, nPort,@nErr)
#endif
#ifdef __ILIB_XB2NET__
   nSock:connect(cHost,nPort)
   return TRUE
#endif
#ifdef __ILIB_INOLIB__
   return FALSE
#endif

STATIC Function _sockrecv( nSock, lTest4End )
   STATIC cOldBuff
   local cBuff
   local i
   local cRet := ''
   local cEolMarker := CRLF

   DEFAULT lTest4End TO FALSE,;
      cOldBuff TO ''

#ifdef __ILIB_ASINET__
   cRet := cOldBuff
   cOldBuff := ''
   While TRUE
      if lTest4End
         i := At(CRLF+'.'+CRLF, cRet)
         if i > 0
            cOldBuff := SubStr(cRet,i+5)
            cRet := Left(cRet,i+1)
            exit
         endif
      elseif (i := At(CRLF,cRet)) > 0
         cOldBuff := SubStr(cRet,i+2)
         cRet := Left(cRet,i+1)
         exit
      endif
      cBuff := Space(512)
      i := SocketRecv( nSock, @cBuff )
      cRet += Left(cBuff, i)
   Enddo
   memowrit('mess3.txt',cRet)
#endif
#ifdef __ILIB_XB2NET__
   if lTest4End
      cEolMarker := CRLF+'.'+CRLF
   endif
   cRet := nSock:recvLine(cEolMarker)
   if lTest4End .and. !Empty(cRet)
      cRet := StrTran(cRet,CRLF+'..', CRLF+'.' )
      // now strip off trailing '.'+CRLF
      cRet := Left(cRet,Len(cRet)-3)
   endif
#endif
#ifdef __ILIB_INOLIB__
#endif
   return cRet

STATIC Function _socketsend( nSock, cData )
   local i := 0
   local n := 0
   local v := Len(cData)+2

   cData += CRLF

#ifdef __ILIB_ASINET__
   if Len(cData) > 2 .and. nSock <> NIL
      While n < v
         i := SocketSend( nSock, cData )
         n += i
         if n < v
            cData := SubStr( cData, i+1 )
         endif
      Enddo
   endif
#endif
#ifdef __ILIB_XB2NET__
   nSock:send(cData)
#endif
#ifdef __ILIB_INOLIB__
#endif
   return NIL

STATIC Function _socketClose( nSock )
#ifdef __ILIB_ASINET__
   SocketClose(nSock)
#endif
#ifdef __ILIB_XB2NET__
   nSock:close()
#endif
#ifdef __ILIB_INOLIB__
#endif
   return Nil


DLLFUNCTION InternetAttemptConnect(n) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetOpenA( cAgent, dwAcessType, lpProxy, lpByPass, nFlags ) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetConnectA( h, cSrv, nPort, cUser, cPwd, nService, nFlags, nContext ) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetOpenUrlA( h, cUrl, cHead, nHead, nFlags, dwContext ) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetReadFile( n, @c, nS, @nR ) USING STDCALL FROM WinInet.dll
DLLFUNCTION GetLastError() USING STDCALL FROM Kernel32.dll
DLLFUNCTION HttpOpenRequestA(n,lpVerb, lpTarget,lpVer,lpReferer,lpAccept,nFlags,nContext) USING STDCALL FROM WinInet.dll
DLLFUNCTION HttpSendRequestA(n,cHead,nHead,lpOpt,nOptS) USING STDCALL FROM WinInet.dll
DLLFUNCTION HttpQueryInfoA(n,nInfo,@lpBuffer,@lpBLen,nIndex) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetCloseHandle(n) USING STDCALL FROM WinInet.dll
DLLFUNCTION AddRequestHeadersA(h,cHeaders,nHeadLen,nModifier) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetSetOptionA(h,n,lpbuff,nblen) USING STDCALL FROM WinInet.dll
DLLFUNCTION FtpOpenFileA(nH,c,n,nd) USING STDCALL FROM WinInet.dll
DLLFUNCTION FtpFindFirstFileA(nH,c,@W32,n,d) USING STDCALL FROM WinInet.dll
DLLFUNCTION GopherFindFirstFileA(nH,c,n,@cW,x,y) USING STDCALL FROM WinInet.dll
DLLFUNCTION GopherOpenFileA(nH,c,e,i,o) USING STDCALL FROM WinInet.dll
DLLFUNCTION GopherCreateLocatorA(a,b,c,d,e,@f,@g) USING STDCALL FROM WinInet.dll
DLLFUNCTION InternetFindNextFileA(h,@c) USING STDCALL FROM WinInet.dll


