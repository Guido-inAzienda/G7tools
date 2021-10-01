//------------------------------------------------------------
//  Project: Open Tools for Xbase++                          -
//  Repository : http://www.xbwin.com                        -
//  Author: Pablo Botella Navarro ( http://www.xbwin.com )   -
//------------------------------------------------------------
#INCLUDE "ot4xb.ch"

///////////////////////////////////////////////////////////////////////////////
//
//
// JSON_Container
//
//
///////////////////////////////////////////////////////////////////////////////

//----------------------------------------------------------------------------------------------------------------------
#DEFINE JSON_Token_number   ("(?:-?\b(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?\b)")
#DEFINE JSON_Token_one_char ('(?:[^\0-\x08\x0a-\x1f"\\]|\\(?:["/\\bfnrt]|u[0-9A-Fa-f]{4}))')
#DEFINE JSON_Token_string   ('(?:"' + JSON_Token_one_char + '*")')
#DEFINE JSON_Token          ('(?:false|true|null|[\{\}\[\]]' + '|' + JSON_Token_number  + '|' + JSON_Token_string  + ')')
//----------------------------------------------------------------------------------------------------------------------
#DEFINE JSON_OBJECT     0x01
#DEFINE JSON_ARRAY      0x02
#DEFINE JSON_SIMPLE     0x03
#DEFINE JSON_STRING     0x04
#DEFINE JSON_NUMBER     0x05
#DEFINE JSON_TRUE       0x06
#DEFINE JSON_FALSE      0x07
#DEFINE JSON_NULL       0x08
#DEFINE JSON_END        0x10
#DEFINE JSON_ENDOBJECT  0x11
#DEFINE JSON_ENDARRAY   0x12
#DEFINE JSON_ERROR      -1
//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_pretty_out( cIn )
LOCAL bmt := ChrR(0,256)
LOCAL re := _rgx():New( JSON_Token ,"gim")
LOCAL ttr
LOCAL cc,n,nn,result
LOCAL last,delim,level
LOCAL p1,p2,token

@ot4xb:ByteMapTable_FillSeq(@bmt,__i8(32,255),1)
cc := cIn
@ot4xb:ByteMapTable_RemoveUnsafe(bmt,@cc,-1)
cc := TrimZ(cc)

ttr := re:exec(cc)
re:destroy()
IF Empty(ttr)
   RETURN cc
ENDIF
nn := Len( ttr )
result := ""
last  := 0
level := 0
for n := 1 to nn
   p1 := ttr[n][1]
   p2 := ttr[n][2]
   delim := AllTrim(PeekStr( cc , last , p1 - last ))
   token := AllTrim(PeekStr( cc , p1 , p2 ))
   last  := p1 + p2

   IF delim == ":"
      result += " : "
   ELSEIF delim == ","
      result += " ," + CRLF + Space(3*level)
   ENDIF
   IF token $ "}]"
      level--
      result += CRLF + Space(3*level) + token
   ELSEIF token $ "{["
      result += CRLF + Space(3*level) + token
      level++
      result += CRLF + Space(3*level)
   else
      result += token
   ENDIF
next
RETURN result
//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_condense_out( cIn )
LOCAL bmt := ChrR(0,256)
LOCAL re := _rgx():New( JSON_Token ,"gim")
LOCAL n,nn
LOCAL ttr
LOCAL result
LOCAL last,delim
LOCAL p1,p2,token
LOCAL cc

@ot4xb:ByteMapTable_FillSeq(@bmt,__i8(32,255),1)
cc := cIn
@ot4xb:ByteMapTable_RemoveUnsafe(bmt,@cc,-1)
cc := TrimZ(cc)

ttr := re:exec(cc)
re:destroy()
IF Empty(ttr)
   RETURN cc
ENDIF
nn := Len( ttr )
result := ""
last  := 0
for n := 1 to nn
   p1 := ttr[n][1]
   p2 := ttr[n][2]
   delim := AllTrim(PeekStr( cc , last , p1 - last ))
   token := AllTrim(PeekStr( cc , p1 , p2 ))
   last  := p1 + p2
   result += delim + token
next
RETURN result
//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_serialize( v , lRecursionDetected )
LOCAL result := NIL
LOCAL lStart := (tls():JSON_Container_Stack == NIL )
IF lStart
   tls():JSON_Container_Stack := TGXbStack():New()
   tls():JSON_Container_lRecursionDetected := .F.
ENDIF
result  := json_serialize_internal(v)
IF lStart
   tls():JSON_Container_Stack:destroy()
   tls():JSON_Container_Stack := NIL
   lRecursionDetected := tls():JSON_Container_lRecursionDetected
   tls():JSON_Container_lRecursionDetected := NIL
ENDIF
RETURN result
//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_unserialize( cc , lError)
LOCAL aToken := json_tokenize_string( cc )
LOCAL stk
LOCAL n,nn
LOCAL result
LOCAL t,v
LOCAL eb
lError := .F.
nn := Len( aToken )
IF nn == 0
   lError := .T.
   RETURN NIL
ENDIF
t := JSON_ERROR
result := json_token_value( aToken[1] ,@t)
IF t > JSON_SIMPLE
   RETURN result
ENDIF
stk := TGXbStack():New()
stk:push(result )
eb := ErrorBlock( {|| Break() } )
BEGIN SEQUENCE
   for n := 2 to nn
      v := json_token_value( aToken[n] ,@t)
      IF t == -1
         BREAK
      ELSEIF t == JSON_ENDOBJECT
         v := stk:pop()
         v:m_on_unserialize_pop()
         json_tos_put_prop( stk, v )
      ELSEIF t == JSON_ENDARRAY
         v := stk:pop()
         json_tos_put_prop( stk, v )
      ELSEIF t < JSON_SIMPLE
         stk:push(v)
      else
         json_tos_put_prop( stk, v )
      ENDIF
   next
RECOVER
   lError := .T.
END SEQUENCE
ErrorBlock(eb)
stk:destroy()
RETURN result
//----------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION json_tos_put_prop( stk, v )
LOCAL tos := stk:tos()
LOCAL t
t := Valtype(tos)
IF t == "A"
   aadd( tos , v )
ELSEIF t == "O"
   tos:m_unserialize_step(v)
ENDIF
RETURN NIL
//----------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION json_token_value( token , type )
LOCAL ch := PeekStr(token,0,1)
IF ch == '{'
   type := JSON_OBJECT
   RETURN JSON_Container():New()
ELSEIF ch == '['
   type := JSON_ARRAY
   RETURN Array(0)
ELSEIF ch == '}'
   type := JSON_ENDOBJECT
   RETURN NIL
ELSEIF ch == ']'
   type := JSON_ENDARRAY
   RETURN NIL
ELSEIF ch == Chr(34) //'"'
   type := JSON_STRING
   RETURN json_unescape_string( token)
ELSEIF token == 'true'
   type := JSON_TRUE
   RETURN .T.
ELSEIF token == 'false'
   type := JSON_TRUE
   RETURN .F.
ELSEIF token == 'null'
   type := JSON_NULL
   RETURN NIL
else
   type := JSON_NUMBER
   RETURN ot4xb_parse_number( token)
ENDIF
RETURN NIL

//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_escape_string( cc )
LOCAL cb   := 0
LOCAL p    := 0
LOCAL cOut := ""
DEFAULT cc := ""
cb := Len(cc)
p := @ot4xb:escape_to_json(cc,cb,@cb)
IF Empty(p) ; RETURN '""' ; ENDIF
cOut := cPrintf(,"\q%s\q",p)
_xfree(p)
RETURN cOut
//----------------------------------------------------------------------------------------------------------------------
FUNCTION json_unescape_string( cc )
LOCAL cb   := 0
LOCAL p    := 0
LOCAL cOut := ""
DEFAULT cc := ""
cb := 0
p := @ot4xb:unescape_from_json(cc,@cb)
IF Empty(p) ; RETURN "" ; ENDIF
cOut := PeekStr(p,0,cb)
_xfree(p)
RETURN cOut
//----------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION json_tokenize_string( cc )
LOCAL re := _rgx():New( JSON_Token ,"gim")
LOCAL ttr := re:exec(cc)
LOCAL n,nn
LOCAL result
re:destroy()
IF Empty(ttr)
   RETURN Array(0)
ENDIF
nn := Len( ttr )
result := Array(nn)
for n := 1 to nn
   result[n] := PeekStr( cc , ttr[n][1] , ttr[n][2] )
next
RETURN result
//----------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION json_serialize_internal( v )
LOCAL t,r,x
LOCAL lRecursion
IF v == NIL
   RETURN "null"
ENDIF
t := ValType( v )
IF t == "C"
   RETURN json_escape_string(v)
ELSEIF t == "M"
   RETURN json_escape_string(v)
ELSEIF t == "N"
   IF lIsNumF64( v )
      RETURN cPrintf("%f",NIL,v)
   ENDIF
   RETURN cPrintf("%i",v)
ELSEIF t == "L"
   RETURN iIF( v , "true" , "false" )
ELSEIF t == "D"
   // RETURN iIF( Empty(v) , "null" , cPrintf(,"\q%s\q",DtoS(v)) )
   IF Empty(v)
      RETURN "null"
   else
     x := set(_SET_DATEFORMAT,"yyyy-mm-dd")
     v := dtoc(v)
     set(_SET_DATEFORMAT,x)
     RETURN cPrintf(,"\q%s\q",v)
   ENDIF
ELSEIF t == "O"
   lRecursion := .F.
   tls():JSON_Container_Stack:SEval( {|e| iIF( Valtype(e) == "O",iIF( e == v , lRecursion := .T. , NIL),NIL) } )
   IF lRecursion
      tls():JSON_Container_lRecursionDetected := .T.
      RETURN "null"
   ENDIF
   r := NIL
   tls():JSON_Container_Stack:push( v )
   IF !lCallMethodPA(v,"json_escape_self",{},@r)
      r := "null"
   ENDIF
   tls():JSON_Container_Stack:pop()
   RETURN r
ELSEIF t == "A"
   lRecursion := .F.
   tls():JSON_Container_Stack:SEval( {|e| iIF( Valtype(e) == "A",iIF( e == v , lRecursion := .T. , NIL),NIL) } )
   IF lRecursion
      tls():JSON_Container_lRecursionDetected := .T.
      RETURN "null"
   ENDIF
   r := NIL
   tls():JSON_Container_Stack:push( v )

   r := ""
   AEval( v , {|e,n| r += iIF(n > 1,",","") + json_serialize(e) } )
   r := cPrintf("[%s]",r)

   tls():JSON_Container_Stack:pop()
   RETURN r
ENDIF
RETURN "null"

       // ---------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
CLASS JSON_Container
PROTECTED:
       // ---------------------------------------------------------------------------------
//       VAR m_json_props ora e' exported
       VAR m_json_hash
       VAR m_unserialize_info
EXPORTED:
       // ---------------------------------------------------------------------------------
       VAR m_json_props
       // ---------------------------------------------------------------------------------
INLINE METHOD m_unserialize_step(v)
       DEFAULT ::m_unserialize_info := Array(0)
       aadd( ::m_unserialize_info , v )
       RETURN Self
       // ---------------------------------------------------------------------------------
INLINE METHOD m_on_unserialize_pop()
       LOCAL n,nn
       IF Empty( ::m_unserialize_info ) ; RETURN NIL ; ENDIF
       nn := nAnd(Len( ::m_unserialize_info ), 0x7FFFFFFE )
       n := 1
       WHILE n < nn
          ::set_prop( __vstr(::m_unserialize_info[n],"") , ::m_unserialize_info[n+1] )
          n += 2
       ENDDO
       ::m_unserialize_info := NIL
       RETURN Self
       // ---------------------------------------------------------------------------------
INLINE SYNC METHOD json_escape_self()
       LOCAL r := ""
       AEval( ::m_json_props , {|e,n| r += iIF(n > 1,",","") + cPrintf(,"\q%s\q:%s", e[1] , json_serialize(e[2])) } )
       RETURN  cPrintf("{%s}",r)
       // ---------------------------------------------------------------------------------
INLINE METHOD init()
       ::m_json_props  := Array(0)
       ::m_json_hash   := ""
       RETURN Self
       // ---------------------------------------------------------------------------------
INLINE SYNC METHOD set_prop( k , v )
       LOCAL cnt := nRShIFt(Len(::m_json_hash),2)
       LOCAL dwh := 0
       LOCAL pos := @ot4xb:_dwscan_lwstrcrc32(::m_json_hash,cnt,__vstr(k,""),-1,@dwh)
       IF pos == -1
          pos := cnt
          ::m_json_hash += __i32(dwh)
          aadd( ::m_json_props , __anew( __vstr(k,"") , v ) )
       else
          ::m_json_props[ pos+1][2] := v
       ENDIF
       RETURN NIL
       // ---------------------------------------------------------------------------------
INLINE SYNC METHOD get_prop( k )
       LOCAL cnt := nRShIFt(Len(::m_json_hash),2)
       LOCAL dwh := 0
       LOCAL pos := @ot4xb:_dwscan_lwstrcrc32(::m_json_hash,cnt,__vstr(k,""),-1,@dwh)
       IF pos == -1
          RETURN NIL
       ENDIF
       RETURN ::m_json_props[ pos+1][2]
       // ---------------------------------------------------------------------------------
INLINE METHOD SetNoIVar(k,v)
       RETURN ::set_prop( k , v )
       // ---------------------------------------------------------------------------------
INLINE METHOD GetNoIVar(k)
       RETURN ::get_prop( k )
       // ---------------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Estensione by Compusoft. Come set_prop, ma prende preleva il valore con
// get_prop se presente, oppura assegna il valore value. Se c'e' forzatura
// assegna sempre il valore value, si puo' forzare la dimensione delle strighe
// per motivi di editing. (vedi il progetto PCL)
//
INLINE METHOD set_prop_val(key,value,force,strlen)
  LOCAL val := value
  LOCAL t
  IF force == NIL ; force:= .f. ; ENDIF
  IF !force
    t := ::get_prop( key )
    IF t != NIL
      val := t
      ENDIF
    ENDIF
  IF !empty(strlen) .and. valtype(val) == 'C'
    val := pad(val,strlen)
    ENDIF
  ::set_prop( key , val )
RETURN NIL


ENDCLASS
//----------------------------------------------------------------------------------------------------------------------
