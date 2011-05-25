'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
	Field World:LTWorld
	Field Layer:LTLayer[]
	Field MainLayer:LTLayer
	Field MovingObjects:LTCollisionMap
	Field Tilemap:LTTileMap
	Field TileShape:LTShape[]
	Field TileMapVisualizer:LTAnimatedTileMapVisualizer = New LTAnimatedTileMapVisualizer
	Field ToExit:TExit
	
	Field SmallMario:LTImage = LTImage.FromFile( "media\SmallMario.png", Mario.FramesInRow, 4 )
	Field SuperMario:LTImage = LTImage.FromFile( "media\SuperMario.png", Mario.FramesInRow, 5 )
	Field Growth:LTImage = LTImage.FromFile( "media\Growth.png", 3 )
	
	Field Bricks:LTImage = LTImage.FromFile( "media\Bricks.png", 2 )
	Field Coin:LTImageVisualizer = LTImageVisualizer.FromFile( "media\FlippingCoin.png", 4 )
	Field MagicMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\MagicMushroom.png" )
	Field OneUpMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\1upMushroom.png" )
	Field StarMan:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Starman.png", 4 )
	Field FireFlower:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Fireflower.png", 4 )
	Field ScoreVis:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Score.png", 11 )
	Field Fireball:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field Explosion:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Explosion.png", 3 )

	Field BreakBlock:TSound = TSound.Load( "media\BreakBlock.ogg", False )
	Field Bump:TSound = TSound.Load( "media\Bump.ogg", False )
	Field CoinFlip:TSound = TSound.Load( "media\Coin.ogg", False )
	Field Jump:TSound = TSound.Load( "media\Jump.ogg", False )
	Field Powerup:TSound = TSound.Load( "media\Powerup.ogg", False )
	Field PowerupAppears:TSound = TSound.Load( "media\PowerupAppears.ogg", False )
	Field Pipe:TSound = TSound.Load( "media\Pipe.ogg", False )
	Field Stomp:TSound = TSound.Load( "media\Stomp.ogg", False )
	Field OneUp:TSound = TSound.Load( "media\1-up.ogg", False )
	Field Kick:TSound = TSound.Load( "media\Kick.ogg", False )
	Field Firing:TSound = TSound.Load( "media\Fireball.ogg", False )
	
	Field Music1Intro:TSound = TSound.Load( "media\Music1intro.ogg", False )
	Field Music1:TSound = TSound.Load( "media\Music1.ogg", True )
	Field Music2:TSound = TSound.Load( "media\Music2.ogg", True )
	Field Invulnerability:TSound = TSound.Load( "media\Invulnerability.ogg", True )
	Field MarioDie:TSound = TSound.Load( "media\MarioDie.ogg", False )
	Field MusicChannel:TChannel
	
	Const MaxLayers:Int = 2
	Const Gravity:Float = 32.0
	Const FadingSpeed:Float = 0.15
	Const FadingPeriod:Int = 5
	Rem
	
	Field KoopaTroopaShell:LTImage = LTImage.FromFile( "media\KoopaTroopaShell.png" )
	Field SmallCoin:LTImage = LTImage.FromFile( "media\SmallCoin.png", 3 )
	
	Field Fireworks:TSound = TSound.Load( "media\Fireworks.ogg", False )
	Field FlagPole:TSound = TSound.Load( "media\FlagPole.ogg", False )
	Field GameOver:TSound = TSound.Load( "media\GameOver.ogg", False )
	Field StageClear:TSound = TSound.Load( "media\StageClear.ogg", False )
	Field Warning:TSound = TSound.Load( "media\Warning.ogg", False )
	EndRem
	
	Field Mario:TMario = New TMario
	Field Lives:Int = 3
	Field Score:Int
	Field Coins:Int
	
	
	
	Method Init()
		InitGraphics( 800, 600, 40.0 )
		SetClsColor( 92, 148, 252 )
		World = LTWorld.FromFile( "world.lw" )
		'L_CurrentCamera.Velocity = 10.0
		
		Tilemap = World.FindTilemap()
		TileShape = New LTShape[ Tilemap.TilesQuantity ]
		TileMapVisualizer.TileNum = New Int[ Tilemap.TilesQuantity ]
		TileMapVisualizer.Image = Tilemap.Visualizer.GetImage()
		For Local N:Int = 0 Until Tilemap.TilesQuantity
			If L_IntInLimits( N, 9, 13 ) Or L_IntInLimits( N, 15, 18 ) Or N = 23 Or N = 24 Or N >= 36 Then
				Local Sprite:LTSprite
				If N = 40 Or N = 51 Or N = 52 Then
					Sprite = New TCoin
					Sprite.Width = 10.0 / 16.0
					Sprite.Height = 14.0 / 16.0
				Else
					Sprite = New TBlock
				End If
				Sprite.X = 0.5
				Sprite.Y = 0.5
				Sprite.ShapeType = LTSprite.Rectangle
				TileShape[ N ] = Sprite
			End If
			
			Select N
				Case 11
					TileMapVisualizer.TileNum[ N ] = 9
				Case 13
					TileMapVisualizer.TileNum[ N ] = 0
				Case 17, 18
					TileMapVisualizer.TileNum[ N ] = 10
				Default
					TileMapVisualizer.TileNum[ N ] = N
			End Select
		Next
		
		Mario.Visualizer = LTImageVisualizer.FromImage( SmallMario )
		
		InitLevel()
	End Method
	
	
	
	Method InitLevel()
		MovingObjects = LTCollisionMap.Create( 128, 8 )
		Layer = New LTLayer[ MaxLayers ]
		For Local N:Int = 0 Until MaxLayers
			MainLayer = LTLayer( World.FindShape( "Level1," + N ) )
			If MainLayer Then Layer[ N ] = LoadLayer( MainLayer )
			Layer[ N ].AddLast( Mario )
		Next
		GoToLayer( 0, 0 )
		Mario.Mode = Mario.Normal
	End Method
	
	
	
	Method GoToLayer( LayerNum:Int, PointNum:Int )
		MainLayer = Layer[ LayerNum ]
		Tilemap = Layer[ LayerNum ].FindTilemap()
		Tilemap.TileShape = TileShape
		TileMap.Visualizer = TileMapVisualizer
		
		If MusicChannel Then StopChannel( MusicChannel )
		Select LayerNum
			Case 0
				MusicChannel = PlaySound( Music1Intro )
			Case 1
				MusicChannel = PlaySound( Music2 )
		End Select
	
		Mario.JumpTo( MainLayer.FindShape( "Start," + PointNum ) )
		If Mario.Big Then Mario.Y:- 0.5
	End Method
	
	
	
	Method Logic()
		If Mario.Mode >= Mario.Growing Then
			Mario.PlayAnimation()
		Else
			Local Fading:Int = Max( ( Floor( Time / FadingSpeed ) Mod ( FadingPeriod + 4 ) ) - FadingPeriod, 0 )
			If Fading = 3 Then Fading = 1
			TileMapVisualizer.TileNum[ 9 ] = 9 + ( Fading > 0 ) * ( 39 + Fading )
			TileMapVisualizer.TileNum[ 11 ] = TileMapVisualizer.TileNum[ 9 ]
			TileMapVisualizer.TileNum[ 40 ] = 40 + ( Fading > 0 ) * ( 10 + Fading )
			MainLayer.Act()
		End If
		
		If Not MusicChannel.Playing() Then 
			If Mario.Mode = Mario.Dying Then
				InitLevel()
			Else
				MusicChannel = PlaySound( Music1 )
			End If
		End If
		If KeyHit( Key_Escape ) Then End
		'L_CurrentCamera.MoveUsingArrows()
	End Method
	
	
	
	Method Render()
		Cls
		MainLayer.Draw()
		ShowDebugInfo( MainLayer )
	End Method
	
	
	
	Method LoadVectorSprite:LTVectorSprite( Sprite:LTVectorSprite )
		Local NewSprite:LTVectorSprite
		Select Sprite.GetNamePart()
			Case "Goomba"
				NewSprite = New TGoomba
				MovingObjects.InsertSprite( NewSprite )
			Case "KoopaTroopa"
				NewSprite = New TKoopaTroopa
				MovingObjects.InsertSprite( NewSprite )
			Case "Trigger"
				NewSprite = New TTrigger
			Case "Exit"
				Local NewExit:TExit = New TExit
				NewExit.ToLayer = Sprite.GetNamePart( 2 ).ToInt()
				NewExit.ToPoint = Sprite.GetNamePart( 3 ).ToInt()
				NewSprite = NewExit
			Default
				NewSprite = New LTVectorSprite
				
			'	L_Error( "Sprite type " + Sprite.Name + " not found" )
		End Select
		Sprite.CopyVectorSpriteTo( NewSprite )
		Return NewSprite
	End Method
End Type