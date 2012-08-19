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
	Const RotatingSpeed:Double = 8.0 * 360.0
	Const ExplosionSpeed:Double = 0.1
	Const JumpStrength:Double = 8.0
	Const Size:Double = 0.4
	
	Function Fire()
		Local Fireball:TFireball = New TFireball
		Fireball.SetCoords( Mario.X + 0.5 * Mario.GetFacing(), Mario.Y )
		Fireball.SetSize( Size, Size )
		Fireball.DX = MovingSpeed * Mario.GetFacing()
		Fireball.Visualizer = LTVisualizer.FromImage( Game.Fireball )
		Fireball.ShapeType = LTSprite.Circle
		Fireball.AttachModel( New TGravity )
		Fireball.AttachModel( TVerticalMovement.Create( FireballCollidesWithObject, FireballCollidesWithFloor ) )
		Fireball.AttachModel( THorizontalMovement.Create( FireballCollidesWithObject, FireballCollidesWithWall ) )
		Fireball.AttachModel( New TFlying )
		Game.Firing.Play()
		Game.Level.AddLast( Fireball )
	End Function
End Type



Global FireballCollidesWithFloor:TFireballCollidesWithFloor = New TFireballCollidesWithFloor
Type TFireballCollidesWithFloor Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
		If VectorSprite.DY >= 0.0 Then
			VectorSprite.DY = -TFireball.JumpStrength
		Else
			VectorSprite.DY = 0.0
		End If
	End Method
End Type



Global FireballCollidesWithWall:TFireballCollidesWithWall = New TFireballCollidesWithWall
Type TFireballCollidesWithWall Extends LTSpriteAndTileCollisionHandler
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionSprite:LTSprite )
		Sprite.PushFromTile( TileMap, TileX, TileY )
		Sprite.AttachModel( New TExploding )
	End Method
End Type



Global FireballCollidesWithObject:TFireballCollidesWithObject = New TFireballCollidesWithObject
Type TFireballCollidesWithObject Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		If TEnemy( Sprite2 ) Then
			Sprite1.AttachModel( New TExploding )
			Sprite2.AttachModel( New TKicked )
		End If
	End Method
End Type



Type TFlying Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).DisplayingAngle :+ Game.PerSecond( TFireball.RotatingSpeed )
	End Method
End Type



Type TExploding Extends LTAnimationModel
	Method Init( Shape:LTShape )
		Shape.SetSize( 1.0, 1.0 )
		Shape.Visualizer = Game.Explosion
		Game.Bump.Play()
		Shape.DeactivateAllModels()
		FramesQuantity = 3
		Speed = TFireball.ExplosionSpeed
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Game.Level.Remove( Shape )
	End Method
End Type