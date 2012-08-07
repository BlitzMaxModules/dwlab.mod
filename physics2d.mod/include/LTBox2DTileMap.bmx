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
	Field ServiceSprite:LTSprite = New LTSprite
	
	
	
	Method GetClassTitle:String()
		Return "Box2D tile map"
	End Method
	
	
	
	Method Init()
		ListLink = LTBox2DPhysics.Objects.AddLast( Self )
		
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		
		Local ShapeParameters:LTBox2DShapeParameters = LTBox2DShapeParameters.FromShape( Self )
		
		Local FilledTile:Int[,] = New Int[ XQuantity, YQuantity ]
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				Local CollisionShape:LTShape = TileSet.CollisionShape[ Value[ X, Y ] ]
				If Not CollisionShape Then Continue
				Local CollisionSprite:LTSprite = LTSprite( CollisionShape )
				If CollisionSprite Then
					If CollisionSprite.ShapeType = LTSprite.Rectangle And  CollisionSprite.X = 0.5:Double And CollisionSprite.Y = 0.5:Double ..
							And CollisionSprite.Width = 1.0:Double And CollisionSprite.Height = 1.0:Double Then
						FilledTile[ X, Y ] = True
					Else
						AttachTileCollisionSpriteToBody( X, Y, CollisionSprite, ShapeParameters, Body )
					End If
				Else
					For Local Sprite:LTSprite = Eachin LTLayer( CollisionShape )
						AttachTileCollisionSpriteToBody( X, Y, Sprite, ShapeParameters, Body )
					Next
				End If
			Next
		Next
		
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				If Not FilledTile[ X, Y ] Then Continue
				Local X2:Int
				For X2 = X + 1 Until XQuantity
					If Not FilledTile[ X2, Y ] Then Exit
				Next
				
				Local Y2:Int, XX:Int
				For Y2 = Y + 1 Until YQuantity
					For XX = X Until X2
						If Not FilledTile[ XX, Y2 ] Then Exit
					Next
					If XX < X2 Then Exit
				Next
				
				For Local YY:Int = Y Until Y2
					For Local XX:Int = X Until X2
						FilledTile[ XX, YY ] = False
					Next
				Next
				
				LTBox2DSprite.PolygonDefinition.SetAsBox( ( X2 - X ) * GetTileWidth(), ( Y2 - X ) * GetTileHeight() )
				LTBox2DSprite.AttachToBody( Body, LTBox2DSprite.PolygonDefinition, ShapeParameters )
			Next
		Next
	End Method
	
	
	
	Method AttachTileCollisionSpriteToBody( TileX:Int, TileY:Int, CollisionSprite:LTSprite, ShapeParameters:LTBox2DShapeParameters, Body:b2Body )
		Local TileWidth:Double = GetTileWidth()
		Local TileHeight:Double = GetTileHeight()
		ServiceSprite.X = LeftX() + TileWidth * ( TileX + CollisionSprite.X )
		ServiceSprite.Y = TopY() + TileHeight * ( TileY + CollisionSprite.Y )
		ServiceSprite.Width = TileWidth * CollisionSprite.Width
		ServiceSprite.Height = TileHeight * CollisionSprite.Height
		ServiceSprite.ShapeType = CollisionSprite.ShapeType
		LTBox2DSprite.AttachSpriteShapesToBody( ServiceSprite, ShapeParameters, Body )
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewTileMap:LTBox2DTileMap = New LTBox2DTileMap
		CopyTileMapTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method Destroy()
		ListLink.Remove()
	End Method
	
	
	
	Method Physics:Int()
		Return True
	End Method
End Type