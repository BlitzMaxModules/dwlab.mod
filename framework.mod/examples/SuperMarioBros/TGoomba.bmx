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
	Method Init()
		AttachModel( New TCollisionsWithAll )
		AttachModel( New TGravity )
		AttachModel( New TMovingAnimation )
		AttachModel( New TRemoveIfOutside )
		Game.MovingObjects.InsertSprite( Self )
	End Method

	
	
	Method Push()
		Game.Mario.Damage()
	End Method
	
	
	
	Method Stomp()
		AttachModel( New TStomped )
	End Method
End Type



Type TStomped Extends LTBehaviorModel
	Field StartingTime:Float
	
	Const FlatPeriod:Float = 1.0

	
	
	Method Init( Sprite:LTSprite )
		StartingTime = Game.Time
		Sprite.Frame = 2
		Sprite.DeactivateModel( "TGravity" )
		Sprite.DeactivateModel( "TCollisionsWithAll" )
		Sprite.DeactivateModel( "TMovingAnimation" )
		Game.MovingObjects.RemoveSprite( Sprite )
	End Method
	
	
	
	Method ApplyTo( Sprite:LTSprite )
		If Game.Time > StartingTime + FlatPeriod Then Game.MainLayer.Remove( Sprite )
	End Method
End Type



Type TKicked Extends LTBehaviorModel
	Const KickStrength:Float = -6.0
	
	
	
	Method Init( Sprite:LTSprite )
		LTVectorSprite( Sprite ).DY = KickStrength
		Sprite.DeactivateModel( "TCollisionsWithAll" )
		Sprite.Visualizer.YScale :* -1.0
		PlaySound( Game.Kick )
		TScore.FromSprite( Sprite, TScore.s100 )
		Game.MovingObjects.RemoveSprite( Sprite )
	End Method
End Type