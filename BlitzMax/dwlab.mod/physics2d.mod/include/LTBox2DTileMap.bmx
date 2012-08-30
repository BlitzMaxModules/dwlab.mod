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
	Global ServiceSprite:LTSprite = New LTSprite
	Global PolygonDefinition:b2PolygonDef = New b2PolygonDef
	
	Field Body:b2Body
	
	
	
	Method GetClassTitle:String()
		Return "Box2D tile map"
	End Method
	
	
	
	Method Init()
		Local BodyDefinition:b2BodyDef = New b2BodyDef
		Body = LTBox2DPhysics.Box2DWorld.CreateBody( BodyDefinition )
		
		Local ShapeParameters:LTBox2DShapeParameters = LTBox2DShapeParameters.FromShape( Self )
		ShapeParameters.Density = 0.0
		
		Local FilledTile:Int[,] = New Int[ XQuantity, YQuantity ]
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				Local CollisionShape:LTShape = TileSet.CollisionShape[ Value[ X, Y ] ]
				If Not CollisionShape Then Continue
				Local CollisionSprite:LTSprite = LTSprite( CollisionShape )
				Local BX:Float = LeftX() + ( 0.5 + X ) * GetTileWidth()
				Local BY:Float = TopY() + ( 0.5 + Y ) * GetTileHeight()
				If CollisionSprite Then
					If CollisionSprite.ShapeType = LTSprite.Rectangle And  CollisionSprite.X = 0.5:Double And CollisionSprite.Y = 0.5:Double ..
							And CollisionSprite.Width = 1.0:Double And CollisionSprite.Height = 1.0:Double Then
						FilledTile[ X, Y ] = CollisionShape.CollisionLayer
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
				
				Local CollisonLayer:Int = FilledTile[ X, Y ]
				
				Local X2:Int
				For X2 = X + 1 Until XQuantity
					If Not FilledTile[ X2, Y ] Then Exit
				Next
				
				Local Y2:Int, XX:Int
				For Y2 = Y + 1 Until YQuantity
					For XX = X Until X2
						If FilledTile[ XX, Y2 ] <> CollisionLayer Then Exit
					Next
					If XX < X2 Then Exit
				Next
				
				For Local YY:Int = Y Until Y2
					For Local XX:Int = X Until X2
						FilledTile[ XX, YY ] = False
					Next
				Next
				
				Local PX1:Float = LeftX() + X * GetTileWidth()
				Local PY1:Float = TopY() + Y * GetTileHeight()
				Local PX2:Float = LeftX() + X2 * GetTileWidth()
				Local PY2:Float = TopY() + Y2 * GetTileHeight()
				PolygonDefinition.SetVertices( [ Vec2( PX1, PY1 ), Vec2( PX2, PY1 ), Vec2( PX2, PY2 ), Vec2( PX1, PY2 ) ] )
				LTBox2DSprite.AttachToBody( Body, PolygonDefinition, ShapeParameters, Null )
			Next
		Next
		
		Body.SetMassFromShapes()
	End Method
	
	
	
	Method AttachTileCollisionSpriteToBody( TileX:Int, TileY:Int, CollisionSprite:LTSprite, ShapeParameters:LTBox2DShapeParameters, Body:b2Body )
		Local TileWidth:Double = GetTileWidth()
		Local TileHeight:Double = GetTileHeight()
		ServiceSprite.Width = TileWidth * CollisionSprite.Width
		ServiceSprite.Height = TileHeight * CollisionSprite.Height
		ServiceSprite.ShapeType = CollisionSprite.ShapeType
		LTBox2DSprite.AttachSpriteShapesToBody( ServiceSprite, ShapeParameters, Body, LeftX() + TileWidth * ( TileX + CollisionSprite.X ), TopY() + TileHeight * ( TileY + CollisionSprite.Y ) )
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewTileMap:LTBox2DTileMap = New LTBox2DTileMap
		CopyTileMapTo( NewTileMap )
		Return NewTileMap
	End Method
	
	
	
	Method Physics:Int()
		Return True
	End Method
End Type