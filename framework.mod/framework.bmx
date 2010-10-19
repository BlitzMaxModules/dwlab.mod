' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3

SeedRnd( Millisecs() )

Const L_Version:String = "0.10.1"

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTMap.bmx"
Include "include/LTActiveObject.bmx"
Include "include/LTVisualizer.bmx"
Include "include/LTText.bmx"
Include "include/LTSound.bmx"
Include "include/LTPath.bmx"
Include "include/LTDrag.bmx"
Include "include/LTAction.bmx"
Include "include/LTXML.bmx"
Include "include/Service.bmx"





Function L_Assert( Condition:Int, Text:String )
	If Not Condition Then
		Notify( Text, True )
		DebugStop
		End
	End If
End Function




Type LTWorld Extends LTObject
	Field Tilemap:LTTileMap
	Field Objects:LTList = New LTList
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
		Tilemap = LTTileMap( XMLObject.ManageObjectField( "tilemap", Tilemap ) )
	End Method
End Type