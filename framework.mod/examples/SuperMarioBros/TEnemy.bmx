'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TTrigger.bmx"
Include "TGoomba.bmx"
Include "TKoopaTroopa.bmx"

Type TEnemy Extends TMovingObject
	Field Mode:Int = Normal
	
	Const Normal:Int = 0
	Const Falling:Int = 1
	
	Const KickStrength:Float = -6.0
	
	
	
	Method Act()
		If Not Active Then Return
		If Mode = Falling Then
			Move( DX, DY )
			RemoveIfOutside()
		Else
			If Mode = Normal Then Animate( Game, 0.3, 2 )
			Super.Act()
		End If
		DY :+ L_DeltaTime * Game.Gravity
	End Method
	
	
	
	Method Stomp()
	End Method
	
	
	
	Method Push()
	End Method
	
	
	
	Method Kick()
		DY = KickStrength
		Visualizer.YScale = -Visualizer.YScale
		Mode = Falling
		PlaySound( Game.Kick )
		TScore.FromSprite( Self, TScore.s100 )
		Game.MovingObjects.RemoveSprite( Self )
	End Method
End Type