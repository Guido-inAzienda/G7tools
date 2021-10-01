#INCLUDE "COMMON.CH"

/*
#DEFINE ScriptPy  "import uuid, base64, sys                                                             "+Chr(13)+Chr(10)+; 
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "def GeneraID(quantiID):                                                              "+Chr(13)+Chr(10)+;
                  "    conta = 0                                                                        "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "    while (conta < quantiID):                                                        "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "        uuid1 = base64.b85encode(uuid.uuid4().bytes).decode('ascii')                 "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "        if (uuid1.find('"') < 0) and (uuid1.find("'") < 0) and (uuid1.find(" ") < 0):"+Chr(13)+Chr(10)+;
                  "            print(uuid1)                                                             "+Chr(13)+Chr(10)+;
                  "            conta = conta + 1                                                        "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "if __name__ == '__main__':                                                           "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "    if len(sys.argv) > 1:                                                            "+Chr(13)+Chr(10)+;
                  "        quantiID = sys.argv[1]                                                       "+Chr(13)+Chr(10)+;
                  "    else:                                                                            "+Chr(13)+Chr(10)+;
                  "      quantiID = 1                                                                   "+Chr(13)+Chr(10)+;
                  "                                                                                     "+Chr(13)+Chr(10)+;
                  "    GeneraID(int(quantiID))                                                          "+Chr(13)+Chr(10)
*/
STATIC aDocId := {}

FUNCTION G7DocId(nId) 
  LOCAL cDocId := ""
  
  IF Len(aDocId) == 0
    G7DocId_Generate(nId)
  ENDIF
  IF Len(aDocId) > 0
    cDocId := aDocId[1]
    ARemove(aDocId,1) 
  ENDIF
RETURN cDocId

STATIC FUNCTION G7DocId_Generate(nId)
  LOCAL cStdOut := "" ,;
        cStdErr := "" ,; 
        aNewId  := {}
        lExeOK  := .F.
         
 DEFAULT nId TO 100
 
 lExeOK := G7RunProcess( "G7DocId.exe "+AllTrim(Str(nId,10,0)), "" ,  , @cStdOut , @cStdErr) 

 IF !Empty(cStdErr) .OR. Empty(cStdOut)    
    lExeOK := .F. //Errore esecuzione
  ELSE
    lExeOK := .T.
    
    aNewId := G7Str2Arr(cStdOut,Chr(13)+Chr(10))
    FOR i:=1 TO Len(aNewId) //Cancella potenziali non validi
      IF Len(aNewId[1]) == 20
        AAdd(aDocId,aNewId[i])
      ENDIF
    NEXT
  ENDIF 
RETURN NIL