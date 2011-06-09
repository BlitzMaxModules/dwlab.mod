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
	Const Gravity:Float = 32.0
	Const MarioFramesInRow:Int = 9

	Field Score:Int
	Field Lives:Int = 3
	Field Coins:Int
	Field TimeLeft:Int
	
	Field MovingObjects:LTCollisionMap
	Field Tilemap:LTTileMap
	Field World:LTWorld ' this field will store our world created in editor
	Field Level:LTLayer ' this field will store layer loaded from the world
	Field HUD:LTLayer
	Field LevelCamera:LTCamera = LTCamera.Create( 960, 720, 48.0 )
	Field HUDCamera:LTCamera = LTCamera.Create( 960, 720, 48.0 )
	Field Font:LTBitmapFont = LTBitmapFont.FromFile( "media/font.png", 32, 127, 16 )
	
	Field SmallMario:LTImage = LTImage.FromFile( "media\SmallMario.png", MarioFramesInRow, 4 )
	Field SuperMario:LTImage = LTImage.FromFile( "media\SuperMario.png", MarioFramesInRow, 5 )
	Field Growth:LTImage = LTImage.FromFile( "media\Growth.png", 3 )
	
	Field ScoreVisualizer:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Score.png", 11 )
	Field Coin:LTImageVisualizer = LTImageVisualizer.FromFile( "media\FlippingCoin.png", 4 )
	Field Mushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\MagicMushroom.png" )
	Field Bricks:LTImage = LTImage.FromFile( "media\Bricks.png", 2 )

	Field Jump:TSound = TSound.Load( "media\Jump.ogg", False )
	Field Stomp:TSound = TSound.Load( "media\Stomp.ogg", False )
	Field Bump:TSound = TSound.Load( "media\Bump.ogg", False )
	Field CoinFlip:TSound = TSound.Load( "media\Coin.ogg", False )
	Field PowerupAppears:TSound = TSound.Load( "media\PowerupAppears.ogg", False )
	Field Powerup:TSound = TSound.Load( "media\Powerup.ogg", False )
	Field BreakBlock:TSound = TSound.Load( "media\BreakBlock.ogg", False )
	Field Pipe:TSound = TSound.Load( "media\Pipe.ogg", False )

	Field MusicChannel:TChannel
	Field MusicIntro:TSound = TSound.Load( "media\Music1intro.ogg", False )
	Field Music:TSound = TSound.Load( "media\Music1.ogg", True ) ' True for looped
	Field MarioDie:TSound = TSound.Load( "media\MarioDie.ogg", False )
	
	
	
	Method Init()
		InitGraphics( 960, 720, 48.0 )
		World = LTWorld.FromFile( "world.lw" )
		HUD = LoadLayer( LTLayer( LTWorld.FromFile( "hud.lw" ).FindShape( "LTLayer" ) ) )
		InitLevel()
	End Method
	
	
	
	Method InitLevel()
		MovingObjects = LTCollisionMap.Create( 128, 8, 2.0, 2.0 )
		Level = LoadLayer( LTLayer( World.FindShape( "LTLayer" ) ) )
		MusicChannel = MusicIntro.Play()		
	End Method
	
	
	
	Method Logic()
		Level.Act()
		If Not Level.Active Then Level.FindShapeWithType( "TMario" ).Act()
		If KeyHit( Key_Escape ) Then End ' exit after pressing Escape
		If Not MusicChannel.Playing() Then MusicChannel = Music.Play()
	End Method
	
	
	
	Method Render()
		L_CurrentCamera = LevelCamera
		Level.Draw()
		L_CurrentCamera = HUDCamera
		HUD.Draw()
		L_CurrentCamera = LevelCamera
		ShowDebugInfo( Level )
	End Method
End Type