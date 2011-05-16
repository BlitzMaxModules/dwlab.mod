'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TFireball Extends TMovingObject
	Field Exploding:Int = False
	Field ExplosionStartingTime:Float

	Const HorizontalSpeed:Float = 10.0
	Const Size:Float = 0.4
	Const ExplosionSpeed:Float = 0.1
	Const JumpStrength:Float = -8.0
	Const RotatingSpeed:Float = 8.0 * 360.0
	
	

	Function Launch()
		Local Fireball:TFireball = New TFireball
		Fireball.X = Game.Mario.X + 0.5 * Game.Mario.Visualizer.XScale
		Fireball.Y = Game.Mario.Y
		Fireball.DX = HorizontalSpeed * Game.Mario.Visualizer.XScale
		Fireball.Width = Size
		Fireball.Height = Size
		Fireball.Visualizer = LTImageVisualizer.FromImage( Game.Fireball )
		Fireball.ShapeType = Rectangle
		Game.MainLayer.AddLast( Fireball )
	End Function
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If TEnemy( Sprite ) Then
			TEnemy( Sprite ).Kick()
			Explode()
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		If CollisionType = Vertical Then
			PushFromTile( TileMap, TileX, TileY )
			If DY <= 0.0 Then
				DY = 0.0
			Else
				DY = JumpStrength
			End If
		Else
			Explode()
		End If
	End Method
	
	
	
	Method Act()
		If Exploding Then
			Animate( Game, ExplosionSpeed )
			If ExplosionStartingTime + 3 * ExplosionSpeed < Game.Time Then Game.MainLayer.Remove( Self )
		Else
			Super.Act()
			DY :+ L_DeltaTime * Game.Gravity
			Visualizer.Angle :+ RotatingSpeed * L_DeltaTime
		End If
	End Method
	
	
	
	Method Explode()
		ExplosionStartingTime = Game.Time
		Exploding = True
		Width = 1.0
		Height = 1.0
		Visualizer = Game.Explosion
		PlaySound( Game.Bump )
	End Method
End Type