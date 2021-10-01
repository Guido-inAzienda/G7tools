/*****************************
* Source : lfromurl.ch
* System : 
* Author : Phil Ide
* Created: 20-Aug-2004
*
* Purpose: 
* ----------------------------
* History:                    
* ----------------------------
* 20-Aug-2004 00:16:46 idep - Created
*
* ----------------------------
* (Subversion Macros)
* Last Revision:
*    $Rev$
*    $Date$
*    $Author$
*    $URL$
*    
*****************************/

#ifndef _LOADFROMURL2_
   #define _LOADFROMURL2_

   #define NULL 0
   #define ERROR_SUCCESS 0

   #define GENERIC_READ                     (0x80000000)
   #define GENERIC_WRITE                    (0x40000000)
   #define GENERIC_EXECUTE                  (0x20000000)
   #define GENERIC_ALL                      (0x10000000)

   #define MAXDWORD    0xffffffff
   #define MAX_PATH 260

   #define INTERNET_MAX_HOST_NAME_LENGTH   256
   #define INTERNET_MAX_USER_NAME_LENGTH   128
   #define INTERNET_MAX_PASSWORD_LENGTH    128
   #define INTERNET_MAX_PORT_NUMBER_LENGTH 5           // INTERNET_PORT is unsigned short
   #define INTERNET_MAX_PORT_NUMBER_VALUE  65535       // maximum unsigned short value
   #define INTERNET_MAX_PATH_LENGTH        2048
   #define INTERNET_MAX_SCHEME_LENGTH      32          // longest protocol name length
   #define INTERNET_MAX_URL_LENGTH         (INTERNET_MAX_SCHEME_LENGTH ;
                                           + sizeof("://") ;
                                           + INTERNET_MAX_PATH_LENGTH)

   #define MAX_GOPHER_DISPLAY_TEXT     128
   #define MAX_GOPHER_SELECTOR_TEXT    256
   #define MAX_GOPHER_HOST_NAME        INTERNET_MAX_HOST_NAME_LENGTH
   #define MAX_GOPHER_LOCATOR_LENGTH   (1                                  ;
                                       + MAX_GOPHER_DISPLAY_TEXT           ;
                                       + 1                                 ;
                                       + MAX_GOPHER_SELECTOR_TEXT          ;
                                       + 1                                 ;
                                       + MAX_GOPHER_HOST_NAME              ;
                                       + 1                                 ;
                                       + INTERNET_MAX_PORT_NUMBER_LENGTH   ;
                                       + 1                                 ;
                                       + 1                                 ;
                                       + 2                                 ;
                                       )
   
   #define GOPHER_TYPE_TEXT_FILE       0x00000001
   #define GOPHER_TYPE_DIRECTORY       0x00000002
   #define GOPHER_TYPE_CSO             0x00000004
   #define GOPHER_TYPE_ERROR           0x00000008
   #define GOPHER_TYPE_MAC_BINHEX      0x00000010
   #define GOPHER_TYPE_DOS_ARCHIVE     0x00000020
   #define GOPHER_TYPE_UNIX_UUENCODED  0x00000040
   #define GOPHER_TYPE_INDEX_SERVER    0x00000080
   #define GOPHER_TYPE_TELNET          0x00000100
   #define GOPHER_TYPE_BINARY          0x00000200
   #define GOPHER_TYPE_REDUNDANT       0x00000400
   #define GOPHER_TYPE_TN3270          0x00000800
   #define GOPHER_TYPE_GIF             0x00001000
   #define GOPHER_TYPE_IMAGE           0x00002000
   #define GOPHER_TYPE_BITMAP          0x00004000
   #define GOPHER_TYPE_MOVIE           0x00008000
   #define GOPHER_TYPE_SOUND           0x00010000
   #define GOPHER_TYPE_HTML            0x00020000
   #define GOPHER_TYPE_PDF             0x00040000
   #define GOPHER_TYPE_CALENDAR        0x00080000
   #define GOPHER_TYPE_INLINE          0x00100000
   #define GOPHER_TYPE_UNKNOWN         0x20000000
   #define GOPHER_TYPE_ASK             0x40000000
   #define GOPHER_TYPE_GOPHER_PLUS     0x80000000


   #define FTP_TRANSFER_TYPE_UNKNOWN   0x00000000
   #define FTP_TRANSFER_TYPE_ASCII     0x00000001
   #define FTP_TRANSFER_TYPE_BINARY    0x00000002

   #define INTERNET_INVALID_PORT_NUMBER    0           // use the protocol-specific default

   #define INTERNET_DEFAULT_FTP_PORT       21          // default for FTP servers
   #define INTERNET_DEFAULT_GOPHER_PORT    70          //    "     "  gopher "
   #define INTERNET_DEFAULT_HTTP_PORT      80          //    "     "  HTTP   "
   #define INTERNET_DEFAULT_NEWS_PORT     119          //    "     "  HTTP   "
   #define INTERNET_DEFAULT_HTTPS_PORT     443         //    "     "  HTTPS  "
   #define INTERNET_DEFAULT_SOCKS_PORT     1080        // default for SOCKS firewall servers.

   #define INTERNET_SERVICE_FTP    1
   #define INTERNET_SERVICE_GOPHER 2
   #define INTERNET_SERVICE_HTTP   3
   #define INTERNET_SERVICE_NEWS   4

   #define INTERNET_COMMUNICATION_SECURE   0
   #define INTERNET_COMMUNICATION_PUBLIC   1


   #define INTERNET_OPEN_TYPE_PRECONFIG                    0   // use registry configuration
   #define INTERNET_OPEN_TYPE_DIRECT                       1   // direct to net
   #define INTERNET_OPEN_TYPE_PROXY                        3   // via named proxy
   #define INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY  4   // prevent using java/script/INS

   #define INTERNET_FLAG_SECURE            0x00800000  // use PCT/SSL if applicable (HTTP)
   #define INTERNET_FLAG_RAW_DATA          0x40000000  // FTP/gopher find: receive the item as raw (structured) data
   #define INTERNET_FLAG_EXISTING_CONNECT  0x20000000  // FTP: use existing InternetConnect handle for server if possible
   #define INTERNET_FLAG_ASYNC             0x10000000  // this request is asynchronous (where supported)
   #define INTERNET_FLAG_PASSIVE           0x08000000  // used for FTP connections
   #define INTERNET_FLAG_NO_CACHE_WRITE    0x04000000  // don't write this item to the cache
   #define INTERNET_FLAG_DONT_CACHE        INTERNET_FLAG_NO_CACHE_WRITE
   #define INTERNET_FLAG_MAKE_PERSISTENT   0x02000000  // make this item persistent in cache
   #define INTERNET_FLAG_FROM_CACHE        0x01000000  // use offline semantics
   #define INTERNET_FLAG_OFFLINE           INTERNET_FLAG_FROM_CACHE
   #define INTERNET_FLAG_KEEP_CONNECTION   0x00400000  // use keep-alive semantics
   #define INTERNET_FLAG_NO_AUTO_REDIRECT  0x00200000  // don't handle redirections automatically
   #define INTERNET_FLAG_READ_PREFETCH     0x00100000  // do background read prefetch
   #define INTERNET_FLAG_NO_COOKIES        0x00080000  // no automatic cookie handling
   #define INTERNET_FLAG_NO_AUTH           0x00040000  // no automatic authentication handling
   #define INTERNET_FLAG_RESTRICTED_ZONE   0x00020000  // apply restricted zone policies for cookies, auth
   #define INTERNET_FLAG_CACHE_IF_NET_FAIL 0x00010000  // return cache file if net request fails
   #define INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP   0x00008000 // ex: https:// to http://
   #define INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS  0x00004000 // ex: http:// to https://
   #define INTERNET_FLAG_IGNORE_CERT_DATE_INVALID  0x00002000 // expired X509 Cert.
   #define INTERNET_FLAG_IGNORE_CERT_CN_INVALID    0x00001000 // bad common name in X509 Cert.
   #define INTERNET_FLAG_RESYNCHRONIZE     0x00000800  // asking wininet to update an item if it is newer
   #define INTERNET_FLAG_HYPERLINK         0x00000400  // asking wininet to do hyperlinking semantic which works right for scripts
   #define INTERNET_FLAG_NO_UI             0x00000200  // no cookie popup
   #define INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100  // asking wininet to add "pragma: no-cache"
   #define INTERNET_FLAG_CACHE_ASYNC       0x00000080  // ok to perform lazy cache-write
   #define INTERNET_FLAG_FORMS_SUBMIT      0x00000040  // this is a forms submit
   #define INTERNET_FLAG_FWD_BACK          0x00000020  // fwd-back button op
   #define INTERNET_FLAG_NEED_FILE         0x00000010  // need a file for this request
   #define INTERNET_FLAG_MUST_CACHE_REQUEST INTERNET_FLAG_NEED_FILE
   #define INTERNET_FLAG_TRANSFER_ASCII    FTP_TRANSFER_TYPE_ASCII     // 0x00000001
   #define INTERNET_FLAG_TRANSFER_BINARY   FTP_TRANSFER_TYPE_BINARY    // 0x00000002
   #define INTERNET_FLAG_RELOAD            0x80000000  // retrieve the original item

   #define INTERNET_NO_CALLBACK            0

   #define HTTP_QUERY_MIME_VERSION                 0
   #define HTTP_QUERY_CONTENT_TYPE                 1
   #define HTTP_QUERY_CONTENT_TRANSFER_ENCODING    2
   #define HTTP_QUERY_CONTENT_ID                   3
   #define HTTP_QUERY_CONTENT_DESCRIPTION          4
   #define HTTP_QUERY_CONTENT_LENGTH               5
   #define HTTP_QUERY_CONTENT_LANGUAGE             6
   #define HTTP_QUERY_ALLOW                        7
   #define HTTP_QUERY_PUBLIC                       8
   #define HTTP_QUERY_DATE                         9
   #define HTTP_QUERY_EXPIRES                      10
   #define HTTP_QUERY_LAST_MODIFIED                11
   #define HTTP_QUERY_MESSAGE_ID                   12
   #define HTTP_QUERY_URI                          13
   #define HTTP_QUERY_DERIVED_FROM                 14
   #define HTTP_QUERY_COST                         15
   #define HTTP_QUERY_LINK                         16
   #define HTTP_QUERY_PRAGMA                       17
   #define HTTP_QUERY_VERSION                      18  // special: part of status line
   #define HTTP_QUERY_STATUS_CODE                  19  // special: part of status line
   #define HTTP_QUERY_STATUS_TEXT                  20  // special: part of status line
   #define HTTP_QUERY_RAW_HEADERS                  21  // special: all headers as ASCIIZ
   #define HTTP_QUERY_RAW_HEADERS_CRLF             22  // special: all headers
   #define HTTP_QUERY_CONNECTION                   23
   #define HTTP_QUERY_ACCEPT                       24
   #define HTTP_QUERY_ACCEPT_CHARSET               25
   #define HTTP_QUERY_ACCEPT_ENCODING              26
   #define HTTP_QUERY_ACCEPT_LANGUAGE              27
   #define HTTP_QUERY_AUTHORIZATION                28
   #define HTTP_QUERY_CONTENT_ENCODING             29
   #define HTTP_QUERY_FORWARDED                    30
   #define HTTP_QUERY_FROM                         31
   #define HTTP_QUERY_IF_MODIFIED_SINCE            32
   #define HTTP_QUERY_LOCATION                     33
   #define HTTP_QUERY_ORIG_URI                     34
   #define HTTP_QUERY_REFERER                      35
   #define HTTP_QUERY_RETRY_AFTER                  36
   #define HTTP_QUERY_SERVER                       37
   #define HTTP_QUERY_TITLE                        38
   #define HTTP_QUERY_USER_AGENT                   39
   #define HTTP_QUERY_WWW_AUTHENTICATE             40
   #define HTTP_QUERY_PROXY_AUTHENTICATE           41
   #define HTTP_QUERY_ACCEPT_RANGES                42
   #define HTTP_QUERY_SET_COOKIE                   43
   #define HTTP_QUERY_COOKIE                       44
   #define HTTP_QUERY_REQUEST_METHOD               45  // special: GET/POST etc.
   #define HTTP_QUERY_REFRESH                      46
   #define HTTP_QUERY_CONTENT_DISPOSITION          47

   //
   // HTTP 1.1 defined headers
   //

   #define HTTP_QUERY_AGE                          48
   #define HTTP_QUERY_CACHE_CONTROL                49
   #define HTTP_QUERY_CONTENT_BASE                 50
   #define HTTP_QUERY_CONTENT_LOCATION             51
   #define HTTP_QUERY_CONTENT_MD5                  52
   #define HTTP_QUERY_CONTENT_RANGE                53
   #define HTTP_QUERY_ETAG                         54
   #define HTTP_QUERY_HOST                         55
   #define HTTP_QUERY_IF_MATCH                     56
   #define HTTP_QUERY_IF_NONE_MATCH                57
   #define HTTP_QUERY_IF_RANGE                     58
   #define HTTP_QUERY_IF_UNMODIFIED_SINCE          59
   #define HTTP_QUERY_MAX_FORWARDS                 60
   #define HTTP_QUERY_PROXY_AUTHORIZATION          61
   #define HTTP_QUERY_RANGE                        62
   #define HTTP_QUERY_TRANSFER_ENCODING            63
   #define HTTP_QUERY_UPGRADE                      64
   #define HTTP_QUERY_VARY                         65
   #define HTTP_QUERY_VIA                          66
   #define HTTP_QUERY_WARNING                      67
   #define HTTP_QUERY_EXPECT                       68
   #define HTTP_QUERY_PROXY_CONNECTION             69
   #define HTTP_QUERY_UNLESS_MODIFIED_SINCE        70



   #define HTTP_QUERY_ECHO_REQUEST                 71
   #define HTTP_QUERY_ECHO_REPLY                   72

   // These are the set of headers that should be added back to a request when
   // re-doing a request after a RETRY_WITH response.
   #define HTTP_QUERY_ECHO_HEADERS                 73
   #define HTTP_QUERY_ECHO_HEADERS_CRLF            74

   #define HTTP_QUERY_PROXY_SUPPORT                75
   #define HTTP_QUERY_AUTHENTICATION_INFO          76
   #define HTTP_QUERY_PASSPORT_URLS                77
   #define HTTP_QUERY_PASSPORT_CONFIG              78

   #define HTTP_QUERY_MAX                          78

   //
   // HTTP_QUERY_CUSTOM - if this special value is supplied as the dwInfoLevel
   // parameter of HttpQueryInfo() then the lpBuffer parameter contains the name
   // of the header we are to query
   //

   #define HTTP_QUERY_CUSTOM                       65535

   //
   // HTTP_QUERY_FLAG_REQUEST_HEADERS - if this bit is set in the dwInfoLevel
   // parameter of HttpQueryInfo() then the request headers will be queried for the
   // request information
   //

   #define HTTP_QUERY_FLAG_REQUEST_HEADERS            0x80000000

   #define HTTP_ADDREQ_FLAG_ADD_IF_NEW                0x10000000
   #define HTTP_ADDREQ_FLAG_ADD                       0x20000000
   #define HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA       0x40000000
   #define HTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON   0x01000000
   #define HTTP_ADDREQ_FLAG_COALESCE                  HTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA
   #define HTTP_ADDREQ_FLAG_REPLACE                   0x80000000

   #define URL_PROTOCOL   1
   #define URL_HOST       2
   #define URL_PORT       3
   #define URL_URI        4
   #define URL_METHOD     5
   #define URL_POSTSTRING 6
   #define URL_ACCESSTYPE 7
   #define URL_PROXY      8
   #define URL_BYPASS     9

   #define URL_SIZE       9

   #define INTERNET_OPTION_OFFLINE_MODE            26
   #define INTERNET_OPTION_CACHE_STREAM_HANDLE     27
   #define INTERNET_OPTION_USERNAME                28
   #define INTERNET_OPTION_PASSWORD                29
   #define INTERNET_OPTION_ASYNC                   30
   #define INTERNET_OPTION_SECURITY_FLAGS          31


#endif


