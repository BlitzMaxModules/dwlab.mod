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
	
	Field SmallMario:LTImage = LTImage.FromFile( "media\SmallMario.png", 7, 4 )
	Field SuperMario:LTImage = LTImage.FromFile( "media\SuperMario.png", 7, 5 )
	Field Growth:LTImage = LTImage.FromFile( "media\Growth.png", 3 )
	
	Field Bricks:LTImage = LTImage.FromFile( "media\Bricks.png", 2 )
	Field Coin:LTImageVisualizer = LTImageVisualizer.FromFile( "media\FlippingCoin.png", 4 )
	Field MagicMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\MagicMushroom.png" )
	Field OneUpMushroom:LTImageVisualizer = LTImageVisualizer.FromFile( "media\1upMushroom.png" )
	Field StarMan:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Starman.png", 4 )
	Field FireFlower:LTImageVisualizer = LTImageVisualizer.FromFile( "media\Fireflower.png", 4 )

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
	
	Field Music1Intro:TSound = TSound.Load( "media\Music1intro.ogg", False )
	Field Music1:TSound = TSound.Load( "media\Music1.ogg", True )
	Field Invulnerability:TSound = TSound.Load( "media\Invulnerability.ogg", True )
	Field MarioDie:TSound = TSound.Load( "media\MarioDie.ogg", False )
	Field MusicChannel:TChannel
	
	Const Gravity:Float = 32.0
	Rem
	
	Field Block:LTImage = LTImage.FromFile( "media\Block.png" )
	Field Fireball:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field FireballHit:LTImage = LTImage.FromFile( "media\FireballHit.png", 3 )
	Field FlagOnCastle:LTImage = LTImage.FromFile( "media\FlagOnCastle.png" )
	Field FlippingCoin:LTImage = LTImage.FromFile( "media\FlippingCoin.png", 4 )
	Field KoopaTroopaShell:LTImage = LTImage.FromFile( "media\KoopaTroopaShell.png" )
	Field Score:LTImage = LTImage.FromFile( "media\Score.png", 11 )
	Field SmallCoin:LTImage = LTImage.FromFile( "media\SmallCoin.png", 3 )
	
	Field Fireball:TSound = TSound.Load( "media\Fireball.ogg", False )
	Field Fireworks:TSound = TSound.Load( "media\Fireworks.ogg", False )
	Field FlagPole:TSound = TSound.Load( "media\FlagPole.ogg", False )
	Field GameOver:TSound = TSound.Load( "media\GameOver.ogg", False )
	Field Music2:TSound = TSound.Load( "media\Music2.ogg", False )
	Field StageClear:TSound = TSound.Load( "media\StageClear.ogg", False )
	Field Warning:TSound = TSound.Load( "media\Warning.ogg", False )
	EndRem
	
	Field Mario:TMario
	Field Lives:Int = 3
	Field Score:Int
	
	
	
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
		
		MusicChannel = PlaySound( Music1Intro )
		
		Mario.Mode = Mario.Normal
		Mario.Visualizer.SetImage( SmallMario )
	End Method
	
	
	
	Method Logic()
		If Mario.Mode >= Mario.Growing Then
			Mario.PlayAnimation()
		Else
			Super.Logic()
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