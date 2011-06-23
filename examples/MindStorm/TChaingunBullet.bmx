'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TChaingunBullet Extends LTAngularSprite
	Const MinFlyingTime:Double = 1.0
	Const MaxFlyingTime:Double = 2.0
	Const MinFadingTime:Double = 0.5
	Const MaxFadingTime:Double = 1.0
	
	Field CreatingTime:Int
	Field FadingPeriod:Double
	Field FlyingPeriod:Double
  
	
  
	Function Create( Fire:LTAngularSprite )
        Local Bullet:TChaingunBullet = New TChaingunBullet
        Local BulletVisualizer:LTImageVisualizer = New LTImageVisualizer
        Bullet.Visualizer = BulletVisualizer
        BulletVisualizer.Image = Game.ChaingunBullet
        BulletVisualizer.SetVisualizerScale( 5.0, 5.0 )
        Bullet.SetDiameter( Rnd( 0.1, 0.25 ) )
        Bullet.Velocity = 7.0
        Bullet.CreatingTime = Game.Time
        Bullet.FlyingPeriod = Rnd( MinFlyingTime, MaxFlyingTime )
        Bullet.FadingPeriod = Rnd( MinFadingTime, MaxFadingTime )
        Bullet.JumpTo( Fire )
        Bullet.DirectAs( Fire )
        Bullet.ShapeType = LTSprite.Circle
        Game.Level.AddLast( Bullet )
	End Function
	
	
	
	Method Act()
	    MoveForward()
	    Frame = L_WrapInt2( Floor( 10.0 + 50.0 * ( Game.Time - CreatingTime ) ), 27, 87 )
	    If Game.Time > CreatingTime + FlyingPeriod + FadingPeriod Then
			Game.Level.Remove( Self )
		ElseIf Game.Time > CreatingTime + FlyingPeriod
	    	Visualizer.Alpha = 1.0 * ( CreatingTime + FlyingPeriod + FadingPeriod - Game.Time ) / FadingPeriod
	    End If
	End Method
End Type