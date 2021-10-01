#PRAGMA LIBRARY( "ASCOM10.LIB" )

PROCEDURE ProvaADO()
  LOCAL oConnection ,;
        oRecordSet  ,;
        oCommand
  LOCAL aVal := {}  ,;
        xVal
  
  oConnection := CreateObject( "ADODB.Connection" )
  
  oConnection:ConnectionString := "Provider=SQLNCLI;Server=(local);DATABASE=prove; UID=sa;PWD=1naziendA"
  //oConnection:ConnectionString := "Provider=SQLOLEDB;Server=(local);DATABASE=prove; UID=sa;PWD=1naziendA"
  //oConnection:ConnectionString := "Provider= Microsoft.Jet.OLEDB.4.0;Data Source= TEST.MDB"
  
  oConnection:open()
  
  xVal := oConnection:state()
  //xVal := oConnection:OpenSchema(20)
  
  oRecordSet := CreateObject( "ADODB.Recordset" )
  oRecordSet:Open( "SELECT * FROM Tab1", oConnection, 0, 3 )

  xVal := oRecordSet:MaxRecords()
  
  oRecordSet:AddNew({"C1","C2","F1","I1"},{"xx","yy",(Seconds()/7),Seconds()})

  xVal := oRecordSet:MaxRecords()

  oRecordSet:MoveFirst()
  
  WHILE !oRecordSet:Eof()


    oRecordSet:Update({"C1","F1"},{Time(),(Seconds()/7)})
    
    AAdd(aVal,{oRecordSet:Fields("C1"):Value,;
               oRecordSet:Fields("C2"):Value,;
               oRecordSet:Fields("F1"):Value,;
               oRecordSet:Fields("I1"):Value })
    
    oRecordSet:MoveNext()  
  ENDDO
  
  oRecordSet:Close()
  oRecordSet:Destroy()
  
  //Test Command
  oCommand := CreateObject( "ADODB.Command" )
  //oCommand:CommandText := "SELECT * FROM Tab1" 
  oCommand:CommandText := "UPDATE Tab1 SET C2='pluto'"
  oCommand:ActiveConnection  := oConnection
  
  oRecordSet := oCommand:Execute(@xVal)
  
  /*oRecordSet:MoveFirst()
  
  WHILE !oRecordSet:Eof()
    AAdd(aVal,{oRecordSet:Fields("C1"):Value,;
               oRecordSet:Fields("C2"):Value,;
               oRecordSet:Fields("F1"):Value,;
               oRecordSet:Fields("I1"):Value })
    
    oRecordSet:MoveNext()  
  ENDDO*/

  
  oConnection:Close()
  oConnection:Destroy()

RETURN