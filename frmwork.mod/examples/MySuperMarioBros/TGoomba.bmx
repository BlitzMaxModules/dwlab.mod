'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGoomba Extends LTVectorSprite
	Const WalkingAnimationSpeed:Float = 0.3
	
	Const Stomped:Int = 2
	
	
	
	Method Init()
		Game.MovingObjects.InsertSprite( Self )
		AttachModel( New TEnemyWalkingAnimation )
		AttachModel( New TCollisions )
		AttachModel( New TGravity )
		AttachModel( New TRemoveIfOutside )
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = Vertical Then
			DY = 0
		Else
			DX = -DX
		End If
	End Method
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		PushFromSprite( Sprite )
		If CollisionType = Vertical Then
			DY = 0
		Else
			DX = -DX
		End If
	End Method
End Type





Type TEnemyWalkingAnimation Extends LTBehaviorModel
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Animate( Game, TGoomba.WalkingAnimationSpeed, 2 )
	End Method
End Type





Type TStomped Extends LTBehaviorModel
	Const FlatPeriod:Float = 1.0
	
	Field StartingTime:Float

	

	Method Activate( Shape:LTShape )
		Local Goomba:TGoomba = TGoomba( Shape )
		Goomba.DeactivateAllModels()
		Goomba.Frame = TGoomba.Stomped
		Game.MovingObjects.RemoveSprite( Goomba )
		
		Game.Stomp.Play()
		
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > StartingTime + FlatPeriod Then Game.Level.Remove( Shape )
	End Method
End Type