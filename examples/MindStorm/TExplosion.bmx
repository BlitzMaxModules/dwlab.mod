'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TExplosion Extends LTAngularSprite
	Const MinSize:Double = 0.6
	Const MaxSize:Double = 1.0
	Const MinAnimationSpeed:Double = 0.01
	Const MaxAnimationSpeed:Double = 0.03
	
	
	Field AnimationSpeed:Double
	Field StartingTime:Double
	
	
	
	Method Init()
		StartingTime:Double = Game.Time
		AnimationSpeed = Rnd( MinAnimationSpeed, MaxAnimationSpeed )
		Angle = Rnd( 360.0 )
		SetDiameter( Rnd( MinSize, MaxSize ) )
		Visualizer = Game.Explosion
		Game.Bullets.InsertSprite( Self )
		Game.BulletLayer.AddLast( Self )
		Game.ExplosionSounds.Play( Game.ExplosionSound, 1.0, Rnd( 0.7, 1.3 ) )
	End Method
	
	
	
	Method Act()
		Animate( Game, AnimationSpeed, , , StartingTime )
		If Game.Time > StartingTime + AnimationSpeed * Visualizer.GetImage().FramesQuantity() Then
			Game.Bullets.RemoveSprite( Self )
			Game.BulletLayer.Remove( Self )
		End If
	End Method
End Type