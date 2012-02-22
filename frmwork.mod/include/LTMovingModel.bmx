'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMovingModel Extends LTChainedModel
	Field X:Double, Y:Double
	
	
	
	Function Create:LTMovingModel( X:Double, Y:Double )
		Local Model:LTMovingModel = New LTMovingModel
		Model.X = X
		Model.Y = Y
		Return Model
	End Function
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).MoveTowardsPoint( X, Y, LTSprite( Shape ).Velocity )
		If Shape.IsAtPositionOfPoint( X, Y ) Then Remove( Shape )
	End Method
End Type