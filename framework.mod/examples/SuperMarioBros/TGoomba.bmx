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
		If Mode = Stomped And Game.Time > StompStartingTime + FlatPeriod Then Game.MainLayer.Remove( Self )
		Super.Act()
	End Method

	
	
	Method Stomp()
		Frame = 2
		Mode = Stomped
		StompStartingTime = Game.Time
		Game.Mario.DY = Game.Mario.HopStrength
		PlaySound( Game.Stomp )
		Game.MovingObjects.RemoveSprite( Self )
	End Method
End Type