    // Das VBScript-Beispiel aus dem Open Office Developers Guide,
    // (noch nicht vollständig) übertragen nach Xbase++.
    // Der Servicemanager ist stets der Ausgangspunkt.
    // Falls Open Office zur Zeit nicht läuft, sorgt er für dessen Start.

    #include "common.ch"
    #INCLUDE "appevent.CH"
    #include "activex.ch"

    #define LF chr(10)

    #pragma library("ascom10.lib")

    STATIC oServiceManager

    PROC Main()

    LOCAL oDlg, oBtn
    LOCAL nEvent := 0, oXbp, mp1, mp2

    oDlg := XbpDialog():New( appdesktop(), , {100,100}, {500,400} )
    oDlg:Title    := "Open Office-Demo"
    oDlg:taskList := TRUE
    oDlg:close    := {||iif( oServiceManager <> NIL, oServiceManager:destroy(), NIL ) }
    oDlg:create()
    setappwindow( oDlg )

    oBtn := XbpPushButton():New( oDlg:drawingArea, , {10,10}, {90,20} )
    oBtn:Caption  := "Schreib was"
    oBtn:activate := {|a,b,o|CreateOpenOfficeDocument(o)}
    oBtn:create()

    setappfocus( oDlg )

    do while nEvent <> xbeP_Close
       nEvent := AppEvent( @mp1, @mp2, @oXbp )
       oXbp:HandleEvent( nEvent, mp1, mp2 )
    enddo

    RETURN

    PROC DBESYS
    RETURN

    PROC AppSys
    RETURN

    PROCEDURE CreateOpenOfficeDocument( caller )

    IF oServiceManager = NIL
       oServiceManager := CreateObject("com.sun.star.ServiceManager")
    ENDIF

    SchreibWas()

    RETURN

    PROCEDURE SchreibWas()

    LOCAL oCoreReflection
    LOCAL oDesktop
    LOCAL args
    LOCAL oDocument
    LOCAL oText
    LOCAL oCursor
    LOCAL oTable
    LOCAL oRows
    LOCAL oRow
    LOCAL oTextFrame
    LOCAL oSize
    LOCAL oFrameText
    LOCAL oFrameTextCursor

    //Create the CoreReflection service that is later used to create structs
    oCoreReflection := oServiceManager:createInstance("com.sun.star.reflection.CoreReflection")

    //Create the Desktop
    oDesktop := oServiceManager:createInstance("com.sun.star.frame.Desktop")

    args := VTType():New( {}, VT_ARRAY+VT_VARIANT )

    //Open a new empty writer document

    oDocument := oDesktop:loadComponentFromURL("private:factory/swriter", "_blank", 0, args )

    //Create a text object
    oText := oDocument:getText()

    //Create a cursor object
    oCursor := oText:createTextCursor()

    //Inserting some Text
    oText:insertString( oCursor, "The first line in the newly created text document." + LF, FALSE )

    //Inserting a second line
    oText:insertString( oCursor, "Now we're in the second line", FALSE )

    //Create instance of a text table with 4 columns and 4 rows
    oTable := oDocument:createInstance( "com.sun.star.text.TextTable")
    oTable:initialize( 4, 4 )

    //Insert the table
    oText:insertTextContent( oCursor, oTable, FALSE )

    //Get first row
    oRows := oTable:getRows()
    oRow  := oRows:getByIndex( 0 )

    //Set the table background color
    oTable:setPropertyValue( "BackTransparent", FALSE )
    oTable:setPropertyValue( "BackColor", 13421823 )

    //Set a different background color for the first row
    oRow:setPropertyValue( "BackTransparent", FALSE )
    oRow:setPropertyValue( "BackColor", 6710932 )

    // Fill the first table row
    // insertIntoCell is a helper function, see below

    insertIntoCell( "A1","FirstColumn", oTable )
    insertIntoCell( "B1","SecondColumn", oTable )
    insertIntoCell( "C1","ThirdColumn", oTable )
    insertIntoCell( "D1","SUM", oTable )

    oTable:getCellByName("A2"):setValue( 22.5 )
    oTable:getCellByName("B2"):setValue( 5615.3 )
    oTable:getCellByName("C2"):setValue( -2315.7 )
    oTable:getCellByName("D2"):setFormula( "sum " )
    oTable:getCellByName("A3"):setValue( 21.5 )
    oTable:getCellByName("B3"):setValue( 615.3 )
    oTable:getCellByName("C3"):setValue( -315.7 )
    oTable:getCellByName("D3"):setFormula( "sum " )
    oTable:getCellByName("A4"):setValue( 121.5 )
    oTable:getCellByName("B4"):setValue( -615.3 )
    oTable:getCellByName("C4"):setValue( 415.7 )
    oTable:getCellByName("D4"):setFormula( "sum " )

    //Change the CharColor and add a Shadow
    oCursor:setPropertyValue( "CharColor", 255 )
    oCursor:setPropertyValue( "CharShadowed", TRUE )

    //Create a paragraph break
    //The second argument is a com::sun::star::text::ControlCharacter::PARAGRAPH_BREAK constant
    oText:insertControlCharacter( oCursor, 0 , FALSE )

    //Inserting colored Text.
    oText:insertString( oCursor, " This is a colored Text - blue with shadow" + LF, FALSE )

    //Create a paragraph break ( ControlCharacter::PARAGRAPH_BREAK).
    oText:insertControlCharacter( oCursor, 0, FALSE )


    /*-----------------------------------------------
    // DAS FOLGENDE FUNKTIONIERT NOCH NICHT
    // wegen der Funktion createStruct()

    //Create a TextFrame.
    oTextFrame := oDocument:createInstance("com.sun.star.text.TextFrame")

    //Create a Size struct.
    // uses helper function, see below
    oSize := createStruct( oCoreReflection, "com.sun.star.awt.Size" )
    oSize:Width  := 15000
    oSize:Height := 400
    oTextFrame:setSize( oSize )

    // TextContentAnchorType.AS_CHARACTER = 1
    oTextFrame:setPropertyValue( "AnchorType", 1 )

    //insert the frame
    oText:insertTextContent( oCursor, oTextFrame, FALSE )

    //Get the text object of the frame
    oFrameText := oTextFrame:getText()

    //Create a cursor object
    oFrameTextCursor := oFrameText:createTextCursor()

    //Inserting some Text
    oFrameText:insertString( oFrameTextCursor, "The first line in the newly created text frame.", FALSE )

    oFrameText:insertString( oFrameTextCursor, LF + "With this second line the height of the frame raises.", FALSE )

    //Create a paragraph break
    //The second argument is a com::sun::star::text::ControlCharacter::PARAGRAPH_BREAK constant
    oFrameText:insertControlCharacter( oCursor, 0 , FALSE )

    ------------------*/

    //Change the CharColor and add a Shadow
    oCursor:setPropertyValue( "CharColor", 65536 )
    oCursor:setPropertyValue( "CharShadowed", FALSE )
    //Insert another string
    oText:insertString( oCursor, " That's all for now !!", FALSE )

    oCoreReflection:destroy()
    oDesktop:destroy()
    oDocument:destroy()
    oText:destroy()
    oCursor:destroy()
    oTable:destroy()
    oRows:destroy()
    oRow:destroy()
    // oTextFrame:destroy()
    // oSize:destroy()
    // oFrameText:destroy()
    // oFrameTextCursor:destroy()

    // VTType-Objekte kennen kein :destroy()

    RETURN

    // -------------------------------

    PROCEDURE insertIntoCell( cCellName, cText, oTable )

    LOCAL oCellText   := oTable:getCellByName( cCellName )
    LOCAL oCellCursor := oCellText:createTextCursor()

    oCellCursor:setPropertyValue( "CharColor",16777215 )
    oCellText:insertString( oCellCursor, cText, FALSE )

    oCellCursor:destroy()
    oCellText:destroy()

    RETURN

    // -------------------------------
    // Hier hakt es noch
    FUNCTION createStruct( oCoreReflection, cTypeName )

    LOCAL oClass  := oCoreReflection:forName( cTypeName )
    LOCAL oStruct := VTType():New( 0, VT_DISPATCH )      // ???

    oClass:createObject( oStruct )

    RETURN oStruct
