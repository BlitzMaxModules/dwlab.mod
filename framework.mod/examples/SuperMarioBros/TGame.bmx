Type TGame Extends LTProject
	Field CollisionMap:LTCollisionMap
	Field Tilemap:LTTileMap
	
	
	Field SmallMarioImage:LTImage = LTImage.FromFile( "media\SmallMario.png", 6 )

	Rem
	Field OneUpMushroomImage:LTImage = LTImage.FromFile( "media\1upMushroom.png" )
	Field BlockImage:LTImage = LTImage.FromFile( "media\Block.png" )
	Field CoinImage:LTImage = LTImage.FromFile( "media\Coin.png", 3 )
	Field FieryMarioImage:LTImage = LTImage.FromFile( "media\FieryMario.png", 7 )
	Field FireballImage:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field FireballHitImage:LTImage = LTImage.FromFile( "media\FireballHit.png", 3 )
	Field FireflowerImage:LTImage = LTImage.FromFile( "media\Fireflower.png", 4 )
	Field FlagOnCastleImage:LTImage = LTImage.FromFile( "media\FlagOnCastle.png" )
	Field FlippingCoinImage:LTImage = LTImage.FromFile( "media\FlippingCoin.png", 4 )
	Field KoopaTroopaShellImage:LTImage = LTImage.FromFile( "media\KoopaTroopaShell.png" )
	Field MagicMushroomImage:LTImage = LTImage.FromFile( "media\MagicMushroom.png" )
	Field MarioImmortalImage:LTImage = LTImage.FromFile( "media\MarioImmortal.png", 6 )
	Field ScoreImage:LTImage = LTImage.FromFile( "media\Score.png", 11 )
	Field SmallCoinImage:LTImage = LTImage.FromFile( "media\SmallCoin.png", 3 )
	Field StarmanImage:LTImage = LTImage.FromFile( "media\Starman.png", 4 )
	Field SuperMarioImage:LTImage = LTImage.FromFile( "media\SuperMario.png", 7 )
	Field SuperMarioImmortalImage:LTImage = LTImage.FromFile( "media\SuperMarioImmortal.png", 7 )
	
	Field BreakBlockSound:LTSound = LTSound.FromFile( "media\BreakBlock.ogg" )
	Field BumpSound:LTSound = LTSound.FromFile( "media\Bump.ogg" )
	Field CoinSound:LTSound = LTSound.FromFile( "media\Coin.ogg" )
	Field FireballSound:LTSound = LTSound.FromFile( "media\Fireball.ogg" )
	Field FireworksSound:LTSound = LTSound.FromFile( "media\Fireworks.ogg" )
	Field FlagPoleSound:LTSound = LTSound.FromFile( "media\FlagPole.ogg" )
	Field GameOverSound:LTSound = LTSound.FromFile( "media\GameOver.ogg" )
	Field JumpSound:LTSound = LTSound.FromFile( "media\Jump.ogg" )
	Field KickSound:LTSound = LTSound.FromFile( "media\Kick.ogg" )
	Field MarioDieSound:LTSound = LTSound.FromFile( "media\MarioDie.ogg" )
	Field Music1Sound:LTSound = LTSound.FromFile( "media\Music1.ogg" )
	Field Music1IntroSound:LTSound = LTSound.FromFile( "media\Music1intro.ogg" )
	Field Music2Sound:LTSound = LTSound.FromFile( "media\Music2.ogg" )
	Field OneUpSound:LTSound = LTSound.FromFile( "media\1-up.ogg" )
	Field PipeSound:LTSound = LTSound.FromFile( "media\Pipe.ogg" )
	Field PowerupSound:LTSound = LTSound.FromFile( "media\Powerup.ogg" )
	Field PowerupAppearsSound:LTSound = LTSound.FromFile( "media\PowerupAppears.ogg" )
	Field StageClearSound:LTSound = LTSound.FromFile( "media\StageClear.ogg" )
	Field StompSound:LTSound = LTSound.FromFile( "media\Stomp.ogg" )
	Field WarningSound:LTSound = LTSound.FromFile( "media\Warning.ogg" )
	EndRem
	
	Field Mario:TMario
	
	
	
	Method Init()
		InitGraphics()
		World = LTWorld.FromFile( "world.lw" )
		CollisionMap = LTCollisionMap.Create( 128, 8 )
		LoadLayer( "Land" )', False )
		Tilemap = MainLayer.FindTilemap()
		
		For Local N:Int = 0 Until Tilemap.TilesQuantity
			If L_IntInLimits( N, 9, 13 ) Or L_IntInLimits( N, 15, 18 ) Or N = 23 Or N = 24 Or L_IntInLimits( N, 36, 47 ) Then
				Local Sprite:LTSprite = New LTSprite
				Sprite.X = 0.5
				Sprite.Y = 0.5
				Sprite.ShapeType = L_Rectangle
				Tilemap.TileShape[ N ] = Sprite
			End If
		Next
		
		'L_CurrentCamera.Velocity = 10.0
	End Method
	
	
	
	Method Logic()
		Super.Logic()
		'CollisionMap.CollisionsWithGroup( MainLayer )
		Tilemap.TileCollisionsWithGroup( MainLayer )
		If KeyHit( Key_Escape ) Then End
		'L_CurrentCamera.MoveUsingArrows()
	End Method
	
	
	
	Method LoadSprite:LTSprite( Sprite:LTSprite )
		Local NewSprite:LTSprite
		Select Sprite.Name
			Case "Start"
				Mario = New TMario
				NewSprite = Mario
			'Case "Goomba"
			'	NewSprite = New TGoomba
			'Case "KoopaTroopa"
			'	NewSprite = New TKoopaTroopa
			Default
				NewSprite = New LTSprite
				
			'	L_Error( "Sprite type " + Sprite.Name + " not found" )
		End Select
		Sprite.CopySpriteTo( NewSprite )
		CollisionMap.InsertSprite( Sprite )
		Return NewSprite
	End Method
End Type