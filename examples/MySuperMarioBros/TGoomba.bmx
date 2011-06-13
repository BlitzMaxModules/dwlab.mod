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
		AttachModel( New TBumpingTiles )
		AttachModel( New TBumpingSprites )
		AttachModel( New TRemoveIfOutside )
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





Type TKicked Extends LTBehaviorModel
	Const Strength:Float = -6.0
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.DY = Strength
		TCollisions( Sprite.FindModel( "TCollisions" ) ).SetCollisions( False, False )
		Sprite.DeactivateModel( "TEnemyWalkingAnimation" )
		Sprite.Visualizer.YScale :* -1.0
		PlaySound( Game.Kick )
		TScore.FromSprite( Sprite, TScore.s100 )
		Game.MovingObjects.RemoveSprite( Sprite )
	End Method
End Type