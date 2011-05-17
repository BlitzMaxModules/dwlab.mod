'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTWorld.bmx"

Type LTLayer Extends LTGroup
	Field Bounds:LTShape
	
	
	
	Method FindTilemap:LTTileMap()
		For Local Obj:LTShape = Eachin Children
			If LTTileMap( Obj ) Then
				Return LTTileMap( Obj )
			ElseIf LTLayer( Obj ) Then
				Local TileMap:LTTileMap = LTLayer( Obj ).FindTilemap()
				If TileMap Then Return TileMap
			End If
		Next
		Return Null
	End Method
	
	
	
	Method CountSprites:Int()
		Local Count:Int = 0
		For Local Shape:LTShape = Eachin Children
			If LTSprite( Shape ) Then
				Count :+ 1
			ElseIf LTLayer( Shape ) Then
				Count :+ LTLayer( Shape ).CountSprites()
			End If
		Next
		Return Count
	End Method
	
	
	
	
	Method Clone:LTShape()
		Local NewLayer:LTLayer = New LTLayer
		For Local Obj:LTShape = Eachin Children
			NewLayer.AddLast( Obj.Clone() )
		Next
		Return NewLayer
	End Method
	
	
	
	Method FindLayer:LTLayer( LayerName:String )
		If Name = LayerName Then Return Self
		For Local ChildLayer:LTLayer = Eachin Children
			Local Layer:LTLayer = ChildLayer.FindLayer( LayerName )
			If Layer Then Return Layer
		Next
		Return Null
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Local Link:TLink = Children.FirstLink()
		While Link <> Null
			If LTLayer( Link.Value() ) Then LTLayer( Link.Value() ).Remove( Shape )
			If Link.Value() = Shape Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Bounds = LTSprite( XMLObject.ManageObjectField( "bounds", Bounds ) )
	End Method
End Type
