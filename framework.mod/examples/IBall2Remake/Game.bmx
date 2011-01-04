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
	Field BlockVisualizer:LTImageVisualizer = New LTImageVisualizer
	Field FlashingVisualizer:LTFlashingVisualizer = New LTFlashingVisualizer
	Field CollisionMap:LTCollisionMap
	Field TileMap:LTTileMap = New LTTileMap
	Field KeyCollected:Int
	Field Score:Int
	Field EnemyImage:LTImage[]
	Field BulletImage:LTImage
	Field Objects:LTList
	Field DestructingObjects:LTList = New LTList
	Field Bullets:LTList = New LTList
	Field ScoreFont:LTFont
	Field NumbersFont:LTFont
	Field GameCamera:LTCamera = New LTCamera
	Field SidebarCamera:LTCamera = New LTCamera
	Field Sidebar:LTActor = New LTActor
	Field LevelStartTime:Float
	Field LevelTime:Float
	Field LevelNum:Int
	Field GeneratorImage:LTImage
	
	
	
	Method Init()
		L_IncludedObjects.Insert( "FlashingVisualizer", FlashingVisualizer )
		
		Local TileSize:Float = GraphicsWidth() / 16
		
		GameCamera.SetCoords( 6.0, 5.5 )
		GameCamera.SetSize( 13.0, 12.0 )
		GameCamera.Viewport.SetCoords( TileSize * 6.5, TileSize * 6.0 )
		GameCamera.Viewport.SetSize( TileSize * 13.0, TileSize * 12.0 )
		GameCamera.Update()
		
		SidebarCamera.Viewport.SetCoords( TileSize * 14.5, TileSize * 6.0 )
		SidebarCamera.Viewport.SetSize( TileSize * 3.0, TileSize * 12.0 )
		SidebarCamera.Update()
		
		Sidebar.Visualizer = LTImageVisualizer.FromFile( "media\sidebar.png" )
		Sidebar.Shape = L_Rectangle
		
		Local BallVisualizer:LTImageVisualizer = LTImageVisualizer.FromFile( "media\ball.png" )
		BallVisualizer.Rotating = False
		Ball.Visualizer = BallVisualizer
		
		Local BlockImage:LTImage = LTImage.FromFile( "media\tiles.png", 16, 11 )
		L_IncludedObjects.Insert( "BlockImage", BlockImage )
		BlockVisualizer.Image = BlockImage
		BlockVisualizer.Rotating = False
		FlashingVisualizer.Image = BlockVisualizer.Image
		FlashingVisualizer.Rotating = False
		GeneratorImage = LTImage.FromFile( "media\generator.png", 8, 5 )
		L_IncludedObjects.Insert( "GeneratorImage", GeneratorImage )
		
		TileMap.Visualizer = BlockVisualizer
		TileMap.SetSize( 15.0, 14.0 )
		TileMap.SetCoords( 6.0, 5.5 )
		TileMap.TileActor = New LTActor[ TilesQuantity ]
		
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
		For Local N:Int = 0 Until EnemiesQuantity
			L_IncludedObjects.Insert( "EnemyImage" + N, EnemyImage[ N ] )
		Next
		
		BulletImage = LTImage.FromFile( "media\bullet.png" )
		L_IncludedObjects.Insert( "BulletImage", BulletImage )
				
		Local Scale:Float = 1.0 * GraphicsWidth() / 256.0
		ScoreFont = LTFont.FromFile( "media\score.png", Asc( "0" ), Asc( "9" ), 10 )
		ScoreFont.SetFontScale( Scale, Scale )
		NumbersFont = LTFont.FromFile( "media\numbers.png", Asc( "0" ), Asc( "9" ), 10 )
		NumbersFont.SetFontScale( Scale, Scale )
		
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
			TileMap.TileActor[ N ] = Actor
		Next
		
		LoadLevel( 1 )
	End Method
	
	
	
	Method Logic()
		Objects.Act()
		Bullets.Act()
		For Local Actor:TGameActor = Eachin DestructingObjects
			Actor.Fading()
		Next
		FlashingVisualizer.Act()
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		L_CurrentCamera = GameCamera
		TileMap.Draw()
		DestructingObjects.Draw()
		Bullets.Draw()
		Objects.Draw()

		'For Local Y:Int = 0 Until CollisionMap.YQuantity
		'	For Local X:Int = 0 Until CollisionMap.XQuantity
		'		ScoreFont.Print( CollisionMap.Objects[ X, Y ].Count(), X * 75 + 37, Y * 75 + 37, L_AlignToCenter, L_AlignToCenter ) 
		'	Next
		'Next
		
		L_CurrentCamera = SidebarCamera
		Sidebar.Draw()
		ScoreFont.Print( L_FirstZeroes( Score, 6 ), GraphicsWidth() * 13 / 16, GraphicsWidth() * 6.5 / 16 )
		NumbersFont.Print( L_FirstZeroes( L_LimitInt( Floor( LevelStartTime - ProjectTime + LevelTime ), 0, 99 ), 2 ), GraphicsWidth() * 13.5 / 16, GraphicsWidth() * 8.5 / 16 )
		NumbersFont.Print( L_FirstZeroes( LevelNum, 2 ), GraphicsWidth() * 13.5 / 16, GraphicsWidth() * 10.5 / 16 )
	End Method
	
	
	
	Method LoadLevel( Num:Int )
		Game.CollisionMap = New LTCollisionMap
		Game.CollisionMap.SetResolution( 8, 8 )
		Game.CollisionMap.SetMapScale( 2.0, 2.0 )
		
		L_LoadFromFile( "levels\" + L_FirstZeroes( Num, 2 ) + ".xml" )
	
		For Local Actor:LTActor = Eachin Game.Objects
			If Not TEnemyGenerator( Actor ) Then Game.CollisionMap.InsertActor( Actor )
		Next
		
		Game.LevelNum = Num
		Game.LevelStartTime = Game.ProjectTime
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Game.TileMap.FrameMap = LTIntMap( XMLObject.ManageObjectField( "framemap", Game.TileMap.FrameMap ) )
		Game.Ball = TBall( XMLObject.ManageObjectField( "ball", Game.Ball ) )
		Game.Objects = LTList( XMLObject.ManageObjectField( "objects", Game.Objects ) )
	End Method
End Type