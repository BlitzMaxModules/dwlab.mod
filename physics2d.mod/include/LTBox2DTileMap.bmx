'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBox2DTileMap Extends LTTileMap
	Field Body:b2Body
	Field ListLink:TLink
	
	
	
	Method GetClassTitle:String()
		Return "Box2D tile map"
	End Method
	
	
	
	Method Init()
		ListLink = LTBox2DPhysics.Objects.AddLast( Self )
		
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		
		'AttachSpriteShapesToBody( Self, LTBox2DShapeParameters.FromSprite( Self ), Body )
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewTileMap:LTBox2DTileMap = New LTBox2DTileMap
		CopyTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method Destroy()
		ListLink.Remove()
	End Method
	
	
	
	Method Physics:Int()
		Return True
	End Method
End Type