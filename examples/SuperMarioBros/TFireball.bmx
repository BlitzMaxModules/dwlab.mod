'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TFireball Extends LTVectorSprite
	Const MovingSpeed:Double = 10.0
	Const Size:Double = 0.4
	
	
	
	Function Fire()
		Local Fireball:TFireball = New TFireball
		Fireball.SetCoords( Game.Mario.X + 0.5 * Game.Mario.GetFacing(), Game.Mario.Y )
		Fireball.SetSize( Size, Size )
		Fireball.DX = MovingSpeed * Game.Mario.GetFacing()
		Fireball.Visualizer = LTImageVisualizer.FromImage( Game.Fireball )
		Fireball.ShapeType = LTSprite.Circle
		Fireball.AttachModel( New TCollisions )
		Fireball.AttachModel( New TGravity )
		Fireball.AttachModel( New TFlying )
		Game.Firing.Play()
		Game.Level.AddLast( Fireball )
	End Function
End Type





Type TFlying Extends LTBehaviorModel
	Const RotatingSpeed:Double = 8.0 * 360.0
	Const JumpStrength:Double = 8.0
	
	
	
	Method HandleCollisionWithSprite( Sprite1:LTSprite, Sprite2:LTSprite, CollisionType:Int )
		If TEnemy( Sprite2 ) Then
			Sprite1.AttachModel( New TExploding )
			Sprite2.AttachModel( New TKicked )
		End If
	End Method
	
	
	
	Method HandleCollisionWithTile( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
		If CollisionType = LTSprite.Vertical Then
			If VectorSprite.DY >= 0.0 Then
				VectorSprite.DY = -JumpStrength
			Else
				VectorSprite.DY = 0.0
			End If
		Else
			VectorSprite.AttachModel( New TExploding )
		End If
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visualizer.Angle :+ Game.PerSecond( RotatingSpeed )
	End Method
End Type





Type TExploding Extends LTBehaviorModel
	Const ExplosionSpeed:Double = 0.1
	
	Field StartingTime:Double
	
	

	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
		Shape.SetSize( 1.0, 1.0 )
		Shape.Visualizer = Game.Explosion
		Game.Bump.Play()
		Shape.DeactivateAllModels()
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > StartingTime + 3.0 * ExplosionSpeed Then Remove( Shape )
		LTSprite( Shape ).Frame = ( Game.Time - StartingTime ) / ExplosionSpeed
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Game.Level.Remove( Shape )
	End Method
End Type