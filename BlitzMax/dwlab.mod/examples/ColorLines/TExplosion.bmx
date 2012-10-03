'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TExplosion Extends LTBehaviorModel
	Const MaxRadius:Int = 3
	Const CircleWidth:Double = 0.12
	Const ParticleSize:Double = 0.18
	Const DSize:Double = 0.05
	Const ParticleDensity:Double = 6.0
	Const Shift:Double = 0.03
	Const DShift:Double = 0.1
	Const ExplosionK:Double = 18.0
	Const AnimationSpeed:Double = 0.05

	Global Image:LTImage = LTImage.FromFile( L_Incbin + "images\explosion.png", 8, 1 )
	
	Field X:Int, Y:Int, BallNum:Int, StartingTime:Double, Exploded:Int
	
	Function Create( X:Int, Y:Int, Frame:Int = 0 )
		Local Model:TExplosion = New TExplosion
		Model.X = X
		Model.Y = Y
		Model.BallNum = Profile.Balls.GetTile( X, Y )
		Model.StartingTime = Game.Time - Frame * AnimationSpeed
		Local Sprite:LTSprite = LTSprite.FromShape( 0, 0, 3.0, 2.25 )
		Sprite.PositionOnTileMap( Profile.Balls, X, Y )
		Sprite.Visualizer.Image = Image
		Sprite.AttachModel( Model )
		Game.Particles.AddLast( Sprite )
		ManageFields( X, Y )
	End Function
		
	Method ApplyTo( Shape:LTShape )
		Local Frame:Int = 1.0:Double * ( Game.Time - StartingTime ) / AnimationSpeed
		If Frame >= 8 Then DeactivateModel( Shape ) Else LTSprite( Shape ).Frame = Frame
		If Frame = 4 And Not Exploded Then 
			L_CurrentProfile.PlaySnd( Game.ExplosionSound )
			Exploded = True
		End If
	End Method

	Method Deactivate( Shape:LTShape )
		Game.Particles.Remove( Shape )
		CreateParticles( X, Y, BallNum )
		For Local DY:Int = -1 To 1
			For Local DX:Int = -1 To 1
				If DY = 0 And DX = 0 Then Continue
				Local XDX:Int = X + DX
				Local YDY:Int = Y + DY
				If XDX > 0 And YDY > 0 And XDX < Profile.Balls.XQuantity - 1 And YDY < Profile.Balls.YQuantity - 1 Then
					Local isBomb:Int = False
					If Profile.Balls.GetTile( XDX, YDY ) = Profile.Bomb Then isBomb = True
					If isBomb Then
						TExplosion.Create( XDX, YDY, 4 )
					Else
						TExplosion.ManageParticles( XDX, YDY )
					End If
				End If
			Next
		Next
	End Method
	
	Function ManageFields( X:Int, Y:Int )
		Local BallNum:Int = Profile.Balls.GetTile( X, Y )
		If BallNum = 0 Then Return
		Profile.Balls.SetTile( X, Y, Profile.NoBall )
		Profile.Modifiers.SetTile( X, Y, Profile.NoModifier )
		
		Local TileNum:Int = Profile.GameField.GetTile( X, Y )
		Select TileNum
			Case Profile.Glue, Profile.ColdGlue
		 		Profile.GameField.SetTile( X, Y, TileNum - 1 )
			Case Profile.Ice, Profile.ColdIce
		 		Profile.GameField.SetTile( X, Y, TileNum - 2 )
				For Local Goal:TRemoveIce = Eachin Profile.Goals
					Goal.Count :- 1
				Next
		End Select
		Game.TotalBalls :+ 1
		For Local Goal:TRemoveBalls = Eachin Profile.Goals
			If ( Goal.BallType = TileNum Or Goal.BallType = Profile.RandomBall ) Then Goal.Count :- 1
		Next
	End Function
	
	Function CreateParticles( X:Int, Y:Int, BallNum:Int )
		For Local Radius:Double = 1 To MaxRadius
			Local Angle:Double = 0
			While Angle < 360.0
				Local Sprite:LTVectorSprite = New LTVectorSprite
				Local DX:Double = Radius * CircleWidth * Cos( Angle )
				Local DY:Double = Radius * CircleWidth * Sin( Angle )
				Sprite.PositionOnTilemap( Profile.Balls, DX + X + Rnd( -Shift, Shift ), DY + Y + Rnd( -Shift, Shift ) )
				Sprite.SetSize( ParticleSize + Rnd( -DSize, DSize ), ParticleSize + Rnd( -DSize, DSize ) )
				Sprite.DX = ( DX + Rnd( -DShift, DShift ) ) * ExplosionK
				Sprite.DY = ( DY + Rnd( -DShift, DShift ) ) * ExplosionK
				Sprite.AttachModel( New TMoveParticle )
				Sprite.Visualizer.Image = Profile.Balls.TileSet.Image
				Sprite.Frame = BallNum
				Game.Particles.AddLast( Sprite )
				Angle :+ 360.0 / ParticleDensity / Radius
			WEnd
		Next
	End Function
	
	Function ManageParticles( X:Int, Y:Int )
		TExplosion.CreateParticles( X, Y, Profile.Balls.GetTile( X, Y ) )
		TExplosion.ManageFields( X, Y )
	End Function	
End Type



Type TMoveParticle Extends LTBehaviorModel
	Const Gravity:Double = 12.0

	Method ApplyTo( Shape:LTShape )
		Local Particle:LTVectorSprite = LTVectorSprite( Shape )
		Particle.DY :+ Game.PerSecond( Gravity )
		Particle.MoveForward()
		If Particle.TopY() > GameCamera.BottomY() Then Game.Particles.Remove( Shape )
	End Method
End Type
