Type TGame Extends LTProject
	Field OneUpSound:LTSound = LTSound.FromFile( "media\1-up.ogg" )
	Field OneUpMushroomImage:LTImage = LTImage.FromFile( "media\1upMushroom.png" )
	Field BlockImage:LTImage = LTImage.FromFile( "media\Block.png" )
	Field BreakBlockSound:LTSound = LTSound.FromFile( "media\BreakBlock.ogg" )
	Field BumpSound:LTSound = LTSound.FromFile( "media\Bump.ogg" )
	Field CoinSound:LTSound = LTSound.FromFile( "media\Coin.ogg" )
	Field CoinImage:LTImage = LTImage.FromFile( "media\Coin.png" )
	Field FieryMarioImage:LTImage = LTImage.FromFile( "media\FieryMario.png" )
	Field FireballSound:LTSound = LTSound.FromFile( "media\Fireball.ogg" )
	Field FireballImage:LTImage = LTImage.FromFile( "media\Fireball.png" )
	Field FireballHitImage:LTImage = LTImage.FromFile( "media\FireballHit.png" )
	Field FireflowerImage:LTImage = LTImage.FromFile( "media\Fireflower.png" )
	Field FireworksSound:LTSound = LTSound.FromFile( "media\Fireworks.ogg" )
	Field FlagOnCastleImage:LTImage = LTImage.FromFile( "media\FlagOnCastle.png" )
	Field FlagPoleSound:LTSound = LTSound.FromFile( "media\FlagPole.ogg" )
	Field FlippingCoinImage:LTImage = LTImage.FromFile( "media\FlippingCoin.png" )
	Field GameOverSound:LTSound = LTSound.FromFile( "media\GameOver.ogg" )
	Field JumpSound:LTSound = LTSound.FromFile( "media\Jump.ogg" )
	Field KickSound:LTSound = LTSound.FromFile( "media\Kick.ogg" )
	Field KoopaTroopaShellImage:LTImage = LTImage.FromFile( "media\KoopaTroopaShell.png" )
	Field MagicMushroomImage:LTImage = LTImage.FromFile( "media\MagicMushroom.png" )
	Field MarioDieSound:LTSound = LTSound.FromFile( "media\MarioDie.ogg" )
	Field MarioImmortalImage:LTImage = LTImage.FromFile( "media\MarioImmortal.png" )
	Field Music1Sound:LTSound = LTSound.FromFile( "media\Music1.ogg" )
	Field Music1introSound:LTSound = LTSound.FromFile( "media\Music1intro.ogg" )
	Field Music2Sound:LTSound = LTSound.FromFile( "media\Music2.ogg" )
	Field PipeSound:LTSound = LTSound.FromFile( "media\Pipe.ogg" )
	Field PowerupSound:LTSound = LTSound.FromFile( "media\Powerup.ogg" )
	Field PowerupAppearsSound:LTSound = LTSound.FromFile( "media\PowerupAppears.ogg" )
	Field ScoreImage:LTImage = LTImage.FromFile( "media\Score.png" )
	Field SmallCoinImage:LTImage = LTImage.FromFile( "media\SmallCoin.png" )
	Field SmallMarioImage:LTImage = LTImage.FromFile( "media\SmallMario.png" )
	Field StageClearSound:LTSound = LTSound.FromFile( "media\StageClear.ogg" )
	Field StarmanImage:LTImage = LTImage.FromFile( "media\Starman.png" )
	Field StompSound:LTSound = LTSound.FromFile( "media\Stomp.ogg" )
	Field SuperMarioImage:LTImage = LTImage.FromFile( "media\SuperMario.png" )
	Field SuperMarioImmortalImage:LTImage = LTImage.FromFile( "media\SuperMarioImmortal.png" )
	Field WarningSound:LTSound = LTSound.FromFile( "media\Warning.ogg" )
	
	Field World:LTWorld
	Field Objects:LTList = New LTList
	Field Mario:TMario
	
	
	
	Method Init()
		World = LTWorld.LoadFromFile( "media\world.xml" )
		LoadPage( "Land" )
	End Method
	
	
	
	Method LoadPage( PageName:String )
		Objects.Clear()
		Super.LoadPage( PageName )
	End Method
	
	
	
	Method LoadSprite( Sprite:LTSprite, Name:String )
		Local NewSprite:LTSprite
		Select Name
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
		Objects.AddLast( NewSprite )
	End Method
End Type
