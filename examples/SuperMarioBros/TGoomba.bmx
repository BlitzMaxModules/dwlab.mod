'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGoomba Extends TEnemy
	Const WalkingAnimationSpeed:Double = 0.3
	
	Const Stomped:Int = 2
	
	
	
	Method Init()
		AttachModel( New LTAnimationModel.Create( True, WalkingAnimationSpeed, 2 ) )
		AttachModel( New TGravity )
		AttachModel( New THorizontalMovement.Create( BumpingSprites, BumpingWalls ) )
		AttachModel( New TVerticalMovement.Create( PushFromSprites, PushFromFloor ) )
		AttachModel( New TRemoveIfOutside )
		Super.Init()
	End Method
	
	
	
	Method Stomp()
		AttachModel( New TStomped )
	End Method
End Type




Type TStomped Extends LTBehaviorModel
	Const FlatPeriod:Double = 1.0
	
	Field StartingTime:Double

	

	Method Activate( Shape:LTShape )
		Local Goomba:TGoomba = TGoomba( Shape )
		Goomba.DeactivateAllModels()
		Goomba.Frame = TGoomba.Stomped
		Game.MovingObjects.RemoveSprite( Goomba )
		Game.Level.AddLast( Goomba )
		
		Game.Stomp.Play()
		
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > StartingTime + FlatPeriod Then Game.Level.Remove( Shape )
	End Method
End Type





Type TKicked Extends LTBehaviorModel
	Const Strength:Double = -6.0
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Active = True
		Sprite.DY = Strength
		Sprite.DeactivateModel( "THorizontalMovement" )
		Sprite.DeactivateModel( "TVerticalMovement" )
		Sprite.DeactivateModel( "LTAnimationModel" )
		Sprite.AttachModel( New TMovement )
		Sprite.Visualizer.YScale :* -1.0
		PlaySound( Game.Kick )
		TScore.FromSprite( Sprite, TScore.s100 )
		Game.MovingObjects.RemoveSprite( Sprite )
		Game.Level.AddLast( Sprite )
	End Method
End Type