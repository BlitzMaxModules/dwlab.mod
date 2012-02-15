'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TExplosion
	Const MaxRadius:Int = 3
	Const CircleWidth:Double = 0.12
	Const ParticleSize:Double = 0.18
	Const DSize:Double = 0.05
	Const ParticleDensity:Double = 6.0
	Const Shift:Double = 0.03
	Const DShift:Double = 0.1
	Const ExplosionK:Double = 18.0
	
	Function Create( X:Int, Y:Int )
		Local BallNum:Int = Profile.Balls.GetTile( X, Y )
		If BallNum = 0 Then Return
		For Local Radius:Double = 1 To MaxRadius
			Local Angle:Double = 0
			While Angle < 360.0
				Local Sprite:LTVectorSprite = New LTVectorSprite
				Local DX:Double = Radius * CircleWidth * Cos( Angle )
				Local DY:Double = Radius * CircleWidth * Sin( Angle )
				Sprite.PositionOnTilemap( Profile.Balls, DX + X + Rnd( -Shift, Shift ), DY + Y + Rnd( -Shift, Shift ) )
				Sprite.SetSize( ParticleSize + Rnd( -DSize, DSize ), 2.0 * ( ParticleSize + Rnd( -DSize, DSize ) ) )
				Sprite.DX = ( DX + Rnd( -DShift, DShift ) ) * ExplosionK
				Sprite.DY = ( DY + Rnd( -DShift, DShift ) ) * ExplosionK
				Sprite.AttachModel( New TMoveParticle )
				Sprite.Visualizer.Image = Profile.Balls.TileSet.Image
				Sprite.Frame = BallNum
				Game.Particles.AddLast( Sprite )
				Angle :+ 360.0 / ParticleDensity / Radius
			WEnd
		Next
		Profile.Balls.SetTile( X, Y, Profile.NoBall )
		Local TileNum:Int = Profile.GameField.GetTile( X, Y )
		Select TileNum
			Case Profile.Glue, Profile.ColdGlue
		 		Profile.GameField.SetTile( X, Y, TileNum - 1 )
		End Select
		Game.TotalBalls :+ 1
		For Local Goal:TRemoveBalls = Eachin Profile.Goals
			If ( Goal.BallType = TileNum Or Goal.BallType = Profile.RandomBall ) Then Goal.Count :- 1
		Next
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
