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
	Const TreesQuantity:Int = 15000
	
	
	
	Method Init()
		SetResolution( 128, 128 )
		SetCoords( 64.0, 64.0 )
		SetSize( 128.0, 128.0 )
		Game.Level.SetBounds( Self )
		
		Local HeightMap:LTDoubleMap = New LTDoubleMap
		HeightMap.SetResolution( 128, 128 )
    HeightMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
    HeightMap.ExtractTo( Self, 0.4, 1.0, 7 )
    
    Stretch( 2, 2 )
    Enframe()
		
		Local CollisionShape:LTSprite = New LTSprite
		CollisionShape.SetCoords( 0.5, 0.5 )
		CollisionShape.SetSize( 1.0, 1.0 )

		TileSet.CollisionShape[ 0 ] = CollisionShape
		TileSet.CollisionShape[ 4 ] = CollisionShape
		TileSet.CollisionShape[ 16 ] = CollisionShape
		
		Game.Trees = LTCollisionMap.CreateForShape( Self, 5.0 )
		Game.Trees.FrameWidth = 2.5
		LTLayer( Game.Level.FindShape( "Trees" ) ).AddLast( Game.Trees )
		For Local N:Int = 1 To TreesQuantity
			Local NewObject:TGameObject = New TGameObject
			NewObject.SetCoords( Rnd( 0.0, 128.0 ), Rnd( 0.0, 128.0 ) )
			NewObject.SetDiameter( Rnd( 2.0, 4.0 ) )
			
			NewObject.CollisionsWithCollisionMap( Game.Trees )
			If Not NewObject.Bad Then
				NewObject.CollisionsWithTileMap( Self )
				If Not NewObject.Bad Then
					Local NewTree:TTree = New TTree
					NewTree.SetCoords( NewObject.X, NewObject.Y )
					NewTree.SetDiameter( NewObject.GetDiameter() * 0.25 )
					NewTree.Angle = Rnd( 360.0 )
					NewTree.Visualizer = New LTImageVisualizer.FromImage( Game.Tree )
					NewTree.Visualizer.SetVisualizerScale( 6.0, 6.0 )
					NewTree.Frame = Rand( 0, 2 )
					NewTree.ShapeType = LTSprite.Circle
					Game.Trees.InsertSprite( NewTree )
				End If
			End If
		Next

		For Local N:Int = 0 Until 20
			TileSet.CollisionShape[ N ] = CollisionShape
		Next
		TileSet.CollisionShape[ 0 ] = Null
		TileSet.CollisionShape[ 4 ] = Null
		TileSet.CollisionShape[ 16 ] = Null

		Game.Blocks = LTCollisionMap.CreateForShape( Self, 3.0 )
		LTLayer( Game.Level.FindShape( "Blocks" ) ).AddLast( Game.Blocks )
		For Local N:Int = 1 To ObjectsQuantity
			Local NewObject:TGameObject = New TGameObject
			NewObject.SetCoords( Rnd( 0.0, 128.0 ), Rnd( 0.0, 128.0 ) )
			
			Local ObjectType:Int = Rand( 0, 1 )
			Select ObjectType
				Case 0
					NewObject.SetDiameter( Rnd( 1.0, 1.5 ) )
					NewObject.ShapeType = LTSprite.Circle
				Case 1
					NewObject.SetSize( Rnd( 1.0, 2.0 ), Rnd( 1.0, 2.0 ) )
					NewObject.ShapeType = LTSprite.Rectangle
			End Select
			
			NewObject.CollisionsWithCollisionMap( Game.Blocks )
			If Not NewObject.Bad Then
				NewObject.CollisionsWithTileMap( Self )
				If Not NewObject.Bad Then
					Local NewBlock:TBlock = New TBlock
					NewBlock.SetCoords( NewObject.X, NewObject.Y )
					NewBlock.SetSize( NewObject.Width, NewObject.Height )
					NewBlock.ShapeType = NewObject.ShapeType
					Select ObjectType
						Case 0
							NewBlock.Visualizer = LTImageVisualizer.FromImage( Game.Brain )
							NewBlock.Visualizer.AlterColor( -0.5, 0.0 )
							NewBlock.Angle = Rnd( 360.0 )
						Case 1
							NewBlock.Visualizer = LTImageVisualizer.FromImage( Game.Pyramid )
					End Select
					Game.Blocks.InsertSprite( NewBlock )
				End If
			End If
		Next
	End Method
End Type