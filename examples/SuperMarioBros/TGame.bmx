'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Incbin "media\font.png"
Incbin "media\SmallMario.png"
Incbin "media\SuperMario.png"
Incbin "media\Growth.png"
Incbin "media\Score.png"
Incbin "media\FlippingCoin.png"
Incbin "media\MagicMushroom.png"
Incbin "media\Bricks.png"
Incbin "media\Fireflower.png"
Incbin "media\1upMushroom.png"
Incbin "media\Starman.png"
Incbin "media\Fireball.png"
Incbin "media\Explosion.png"
Incbin "media\FlagOnCastle.png"

Incbin "media\Jump.ogg"
Incbin "media\Stomp.ogg"
Incbin "media\Bump.ogg"
Incbin "media\Coin.ogg"
Incbin "media\PowerupAppears.ogg"
Incbin "media\Powerup.ogg"
Incbin "media\BreakBlock.ogg"
Incbin "media\Pipe.ogg"
Incbin "media\1-up.ogg"
Incbin "media\Kick.ogg"
Incbin "media\Fireball.ogg"
Incbin "media\FlagPole.ogg"
Incbin "media\Fireworks.ogg"

Incbin "media\MarioDie.ogg"
Incbin "media\Invulnerability.ogg"
Incbin "media\StageClear.ogg"
Incbin "media\GameOver.ogg"
Incbin "media\Warning.ogg"

Incbin "media\Music1.ogg"
Incbin "media\Music1intro.ogg"
Incbin "media\Music2.ogg"
	
Type TGame Extends LTProject
	Const Gravity:Double = 32.0

	Field Score:Int
	Field Lives:Int = 3
	Field Coins:Int
	Field TimeLeft:Int
	
	Field MovingObjects:LTSpriteMap
	Field Tilemap:LTTileMap
	Field World:LTWorld ' this field will store our world created in editor
	Field Level:LTLayer ' this field will store layer loaded from the world
	Field HUD:LTLayer
	Field LevelCamera:LTCamera = LTCamera.Create( 960, 720, 48.0 )
	Field HUDCamera:LTCamera = LTCamera.Create( 960, 720, 48.0 )
	Field Font:LTBitmapFont = LTBitmapFont.FromFile( "media\font.png", 32, 127, 16 )
	Field Levels:LTLayer[]
	Field SpriteMaps:LTSpriteMap[]
	Field LivesScreen:TLives = New TLives
	Field TimeModel:TTime = New TTime
	
	Field SmallMario:LTImage = LTImage.FromFile( "media\SmallMario.png", TMario.FramesInRow, 4 )
	Field SuperMario:LTImage = LTImage.FromFile( "media\SuperMario.png", TMario.FramesInRow, 5 )
	Field Growth:LTImage = LTImage.FromFile( "media\Growth.png", 3 )
	
	Field ScoreVisualizer:LTVisualizer = LTVisualizer.FromFile( "media\Score.png", 11 )
	Field Coin:LTVisualizer = LTVisualizer.FromFile( "media\FlippingCoin.png", 4 )
	Field Mushroom:LTVisualizer = LTVisualizer.FromFile( "media\MagicMushroom.png" )
	Field Bricks:LTImage = LTImage.FromFile( "media\Bricks.png", 2 )
	Field FireFlower:LTVisualizer = LTVisualizer.FromFile( "media\Fireflower.png", 4 )
	Field OneUpMushroom:LTVisualizer = LTVisualizer.FromFile( "media\1upMushroom.png" )
	Field StarMan:LTVisualizer = LTVisualizer.FromFile( "media\Starman.png", 4 )
	Field Fireball:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field Explosion:LTVisualizer = LTVisualizer.FromFile( "media\Explosion.png", 3 )
	Field FlagOnCastle:LTVisualizer = LTVisualizer.FromFile( "media\FlagOnCastle.png" )

	Field Jump:TSound = TSound.Load( L_Incbin + "media\Jump.ogg", False )
	Field Stomp:TSound = TSound.Load( L_Incbin + "media\Stomp.ogg", False )
	Field Bump:TSound = TSound.Load( L_Incbin + "media\Bump.ogg", False )
	Field CoinFlip:TSound = TSound.Load( L_Incbin + "media\Coin.ogg", False )
	Field PowerupAppears:TSound = TSound.Load( L_Incbin + "media\PowerupAppears.ogg", False )
	Field Powerup:TSound = TSound.Load( L_Incbin + "media\Powerup.ogg", False )
	Field BreakBlock:TSound = TSound.Load( L_Incbin + "media\BreakBlock.ogg", False )
	Field Pipe:TSound = TSound.Load( L_Incbin + "media\Pipe.ogg", False )
	Field OneUp:TSound = TSound.Load( L_Incbin + "media\1-up.ogg", False )
	Field Kick:TSound = TSound.Load( L_Incbin + "media\Kick.ogg", False )
	Field Firing:TSound = TSound.Load( L_Incbin + "media\Fireball.ogg", False )
	Field FlagPole:TSound = TSound.Load( L_Incbin + "media\FlagPole.ogg", False )
	Field Fireworks:TSound = TSound.Load( L_Incbin + "media\Fireworks.ogg", False )

	Field MusicChannel:TChannel = New TChannel
	Field MarioDie:TSound = TSound.Load( L_Incbin + "media\MarioDie.ogg", False )
	Field Invulnerability:TSound = TSound.Load( L_Incbin + "media\Invulnerability.ogg", True )
	Field StageClear:TSound = TSound.Load( L_Incbin + "media\StageClear.ogg", False )
	Field GameOver:TSound = TSound.Load( L_Incbin + "media\GameOver.ogg", False )
	Field Warning:TSound = TSound.Load( L_Incbin + "media\Warning.ogg", False )
	
	Field Intro:TSound[]
	Field Music:TSound[]
	Field CurrentLevelNum:Int
	
	
	
	Method Init()
		L_InitGraphics( 960, 720, 48.0 )
		L_DiscreteGraphics = True
		World = LTWorld.FromFile( "world.lw" )
		LoadAndInitLayer( HUD, LTLayer( LTWorld.FromFile( "hud.lw" ).FindShapeWithType( "LTLayer" ) ) )
		InitLevel()
	End Method
	
	
	
	Method InitLevel()
		Local LevelsQuantity:Int = World.Children.Count()
		Levels = New LTLayer[ LevelsQuantity ]
		SpriteMaps = New LTSpriteMap[ LevelsQuantity ]
		Music = New TSound[ LevelsQuantity ]
		Intro = New TSound[ LevelsQuantity ]
		
		Mario = New TMario
		Mario.SetWidth( 0.8 )
		Mario.Visualizer = New LTVisualizer.FromImage( Game.SmallMario )
		Mario.Visualizer.XScale = 1.0 / 0.8
		Mario.Init()
		
		For Local N:Int = 0 Until LevelsQuantity
			Local Layer:LTLayer = LTLayer( World.FindShapeWithParameter( "num", N, "LTLayer" ) )
			LoadAndInitLayer( Levels[ N ], Layer )
			Levels[ N ].AddLast( Mario )
			Levels[ N ].AttachModel( TimeModel )
			SpriteMaps[ N ] = LTSpriteMap( Levels[ N ].FindShapeWithType( "LTSpriteMap" ) )
			
			Local MusicNum:Int = Layer.GetParameter( "music" ).ToInt()
			Intro[ N ] = LoadSound( L_Incbin + "media\Music" + MusicNum + "intro.ogg" )
			Music[ N ]	= LoadSound( L_Incbin + "media\Music" + MusicNum + ".ogg" )
		Next
		
		LivesScreen.Execute()
		SwitchToLevel( 0 )
		TimeModel.Init( Null )
	End Method
	
	
	
	Method SwitchToLevel( Num:Int, PointNum:Int = 0 )
		CurrentLevelNum = Num
		Level = Levels[ Num ]
		TileMap = LTTileMap( Level.FindShapeWithType( "TTiles" ) )
		MovingObjects = SpriteMaps[ Num ]
		Mario.JumpTo( Level.FindShapeWithParameter( "num", PointNum, "TStart" ) )
		StartMusic()
	End Method
	
	
	
	Method StartMusic()
		MusicChannel.Stop()
		If Intro[ CurrentLevelNum ] Then MusicChannel = Intro[ CurrentLevelNum ].Play()
	End Method
	
	
	
	Method Logic()
		Level.Act()
		If Not Level.Active Then Level.FindShapeWithType( "TMario" ).Act()
		If KeyHit( Key_Escape ) Then End ' exit after pressing Escape
		If Not MusicChannel.Playing() Then MusicChannel = Music[ CurrentLevelNum ].Play()
	End Method
	
	
	Field DebugVis:Int
	Method Render()
		L_CurrentCamera = LevelCamera
		If DebugVis Then
			Level.DrawUsingVisualizer( L_DebugVisualizer )
		Else
			Level.Draw()
		End If
		If KeyHit( Key_D ) Then DebugVis = Not DebugVis
		L_CurrentCamera = HUDCamera
		HUD.Draw()
		L_CurrentCamera = LevelCamera
		ShowDebugInfo()
	End Method
End Type
