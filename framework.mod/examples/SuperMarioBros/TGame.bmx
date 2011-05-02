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
	Field MovingObjects:LTCollisionMap
	Field Tilemap:LTTileMap
	Field Over:Int = False
	
	
	Field SmallMarioImage:LTImage = LTImage.FromFile( "media\SmallMario.png", 7 )
	Field Bricks:LTImage = LTImage.FromFile( "media\Bricks.png", 2 )
	Field Coin:LTImageVisualizer = LTImageVisualizer.FromFile( "media\FlippingCoin.png", 4 )
	Field MagicMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\MagicMushroom.png" )
	Field OneUpMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\1upMushroom.png" )
	Field StarMan:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Starman.png", 4 )

	Field BreakBlock:TSound = TSound.Load( "media\BreakBlock.ogg", False )
	Field Bump:TSound = TSound.Load( "media\Bump.ogg", False )
	Field CoinFlip:TSound = TSound.Load( "media\Coin.ogg", False )
	Field Jump:TSound = TSound.Load( "media\Jump.ogg", False )
	Field PowerupAppears:TSound = TSound.Load( "media\PowerupAppears.ogg", False )
	
	Field Music1Intro:TSound = TSound.Load( "media\Music1intro.ogg", False )
	Field Music1:TSound = TSound.Load( "media\Music1.ogg", True )
	Field MarioDie:TSound = TSound.Load( "media\MarioDie.ogg", False )
	Field MusicChannel:TChannel
	Rem
	
	Field BlockImage:LTImage = LTImage.FromFile( "media\Block.png" )
	Field FieryMarioImage:LTImage = LTImage.FromFile( "media\FieryMario.png", 7 )
	Field FireballImage:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field FireballHitImage:LTImage = LTImage.FromFile( "media\FireballHit.png", 3 )
	Field FireflowerImage:LTImage = LTImage.FromFile( "media\Fireflower.png", 4 )
	Field FlagOnCastleImage:LTImage = LTImage.FromFile( "media\FlagOnCastle.png" )
	Field FlippingCoinImage:LTImage = LTImage.FromFile( "media\FlippingCoin.png", 4 )
	Field KoopaTroopaShellImage:LTImage = LTImage.FromFile( "media\KoopaTroopaShell.png" )
	Field MarioImmortalImage:LTImage = LTImage.FromFile( "media\MarioImmortal.png", 6 )
	Field ScoreImage:LTImage = LTImage.FromFile( "media\Score.png", 11 )
	Field SmallCoinImage:LTImage = LTImage.FromFile( "media\SmallCoin.png", 3 )
	Field SuperMarioImage:LTImage = LTImage.FromFile( "media\SuperMario.png", 7 )
	Field SuperMarioImmortalImage:LTImage = LTImage.FromFile( "media\SuperMarioImmortal.png", 7 )
	
	Field FireballSound:LTSound = LTSound.FromFile( "media\Fireball.ogg" )
	Field FireworksSound:LTSound = LTSound.FromFile( "media\Fireworks.ogg" )
	Field FlagPoleSound:LTSound = LTSound.FromFile( "media\FlagPole.ogg" )
	Field GameOverSound:LTSound = LTSound.FromFile( "media\GameOver.ogg" )
	Field KickSound:LTSound = LTSound.FromFile( "media\Kick.ogg" )
	Field Music2Sound:LTSound = LTSound.FromFile( "media\Music2.ogg" )
	Field OneUpSound:LTSound = LTSound.FromFile( "media\1-up.ogg" )
	Field PipeSound:LTSound = LTSound.FromFile( "media\Pipe.ogg" )
	Field PowerupSound:LTSound = LTSound.FromFile( "media\Powerup.ogg" )
	Field StageClearSound:LTSound = LTSound.FromFile( "media\StageClear.ogg" )
	Field StompSound:LTSound = LTSound.FromFile( "media\Stomp.ogg" )
	Field WarningSound:LTSound = LTSound.FromFile( "media\Warning.ogg" )
	EndRem
	
	Field Mario:TMario
	
	
	
	Method Init()
		InitGraphics()
		World = LTWorld.FromFile( "world.lw" )
		'L_CurrentCamera.Velocity = 10.0
		InitLevel()
	End Method
	
	
	
	Method InitLevel()
		MovingObjects = LTCollisionMap.Create( 128, 8 )
		LoadLayer( "Land" )', False )
		Tilemap = MainLayer.FindTilemap()
		
		For Local N:Int = 0 Until Tilemap.TilesQuantity
			If L_IntInLimits( N, 9, 13 ) Or L_IntInLimits( N, 15, 18 ) Or N = 23 Or N = 24 Or N >= 36 Then
				Local Sprite:LTSprite = New LTSprite
				Sprite.X = 0.5
				Sprite.Y = 0.5
				Sprite.ShapeType = LTSprite.Rectangle
				Tilemap.TileShape[ N ] = Sprite
			End If
		Next
		
		MusicChannel = Music1Intro.Play()
	End Method
	
	
	
	Method Render()
		Super.Render()
		ShowFPS()
	End Method
	
	
	
	Method Logic()
		Super.Logic()
		If Not MusicChannel.Playing() Then 
			If Over Then
				InitLevel()
				Over = False
			Else
				MusicChannel = PlaySound( Music1 )
			End If
		End If
		If KeyHit( Key_Escape ) Then End
		'L_CurrentCamera.MoveUsingArrows()
	End Method
	
	
	
	Method LoadVectorSprite:LTVectorSprite( Sprite:LTVectorSprite )
		Local NewSprite:LTVectorSprite
		Select Sprite.Name
			Case "Start"
				Mario = New TMario
				NewSprite = Mario
			Case "Goomba"
				NewSprite = New TGoomba
				MovingObjects.InsertSprite( NewSprite )
			Case "KoopaTroopa"
				NewSprite = New TKoopaTroopa
				MovingObjects.InsertSprite( NewSprite )
			Default
				NewSprite = New LTVectorSprite
				
			'	L_Error( "Sprite type " + Sprite.Name + " not found" )
		End Select
		Sprite.CopyVectorSpriteTo( NewSprite )
		Return NewSprite
	End Method
End Type