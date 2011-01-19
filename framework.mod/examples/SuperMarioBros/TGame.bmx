Type TGame Extends LTProject
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
	Field SmallMarioImage:LTImage = LTImage.FromFile( "media\SmallMario.png", 6 )
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
	
	Field Mario:TMario
	
	
	
	Method Init()
		InitGraphics()
		World = LTWorld.LoadFromFile( "media\world.xml" )
		CollisionMap = LTCollisionMap.Create( 128, 8 )
		LoadPage( "Land" )
	End Method
	
	
	
	Method LoadSprite( Sprite:LTSprite, Name:String )
		Local NewSprite:LTSprite
		Select Name
			Case "Start"
				Mario = New TMario
				NewSprite = Mario
			Case "Goomba"
				NewSprite = New TGoomba
			Case "KoopaTroopa"
				NewSprite = New TKoopaTroopa
			Case "FlagOnPole"
				NewSprite = New LTSprite
			Default
				L_Assert( False, "Sprite type " + Name + " not found" )
		End Select
		Sprite.CopyTo( NewSprite )
		CollisionMap.InsertSprite( NewSprite )
		Sprites.AddLast( NewSprite )
	End Method
End Type