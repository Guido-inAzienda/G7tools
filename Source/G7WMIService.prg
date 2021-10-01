#include "common.ch"
#include "os.ch"
#ifndef CRLF
#define CRLF CHR(13)+CHR(10)
#endif

#PRAGMA LIBRARY("ASCOM10.LIB")

PROCEDURE MAIN
   local aTemp, x, oMSI

   set charset to ansi

   set alternate to MyHardInfoO.txt
   set alternate on
   ?
   aTemp := GetLanInfo()
   ? "GetLanInfo: ",str(len(aTemp),2),"Adapter"
   for x := 1 to len(aTemp)
      ? str(x,2)+". LAN-Adapter  Name: ",aTemp[x]:Name
      ? "                 MAC:  ",aTemp[x]:MAC
      ? "                 IP4:  ",aTemp[x]:IP4
      ? "                 IP6:  ",aTemp[x]:IP6
   next
   inkey(0.5)
   ?
   aTemp := GetWiFiInfo()
   ? "GetWifiInfo:",str(len(aTemp),2),"Adapter"
   for x := 1 to len(aTemp)
      ? str(x,2)+". WiFi-Adapter Name: ",aTemp[x]:Name
      ? "                 MAC:  ",aTemp[x]:MAC
      ? "                 IP4:  ",aTemp[x]:IP4
      ? "                 IP6:  ",aTemp[x]:IP6
   next
   inkey(0.4)
   ?
   ? "MotherBoardInfo() "
   oMSI := MotherBoardInfo()
   ? "   Hersteller:  ",oMSI:Manufacturer
   ? "   Product:     ",oMSI:Product
   ? "   Seriennummer:",oMSI:SerialNumber
   ? "   Version:     ",oMSI:Version
   inkey(0.5)
   ?
   ? "CD/DVD/BR-Drives:"
   aTemp := CDDrives()
   for x := 1 to len(aTemp)
      ? str(x,2)+". Laufwerk Name: ",aTemp[x]:Name
             ? "               ID: ",aTemp[x]:Drive
             ? "               SN: ",aTemp[x]:SerialNumber
             ? "         geladen ? ",aTemp[x]:MediaLoaded
             ? "              TYP: ",aTemp[x]:MediaType
      if aTemp[x]:MediaLoaded
             ? "     Medium Titel: ",aTemp[x]:VolumeName
             ? "     Medium    SN: ",aTemp[x]:VolumeSerialNumber
      endif
   next
   inkey(0.5)
   ?
   ? "Festplatteninfos:"
   aTemp := HDDrives(1)   // Parameter NIL oder 0 => nur FIXED, 1 => alle mit Partitionen, REST => alle
   for x := 1 to len(aTemp)
      ? str(x,2)+". HD Caption: ",aTemp[x]:Caption
             ? "            SN: ",aTemp[x]:SerialNumber
             ? "     Interface: ",aTemp[x]:InterfaceType
             ? "    Anz. Part.: ",xTrim(aTemp[x]:Partitions)," Datentyp:",valtype(aTemp[x]:Partitions)
   next

inkey(20)

return

*-----------------------------------------------------------------------------
// HDDrives(nArt)
// Parameter nArt = NIL oder 0 => nur FIXED, 1 => alle mit Partitionen, REST => alle
function HDDrives(nArt)
   local cMSInameSpace,cMSIclass,aMSIitemList, aReturn, aHD, x, nMaxX, oMSI, aRetItems
   local cCaption, cSerialNumber, cInterfaceType, nPartitions
   // FIXED = (sInterfaceType <> "USB") AND (sInterfaceType <> "1394") 'Could be SCSI, HDC, IDE, USB, 1394

   cMSInameSpace := "Root\CIMv2"
   cMSIclass     := "Win32_DiskDrive"
   if IsOldOS()
      aMSIitemList  := {"Caption", "InterfaceType", "Partitions","Name" }
   else
      aMSIitemList  := {"Caption", "InterfaceType", "Partitions","Name" , "SerialNumber" }
   endif
   aRetItems     := {"Caption", "InterfaceType", "Partitions","Name" , "SerialNumber" }
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList)
   aHD := {}
   nMaxX := len(aReturn)
   aReturn := asort(aReturn,,,{|x,y| x[2]+x[4] < y[2]+y[4] } )
   for x := 1 to nMaxX
       cCaption        := xTrim(aReturn[x,1])
       cInterfaceType  := xTrim(aReturn[x,2])
       nPartitions     := aReturn[x,3]    // numeric
       if IsOldOS()
          cSerialNumber := ""
       else
          cSerialNumber := xTrim(aReturn[x,5])
       endif
       do case
          case empty(nArt) .and. ( "*"+cInterfaceType+"*" $ "*USB*1394*" .or. empty(nPartitions) )
               // blockieren
          case nArt=1 .and. empty(nPartitions)
               // blockieren
          otherwise
               oMSI := MakeMSIobj(cMSIclass,aRetItems)
               oMSI:Caption       := cCaption
               oMSI:SerialNumber  := cSerialNumber
               oMSI:InterfaceType := cInterfaceType
               oMSI:Partitions    := nPartitions
               aadd(aHD, oMSI)
       end
   next
return aHD

*-----------------------------------------------------------------------------
// CDDrives()
// Rückgabe: {{ cName, cDrive, cSerialNumber, lMediaLoaded, cMediaType, cVolumeName, cVolumeSerialNumber }}
function CDDrives()
   local cMSInameSpace,cMSIclass,aMSIitemList, aReturn, aCDI, x, nMaxX, oMSI, aRetItems
   local cName, cDrive, cSerialNumber, lMediaLoaded, cMediaType, cVolumeName, cVolumeSerialNumber
   cMSInameSpace := "Root\CIMv2"
   cMSIclass     := "Win32_CDROMDrive"
   if IsOldOS()
      aMSIitemList  := {"Name", "Drive", "MediaLoaded", "MediaType", "VolumeName" }
   else
      aMSIitemList  := {"Name", "Drive", "MediaLoaded", "MediaType", "VolumeName", "SerialNumber", "VolumeSerialNumber" }
   endif
   aRetItems     := {"Name", "Drive", "MediaLoaded", "MediaType", "VolumeName", "SerialNumber", "VolumeSerialNumber" }
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList)
   aCDI := {}
   nMaxX := len(aReturn)
   for x := 1 to nMaxX
       cName                  := xTrim(aReturn[x,1])
       cDrive                 := xTrim(aReturn[x,2])
       lMediaLoaded           := aReturn[x,3] // .t. / .f.
       cMediaType             := xTrim(aReturn[x,4])
       if IsOldOS()
          cSerialNumber       := ""
       else
          cSerialNumber       := xTrim(aReturn[x,6])
       endif
       if lMediaLoaded
          cVolumeName         := xTrim(aReturn[x,5])
          if IsOldOS()
             cVolumeSerialNumber := ""
          else
             cVolumeSerialNumber := xTrim(aReturn[x,7])
          endif
       else
          cVolumeName         := ""
          cVolumeSerialNumber := ""
       endif
       if ! empty(cDrive)
          oMSI := MakeMSIobj(cMSIclass,aRetItems)
          oMSI:Name               := cName
          oMSI:Drive              := cDrive
          oMSI:SerialNumber       := cSerialNumber
          oMSI:MediaLoaded        := lMediaLoaded
          oMSI:MediaType          := cMediaType
          oMSI:VolumeName         := cVolumeName
          oMSI:VolumeSerialNumber := cVolumeSerialNumber
          aadd(aCDI, oMSI)
       endif
   next
return aCDI


*-----------------------------------------------------------------------------
// MotherBoardInfo()
// Rückgabe: { Manufacturer, Product, SerialNumber, Version }
function MotherBoardInfo()
   local cMSInameSpace,cMSIclass,aMSIitemList, aReturn, oMSI
   local cManufacturer, cProduct, cSerialNumber, cVersion
   cMSInameSpace := "Root\CIMv2"
   cMSIclass     := "Win32_BaseBoard"
   aMSIitemList  := {"Manufacturer", "Product", "SerialNumber", "Version"}
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList)
   oMSI := MakeMSIobj(cMSIclass,aMSIitemList)
   if len(aReturn)>0
      oMSI:Manufacturer := xTrim(aReturn[1,1])
      oMSI:Product      := xTrim(aReturn[1,2])
      oMSI:SerialNumber := xTrim(aReturn[1,3])
      oMSI:Version      := xTrim(aReturn[1,4])
   else
      oMSI:Manufacturer := ""
      oMSI:Product      := ""
      oMSI:SerialNumber := ""
      oMSI:Version      := ""
   endif
return oMSI


*-----------------------------------------------------------------------------
// MAC und IP der LAN Adapter ermitteln
// MAC and IP of the build in LAN
function GetLanInfo(cCompName,cUser,cPassword,nZielOS)
   local cMSInameSpace,cMSIclass,aMSIitemList, aReturn, nIndex, aAdapterInfo, x, i, aAdapterIndex, nAI
   local cIP4, cIP6, cMac, cName, cAdapterType, uIP, oMSI, aRetType
   DEFAULT nZielOS TO val(OS(OS_VERSION))
   aAdapterIndex := {}
   aAdapterInfo  := {}
   cIP4          := ""
   cIP6          := ""
   cMSInameSpace := "Root\CIMv2"
   // zuerst die physischen Adapter ermitteln, das müsste der eingebaute LAN Adapter sein.
   if IsOldOS()
      cMSIclass     := "Win32_NetworkAdapter"
   else
      cMSIclass     := "Win32_NetworkAdapter WHERE PhysicalAdapter = true" // erst ab Vista
   endif
   aMSIitemList  := {"AdapterType","DeviceID","Index","Name","MACAddress"}
   aRetType      := {"Name","MAC","IP4","IP6"}
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList,cCompName,cUser,cPassword,nZielOS)
   for x := 1 to len(aReturn)
      // Aufbau nach Anforderungsarray !
      cAdapterType := xTrim(aReturn[x,1])
      nIndex       := aReturn[x,3] // numeric
      cName        := xTrim(aReturn[x,4])
      cMac         := xTrim(aReturn[x,5])
      do case
         case empty(cAdapterType)
         case "miniport" $ lower(cName) // dürfte nur bei XP vorkommen, da KEIN physikalischer Adapter.
         case "wifi" $ lower(cName)
         case "ethernet" $ lower(cAdapterType)
              aadd( aAdapterIndex, nIndex ) // nur für internen Vergleich
              oMSI := MakeMSIobj(cMSIclass,aRetType)
              oMSI:Name := cName
              oMSI:MAC  := cMAC
              oMSI:IP4  := cIP4
              oMSI:IP6  := cIP6
              aadd( aAdapterInfo, oMSI ) // IP-Adressen gibt es hier noch nicht.
      end
   next
   // dann die Konfiguration dazu ermitteln
   cMSIclass     := "Win32_NetworkAdapterConfiguration"
   aMSIitemList  := {"Index","IPAddress"}
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList,cCompName,cUser,cPassword,nZielOS)
   for x := 1 to len(aReturn)
      // Aufbau nach Anforderungsarray !
      nIndex     := aReturn[x,1]
      uIP        := aReturn[x,2] // NIL, cIP4, {cIP4,cIP6}
      nAI := ascan(aAdapterIndex, nIndex )
      if nAI > 0 .and. ! empty(uIP)
         cIP4 := xTrim(uIP[1])
         if len(uIP)>=2
            cIP6 := xTrim(uIP[2])
         endif
         aAdapterInfo[nAI]:IP4 := cIP4
         aAdapterInfo[nAI]:IP6 := cIP6
      endif
   next
return aAdapterInfo
*-----------------------------------------------------------------------------
// MAC und IP der WiFi Adapter ermitteln
// MAC and IP of the build in WiFi
function GetWifiInfo(cCompName,cUser,cPassword,nZielOS)
   local cMSInameSpace,cMSIclass,aMSIitemList, aReturn, nIndex, aAdapterInfo, x, i, aAdapterIndex, nAI
   local cIP4, cIP6, cMac, cName, cAdapterType, uIP, oMSI, aRetType
   DEFAULT nZielOS TO val(OS(OS_VERSION))
   aAdapterIndex := {}
   aAdapterInfo  := {}
   cIP4          := ""
   cIP6          := ""
   cMSInameSpace := "Root\CIMv2"
   // zuerst die physischen Adapter ermitteln, das müsste der eingebaute LAN Adapter sein.
   if IsOldOS()
      cMSIclass     := "Win32_NetworkAdapter"
   else
      cMSIclass     := "Win32_NetworkAdapter WHERE PhysicalAdapter = true" // scheinbar erst ab Vista
   endif
   aMSIitemList  := {"AdapterType","DeviceID","Index","Name","MACAddress"}
   aRetType      := {"Name","MAC","IP4","IP6"}
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList,cCompName,cUser,cPassword,nZielOS)
   for x := 1 to len(aReturn)
      // Aufbau nach Anforderungsarray !
      cAdapterType := aReturn[x,1]
      nIndex       := aReturn[x,3] // numeric
      cName        := aReturn[x,4]
      cMac         := aReturn[x,5]
      do case
         case empty(cAdapterType)
         case empty(cName)
         case "miniport" $ lower(cName) // dürfte nur bei XP vorkommen, da KEIN physikalischer Adapter.
         case "ethernet" $ lower(cAdapterType) .and. "wifi" $ lower(cName)
              aadd( aAdapterIndex, nIndex ) // nur für internen Vergleich
              oMSI := MakeMSIobj(cMSIclass,aRetType)
              oMSI:Name := cName
              oMSI:MAC  := cMAC
              oMSI:IP4  := cIP4
              oMSI:IP6  := cIP6
              aadd( aAdapterInfo, oMSI ) // IP-Adressen gibt es hier noch nicht.
      end
   next
   // dann die Konfiguration dazu ermitteln
   cMSIclass     := "Win32_NetworkAdapterConfiguration"
   aMSIitemList  := {"Index","IPAddress"}
   aReturn       := GetMSI(cMSIclass,cMSInameSpace,aMSIitemList,cCompName,cUser,cPassword,nZielOS)
   for x := 1 to len(aReturn)
      // Aufbau nach Anforderungsarray !
      nIndex     := aReturn[x,1]
      uIP        := aReturn[x,2] // NIL, cIP4, {cIP4,cIP6}
      nAI := ascan(aAdapterIndex, nIndex )
      if nAI > 0 .and. ! empty(uIP)
         cIP4 := uIP[1]
         if len(uIP)>=2
            cIP6 := uIP[2]
         endif
         aAdapterInfo[nAI]:IP4 := cIP4
         aAdapterInfo[nAI]:IP6 := cIP6
      endif
   next
return aAdapterInfo

*-----------------------------------------------------------------------------
* Basisfunktionen
*-----------------------------------------------------------------------------
function MakeMSIobj(cClassName,aProperty)
   local oObj, oClassObj, aMember, x, nMaxX, cBlock, bBlock

   #if XPPVER < 02000000
       #include "Class.ch"
       oClassObj := ClassObject(cClassName)
       if empty(oClassObj)
          nMaxX      := len(aProperty)
          aMember    := {}
          for x := 1 to nMaxX
              aadd( aMember , { aProperty[x], CLASS_EXPORTED } )
          next
          oClassObj := ClassCreate( cClassName,,aMember) // NIL darf es nicht geben, sonst Fehlermeldung erzwingen.
       endif
       oObj := oClassObj:new()
   #else
       oObj := DataObject():New()
       nMaxX      := len(aProperty)
       for x := 1 to nMaxX
           cBlock := "{|o,n| o:"+aProperty[x]+" := NIL }"
           bBlock := &(cBlock)
           eval(bBlock,oObj)
       next
   #endif

return oObj
*-----------------------------------------------------------------------------
function xTrim(uWert)
   local x
   do case
      case empty(uWert)
           uWert := ""
      case valtype(uWert)="N"
           uWert := alltrim(str(uWert))
      case valtype(uWert)="D"
           uWert := dtoc(uWert)
      case valtype(uWert) $ "CM"
           for x := 0 to 31       // sowas habe ich bei Seriennummern gefunden ...
               uWert := strTran(uWert,chr(x),"")
           next
           uWert := alltrim(uWert)
      case valtype(uWert) $ "L"
           // OK
      otherwise
           uWert := alltrim(Var2Char(uWert))
   end
return uWert
*-----------------------------------------------------------------------------
function IsOldOS()
return val(OS(OS_VERSION)) < 6
*-----------------------------------------------------------------------------
function GetMSI(cMSIclass,cMSInameSpace,aMSIitemList,;
         cCompName,cUser,cPassword, nZielOS)
   LOCAL objWMIServices, cItems, cText, cName, cCollBlock, bCollBlock, oMSI, aInfos, nI, nMaxI, x, nMaxX
   PRIVATE aItems := {}

   if empty(cMSIclass)
      altd()
      return {}
   endif
   if empty(cMSInameSpace)
      cMSInameSpace := "Root\CIMv2"
   endif
   if empty(aMSIitemList) .or. valtype(aMSIitemList)#"A"
      altd()
      return {}
   else
      cItems := ""
      aEval(aMSIitemList,{|cI| cItems += ", "+cI} )
      cItems := substr(cItems,3)
   endif
   if empty(cCompName)
      cCompName := "localhost"
      nZielOS     := val(OS(OS_VERSION)) // immer ermitteln
   else
      cCompName := lower(cCompName)
      if cCompName == "localhost"
         nZielOS := val(OS(OS_VERSION))
      else
         if empty(nZielOS)                  // Vorgabe, sonst ermitteln
            nZielOS := 6
         endif
      endif
   endif
   DEFAULT cUser       TO "Administrator"
   DEFAULT cPassword   TO ""

   if cCompName == "localhost"
      if nZielOS >= 6
         objWMIServices  := CreateObject( "WbemScripting.SWbemLocator" ):ConnectServer(cCompName, cMSInameSpace ) // "Root\CIMv2")
      else
         altd() // hat bei mir nicht funktioniert ! I can't get this to work !
         * von MSDN                     "winmgmts:\\" & strComputer & "\root\CIMV2")
         * objWMIServices  := GetObject("WinMgmts:{impersonationLevel=impersonate}\\"+cCompName+"\"+cMSInameSpace ) // "\Root\CIMv2")
         objWMIServices  := GetObject( "WinMgmts:\\"+cCompName+"\"+cMSInameSpace ) // "\Root\CIMv2")
      endif
   else
      // bei mir immer Zugriff verweigert ! here every time access denied !
      do case
         case EMPTY(cPassword)
            altd()
            return {}
         case nZielOS >= 6
            objWMIServices  := CreateObject( "WbemScripting.SWbemLocator" ):ConnectServer(cCompName, cMSInameSpace,cCompName+"\"+cUser,cPassword)
         otherwise
            altd() // hat bei mir nicht funktioniert ! I can't get this to work !
            * objWMIServices  := GetObject("WinMgmts:{impersonationLevel=impersonate}\\"+cCompName+"\"+cMSInameSpace ) // "\Root\CIMv2")
            objWMIServices  := GetObject( "WinMgmts:\\"+cCompName+"\"+cMSInameSpace ) // "\Root\CIMv2")
      end
   endif

   if empty( objWMIServices )
      altd()
      return {}
   endif

   oMSI := objWMIServices:ExecQuery("select "+cItems+" from "+cMSIclass,,48)

   aInfos := {}
   nMaxI  := len(aMSIitemList)
   cCollBlock := "{|oService,n| AADD(aItems,{ "

   for nI := 1 to nMaxI
       cCollBlock += "oService:getProperty('"+aMSIitemList[nI]+"')"
       if nI < nMaxI
          cCollBlock += ", "
       else
          cCollBlock += " })} "
       endif

   next

   bCollBlock := &(cCollBlock)
   ComEvalCollection(oMSI, bCollBlock )

   /*
   ? "cMSIclass: ",cMSIclass
   aEval(aItems,{ |aI,n| qout( n,aI ) } )
   */

   // PRIVATE nach LOCAL
   aEval(m->aItems,{ |aI,n| aadd( aInfos, aI ) } )

RETURN aInfos 