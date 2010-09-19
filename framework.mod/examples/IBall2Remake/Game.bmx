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
	Field EnemyImage:LTImage[]
	Field BulletImage:LTImage
	Field Objects:LTList
	Field DestructingObjects:LTList = New LTList
	Field Bullets:LTList = New LTList
	
	
	
	Method Init()
		Local TileSize:Float = L_ScreenXSize / 16
		L_CurrentCamera.SetCoords( 6.0, 5.5 )
		L_CurrentCamera.SetSize( 13.0, 12.0 )
		L_CurrentCamera.Viewport.SetCoords( TileSize * 6.5, TileSize * 6.0 )
		L_CurrentCamera.Viewport.SetSize( TileSize * 13.0, TileSize * 12.0 )
		L_CurrentCamera.Update()
		
		Local BallVisual:LTImageVisual = LTImageVisual.FromFile( "media\ball.png" )
		BallVisual.Rotating = False
		Ball.Visual = BallVisual
		Ball.SetCoords( 0, 4.0 )
		
		BlockVisual.Image = LTImage.FromFile( "media\tiles.png", 16, 11 )
		BlockVisual.Rotating = False
		FlashingVisual.Image = BlockVisual.Image
		FlashingVisual.Rotating = False
		
		TileMap.Visual = BlockVisual
		TileMap.SetSize( 15.0, 14.0 )
		TileMap.SetCoords( 6.0, 5.5 )
		TileMap.ActorArray = New LTActor[ TilesQuantity ]
		
		EnemyImage = New LTImage[ EnemiesQuantity ]
		EnemyImage[ TEnemy.Angel ] = LTImage.FromFile( "media\angel.png", 4, 1 )
		EnemyImage[ TEnemy.BallWithSquare ] = LTImage.FromFile( "media\ballwithsquare.png", 4, 1 )
		EnemyImage[ TEnemy.BeachBall ] = LTImage.FromFile( "media\beachball.png", 4, 1 )
		EnemyImage[ TEnemy.Mushroom ] = LTImage.FromFile( "media\mushroom.png", 4, 1 )
		EnemyImage[ TEnemy.Pacman ] = LTImage.FromFile( "media\pacman.png", 4, 1 )
		EnemyImage[ TEnemy.Pad ] = LTImage.FromFile( "media\pad.png", 4, 1 )
		EnemyImage[ TEnemy.Reel ] = LTImage.FromFile( "media\reel.png", 4, 1 )
		EnemyImage[ TEnemy.Sandwitch ] = LTImage.FromFile( "media\sandwitch.png", 4, 1 )
		EnemyImage[ TEnemy.Ufo ] = LTImage.FromFile( "media\ufo.png", 4, 1 )
		BulletImage = LTImage.FromFile( "media\bullet.png" )
		
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
		
		TLevel.Set( "01" )
	End Method
	
	
	
	Method Logic()
		Objects.Act()
		Bullets.Act()
		For Local Actor:TGameActor = Eachin DestructingObjects.List
			Actor.Fading()
		Next
		FlashingVisual.Act()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		DestructingObjects.Draw()
		Bullets.Draw()
		Objects.Draw()
	End Method
End Type





Type TLevel Extends LTObject
	Field FrameMap:LTIntMap
	Field Objects:LTList
	
	
	
	Function Set( Num:String )
		Local Level:TLevel = TLevel( L_LoadFromFile( "levels\" + Num + ".xml" ) )
		
		Game.CollisionMap = New LTCollisionMap
		Game.CollisionMap.SetResolution( 8, 8 )
		Game.CollisionMap.SetMapScale( 2.0, 2.0 )
		Game.TileMap.FrameMap = Level.FrameMap
		Game.Objects = Level.Objects
	
		For Local Actor:LTActor = Eachin Game.Objects.List
			Game.CollisionMap.InsertActor( Actor )
		Next
		Game.CollisionMap.InsertActor( Game.Ball )
		Game.Objects.AddLast( Game.Ball )
		
		Select Num
			Case "01"
				TEnemy.Create( 3.0, 2.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
				TEnemy.Create( 3.0, 5.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
				TEnemy.Create( 9.0, 6.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
				TEnemy.Create( 9.0, 9.0, TEnemy.Ufo, -2.0, -1.0, "00FF00" )
				TMovingBlock.Create( 7.0, 4.0, 48, -1.0 )
		End Select
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", FrameMap ) )
		Objects = LTList( XMLObject.ManageObjectField( "objects", Objects ) )
	End Method
End Type