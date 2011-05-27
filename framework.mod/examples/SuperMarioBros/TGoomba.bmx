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
	Const Stomped:Int = 2
	
	Field StompStartingTime:Float
	
	
	
	Method Act()
		If Mode = Stomped Then
			If Game.Time > StompStartingTime + TStomped.FlatPeriod Then Game.MainLayer.Remove( Self )
		Else
			Super.Act()
		End If
	End Method

	
	
	Method Push()
		Game.Mario.Damage()
	End Method
	
	
	
	Method Stomp()
		Frame = 2
		Mode = Stomped
		StompStartingTime = Game.Time
		Game.MovingObjects.RemoveSprite( Self )
	End Method
End Type



Type TStomped Extends LTBehaviorModel
	Field StartingTime:Float
	
	Const FlatPeriod:Float = 1.0

	
	
	Method Init( Sprite:LTSprite )
		StartingTime = Game.Time
		Sprite.Frame = 2
		Sprite.DeactivateModel( "Gravity" )
		Sprite.DeactivateModel( "Moving" )
	End Method
	
	
	
	Method ApplyTo( Sprite:LTSprite )
		If Game.Time > StartingTime + FlatPeriod Then Game.MainLayer.Remove( Sprite )
	End Method
End Type