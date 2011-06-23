'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TTiles Extends LTTileMap
	Const ObjectsQuantity:Int = 5000
	
	
	
	Method Init()
		SetResolution( 128, 128 )
		SetCoords( 64.0, 64.0 )
		SetSize( 128.0, 128.0 )
		Game.Level.SetBounds( Self )
		
		Local HeightMap:LTDoubleMap = New LTDoubleMap
		HeightMap.SetResolution( 128, 128 )
    	HeightMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
    	HeightMap.ExtractTo( Self, 0.4, 1.0, 1 )
    
    	Stretch( 2, 2 )
    	EnframeBy( TileSet )
		
		Local CollisonShape:LTSprite = New LTSprite
		CollisonShape.SetCoords( 0.5, 0.5 )
		CollisonShape.SetSize( 1.0, 1.0 )
		TileSet.CollisionShape[ 0 ] = CollisonShape
		TileSet.CollisionShape[ 4 ] = CollisonShape
		TileSet.CollisionShape[ 16 ] = CollisonShape
		
		Local Objects:LTCollisionMap = LTCollisionMap.CreateForShape( Self, 2.0 )
		For Local N:Int = 1 To ObjectsQuantity
			Local NewObject:TScenery = New TScenery
			NewObject.SetCoords( Rnd( 0.0, 128.0 ), Rnd( 0.0, 128.0 ) )
			Select Rand( 0, 1 )
				Case 0
					NewObject.SetDiameter( Rnd( 0.75, 1.25 ) )
					NewObject.Visualizer = LTImageVisualizer.FromImage( Game.Brain )
					NewObject.ShapeType = LTSprite.Circle
				Case 1
					NewObject.SetSize( Rnd( 0.5, 1.5 ), Rnd( 0.5, 1.5 ) )
					NewObject.Visualizer = LTImageVisualizer.FromImage( Game.Pyramid )
					NewObject.ShapeType = LTSprite.Rectangle
			End Select
			
			NewObject.CollisionsWithCollisionMap()
			If Not NewObject.Bad Then
				NewObject.CollisionsWithTileMap( Self )
				If Not NewObject.Bad Then
					Objects.InsertSprite( NewObject )
				End If
			End If
		Next
	End Method
End Type