'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TGame Extends LTProject
	Field Ball:TBall = New TBall
	Field BlockVisual:LTImageVisual = New LTImageVisual
	Field FlashingVisual:LTFlashingVisual = New LTFlashingVisual
	Field CurrentLevel:TLevel
	Field CollisionMap:LTCollisionMap
	Field TileMap:LTTileMap = New LTTileMap
	Field KeyCollected:Int
	Field Score:Int
	Field EnemyVisual:LTImageVisual[]
	Field Objects:LTList
	
	
	
	Method Init()
		Local TileSize:Float = L_ScreenXSize / 16
		L_CurrentCamera.Viewport.SetCoords( TileSize * 6.5, TileSize * 6.0 )
		L_CurrentCamera.Viewport.SetSize( TileSize * 13.0, TileSize * 12.0 )
		L_CurrentCamera.SetSize( 13.0, 12.0 )
		'L_CurrentCamera.SetMagnification( TileSize, TileSize )
		'L_CurrentCamera.SetCoords( 0.0, 0.0 )
		'debugstop
		L_CurrentCamera.Update()
		
		Local BallVisual:LTImageVisual = LTImageVisual.FromFile( "media\ball.png" )
		BallVisual.Rotating = False
		Ball.Visual = BallVisual
		Ball.SetCoords( 0, -3.0 )
		
		BlockVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 11 )
		FlashingVisual.Image = BlockVisual.Image
		
		TileMap.Visual = BlockVisual
		TileMap.SetSize( 15.0, 14.0 )
		TileMap.ActorArray = New LTActor[ TilesQuantity ]
		
		EnemyVisual = New LTImageVisual[ EnemiesQuantity ]
		EnemyVisual[ TEnemy.Angels ] = LTImageVisual.FromFile( "media\angels.png", 4, 1 )
		EnemyVisual[ TEnemy.BallWithSquare ] = LTImageVisual.FromFile( "media\ballwithsquare.png", 4, 1 )
		EnemyVisual[ TEnemy.BeachBall ] = LTImageVisual.FromFile( "media\beachball.png", 4, 1 )
		EnemyVisual[ TEnemy.Mushroom ] = LTImageVisual.FromFile( "media\mushroom.png", 4, 1 )
		EnemyVisual[ TEnemy.Pacman ] = LTImageVisual.FromFile( "media\pacman.png", 4, 1 )
		EnemyVisual[ TEnemy.Pad ] = LTImageVisual.FromFile( "media\pad.png", 4, 1 )
		EnemyVisual[ TEnemy.Reel ] = LTImageVisual.FromFile( "media\reel.png", 4, 1 )
		EnemyVisual[ TEnemy.Sandwitch ] = LTImageVisual.FromFile( "media\sandwitch.png", 4, 1 )
		EnemyVisual[ TEnemy.Ufo ] = LTImageVisual.FromFile( "media\ufo.png", 4, 1 )
		
		For Local N:Int = 0 Until EnemiesQuantity
			EnemyVisual[ N ].Rotating = False
		Next
		
		For Local N:Int = 1 Until TilesQuantity
			Local Actor:LTActor
			If N < 32 Then
				Select N
					Case 0
					Case 12, 13, 14, 15
						Local Block:TCollectableBlock = New TCollectableBlock
						Select N
							Case 12
								Block.BlockType = TCollectableBlock.Key
							Case 13
								Block.BlockType = TCollectableBlock.Diamond
							Case 14
								Block.BlockType = TCollectableBlock.Bomb
							Case 15
								Block.BlockType = TCollectableBlock.Badge
							Default
								Block.BlockType = TCollectableBlock.Score
						End Select
						Actor = Block
						Actor.Shape = L_Circle
					Default
						Actor = New TExitBlock
						Actor.Shape = L_Rectangle
				End Select
			ElseIf N < 32 Then
				Local Block:TCollectableBlock = New TCollectableBlock
				Block.BlockType = TCollectableBlock.Score
				Block.Shape = L_Circle
				Actor = Block
			Else
				Actor = New TBlock
				Actor.Shape = L_Rectangle
			End If
			
			Actor.SetCoords( 0.5, 0.5 )
			TileMap.ActorArray[ N ] = Actor
		Next
		
		CurrentLevel = TLevel.FromFile( "levels\01.xml" )
		CollisionMap.InsertActor( Ball )

		TEnemy.Create( 0, -4, 0, 1.0, 1.0 )
	End Method
	
	
	
	Method Logic()
		Objects.Act()
		FlashingVisual.Act()
		Ball.Act()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		Ball.Draw()
		CurrentLevel.Objects.Draw()
	End Method
End Type





Type TLevel Extends LTObject
	Field FrameMap:LTIntMap
	Field Objects:LTList
	
	
	
	Function FromFile:TLevel( Filename:String )
		Local Level:TLevel = TLevel( L_LoadFromFile( Filename ) )
		
		Game.CollisionMap = New LTCollisionMap
		Game.CollisionMap.SetResolution( 8, 8 )
		Game.CollisionMap.SetMapScale( 2.0, 2.0 )
		Game.TileMap.FrameMap = Level.FrameMap
		Game.Objects = Level.Objects
	
		For Local Actor:LTActor = Eachin Game.Objects.List
			Game.CollisionMap.InsertActor( Actor )
		Next
		
		Return Level
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
	End Method
End Type





Type TGameActor Extends LTActor
End Type