'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TExplosion.bmx"

Type TChaingunBullet Extends LTVectorSprite
	Const MinFlyingTime:Double = 1.0
	Const MaxFlyingTime:Double = 2.0
	Const MinFadingTime:Double = 0.5
	Const MaxFadingTime:Double = 1.0
	Const Velocity:Double = 8.0
	Const Power:Double = 0.2
	
	Field CreatingTime:Int
	Field FadingPeriod:Double
	Field FlyingPeriod:Double
	
	
  
	Function Create( Fire:LTSprite )
		Local Bullet:TChaingunBullet = New TChaingunBullet
		Local BulletVisualizer:LTVisualizer = New LTVisualizer
		Bullet.Visualizer = BulletVisualizer
		BulletVisualizer.Image = Game.ChaingunBullet
		BulletVisualizer.SetVisualizerScale( 5.0, 5.0 )
		BulletVisualizer.Angle = Fire.Angle
		Bullet.SetDiameter( Rnd( 0.1, 0.25 ) )
		Bullet.DX = Cos( Game.Player.Angle ) * Game.Player.Velocity + Cos( Fire.Angle ) * Velocity
		Bullet.DY = Sin( Game.Player.Angle ) * Game.Player.Velocity + Sin( Fire.Angle ) * Velocity
		Bullet.CreatingTime = Game.Time
		Bullet.FlyingPeriod = Rnd( MinFlyingTime, MaxFlyingTime )
		Bullet.FadingPeriod = Rnd( MinFadingTime, MaxFadingTime )
		Bullet.JumpTo( Fire )
		Bullet.ShapeType = LTSprite.Circle
		Game.Bullets.InsertSprite( Bullet )
		Game.BulletLayer.AddLast( Bullet )
	End Function
	
	
	
	Method Act()
		MoveForward()
		Frame = L_WrapInt2( Floor( 10.0 + 50.0 * ( Game.Time - CreatingTime ) ), 27, 87 )
		If Game.Time > CreatingTime + FlyingPeriod + FadingPeriod Then
			Destroy()
		ElseIf Game.Time > CreatingTime + FlyingPeriod
			Visualizer.Alpha = 1.0 * ( CreatingTime + FlyingPeriod + FadingPeriod - Game.Time ) / FadingPeriod
		End If
		CollisionsWithSpriteMap( Game.Blocks, BulletCollisionWithBlock )
		CollisionsWithSpriteMap( Game.Trees, BulletCollisionWithTree )
	End Method
	
	
	
	Method Destroy()
		Game.BulletLayer.Remove( Self )
		Game.Bullets.RemoveSprite( Self )
	End Method
End Type



Global BulletCollisionWithBlock:TBulletCollisionWithBlock = New TBulletCollisionWithBlock
Type TBulletCollisionWithBlock Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local Bullet:TChaingunBullet = TChaingunBullet( Sprite1 )
		Local Block:TBlock = TBlock( Sprite2 )
		Block.DX :+ Bullet.DX * Bullet.Power / Block.Width / Block.Height
		Block.DY :+ Bullet.DY * Bullet.Power / Block.Width / Block.Height
		Game.ActingMap.Insert( Block, Null )
		BulletCollisionWithTree.HandleCollision( Sprite1, Sprite2 )
	End Method
End Type




Global BulletCollisionWithTree:TBulletCollisionWithTree = New TBulletCollisionWithTree
Type TBulletCollisionWithTree Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local Explosion:TExplosion = New TExplosion
		Explosion.JumpTo( Sprite1 )
		Explosion.Init()
		Sprite1.Destroy()
	End Method
End Type