'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBox2DPhysics
	Global Objects:TList = New TList
	Global Box2DWorld:b2World = New b2World
	
	
	
	Method InitWorld( World:LTLayer )
		Objects.Clear()
		Local Bounds:LTShape = World.Bounds
		Box2DWorld = b2World.CreateWorld( b2AABB.Create( Vec2( Bounds.LeftX(), Bounds.TopY() ), Vec2( Bounds.RightX(), Bounds.BottomY() ) ), ..
				World.GetParameter( "gravity" ).ToFloat(), True )
		ProcessLayer( World )
	End Method
	
	
	
	Method ProcessLayer( Layer:LTLayer )
		For Local Shape:LTShape = Eachin World.Children
			Local ChildLayer:LTLayer = LTLayer( Shape )
			If ChildLayer Then
				InitWorld( ChildLayer )
			Else
				Local Sprite:LTBox2DSprite = LTBox2DSprite( Sprite )
				If Sprite Then Objects.AddLast( Shape )
				'Local TileMap:LTBox2DTileMap = LTBox2DTileMap( Sprite )
				'If Sprite Or TileMap Then Objects.AddLast( Shape )
			End If
		Next
	End Method
End Type
