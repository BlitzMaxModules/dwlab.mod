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
	
	

	Method LoadLayer:LTLayer( Project:LTProject )
		Local NewLayer:LTLayer = New LTLayer
		For Local Shape:LTShape = Eachin Children
			Local NewShape:LTShape
			If LTLayer( Shape ) Then
				NewShape = LTLayer( Shape ).LoadLayer( Project )
			Elseif LTTileMap( Shape ) Then
				NewShape = Shape.Clone()
			ElseIf LTVectorSprite( Shape )
				NewShape = Project.LoadVectorSprite( LTVectorSprite( Shape ) )
			ElseIf LTAngularSprite( Shape )
				NewShape = Project.LoadAngularSprite( LTAngularSprite( Shape ) )
			Else
				NewShape = Project.LoadStaticSprite( LTSprite( Shape ) )
			End If
			If NewShape <> Null Then NewLayer.AddLast( NewShape )
		Next
		Return NewLayer
	End Method
	
	
	
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
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Bounds = LTSprite( XMLObject.ManageObjectField( "bounds", Bounds ) )
	End Method
End Type
