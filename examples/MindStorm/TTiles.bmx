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
	Const FieldSize:Int = 128
	Const ObjectsQuantity:Int = 5000
	Const TreesQuantity:Int = 15000
	Const MinBrainSize:Double = 1.0
	Const MaxBrainSize:Double = 1.5
	Const MinPyramidSize:Double = 1.0
	Const MaxPyramidSize:Double = 2.0
	Const MinTreeSize:Double = 2.0
	Const MaxTreeSize:Double = 4.0
	Const TreeBranch:Double = 0.25
	Const TreeScale:Double = 6.0
	
	
	
	Method Init()
		SetResolution( FieldSize, FieldSize )
		SetCoords( 0.5 * FieldSize, 0.5 * FieldSize )
		SetSize( FieldSize, FieldSize )
		Game.Level.SetBounds( Self )
		
		Local HeightMap:LTDoubleMap = New LTDoubleMap
		HeightMap.SetResolution( FieldSize, FieldSize )
    	HeightMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
    	HeightMap.ExtractTo( Self, 0.4, 1.0, 7 )
    
    	Stretch( 2, 2 )
    	Enframe()
		
		Game.Bullets = LTSpriteMap.CreateForShape( Self, 5.0 )
		
		Local CollisionShape:LTSprite = New LTSprite
		CollisionShape.SetCoords( 0.5, 0.5 )
		CollisionShape.SetSize( 1.0, 1.0 )

		TileSet.CollisionShape[ 0 ] = CollisionShape
		TileSet.CollisionShape[ 4 ] = CollisionShape
		TileSet.CollisionShape[ 16 ] = CollisionShape
		
		Game.Trees = LTSpriteMap.CreateForShape( Self, 5.0 )
		Game.Trees.SetBorder( 2.5 )
		For Local N:Int = 1 To TreesQuantity
			Local NewObject:TGameObject = New TGameObject
			NewObject.SetCoords( Rnd( 0.0, FieldSize ), Rnd( 0.0, FieldSize ) )
			NewObject.SetDiameter( Rnd( MinTreeSize, MaxTreeSize ) )
			
			NewObject.CollisionsWithSpriteMap( Game.Trees )
			If Not NewObject.Bad Then
				NewObject.CollisionsWithTileMap( Self )
				If Not NewObject.Bad Then
					Local NewTree:TTree = New TTree
					NewTree.SetCoords( NewObject.X, NewObject.Y )
					NewTree.SetDiameter( NewObject.GetDiameter() * TreeBranch )
					NewTree.Angle = Rnd( 360.0 )
					NewTree.Visualizer = New LTVisualizer.FromImage( Game.Tree )
					NewTree.Visualizer.SetVisualizerScale( TreeScale, TreeScale )
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

		Game.Blocks = LTSpriteMap.CreateForShape( Self, 3.0 )
		For Local N:Int = 1 To ObjectsQuantity
			Local NewObject:TGameObject = New TGameObject
			NewObject.SetCoords( Rnd( 0.0, FieldSize ), Rnd( 0.0, FieldSize ) )
			
			Local ObjectType:Int = Rand( 0, 1 )
			Select ObjectType
				Case 0
					NewObject.SetDiameter( Rnd( MinBrainSize, MaxBrainSize ) )
					NewObject.ShapeType = LTSprite.Circle
				Case 1
					NewObject.SetSize( Rnd( MinPyramidSize, MaxPyramidSize ), Rnd( MinPyramidSize, MaxPyramidSize ) )
					NewObject.ShapeType = LTSprite.Rectangle
			End Select
			
			NewObject.CollisionsWithSpriteMap( Game.Blocks )
			If Not NewObject.Bad Then
				NewObject.CollisionsWithTileMap( Self )
				If Not NewObject.Bad Then
					Local NewBlock:TBlock = New TBlock
					NewBlock.SetCoords( NewObject.X, NewObject.Y )
					NewBlock.SetSize( NewObject.Width, NewObject.Height )
					NewBlock.ShapeType = NewObject.ShapeType
					Select ObjectType
						Case 0
							NewBlock.Visualizer = LTVisualizer.FromImage( Game.Brain )
							NewBlock.Visualizer.AlterColor( -0.5, 0.0 )
							NewBlock.Visualizer.Angle = Rnd( 360.0 )
						Case 1
							NewBlock.Visualizer = LTVisualizer.FromImage( Game.Pyramid )
							NewBlock.Visualizer.AlterColor( -0.2, 0.0 )
					End Select
					Game.Blocks.InsertSprite( NewBlock )
				End If
			End If
		Next
	End Method
End Type