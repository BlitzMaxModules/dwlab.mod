'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTimedMovementModel Extends LTTemporaryModel
	Field InitialX:Double, InitialY:Double
	Field DestinationX:Double, DestinationY:Double
	
	
	
	Function Create:LTTimedMovementModel( Time:Double, DestinationX:Double, DestinationY:Double )
		Local Model:LTTimedMovementModel = New LTTimedMovementModel
		Model.Period = Time
		Model.DestinationX = DestinationX
		Model.DestinationY = DestinationY
		Return Model
	End Function
	
	
	
	Method Init( Shape:LTShape )
		InitialX = Shape.X
		InitialY = Shape.Y
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local K:Double = ( L_CurrentProject.Time - StartingTime ) / Period
		Shape.SetCoords( InitialX + K * ( DestinationX - InitialX ), InitialY + K * ( DestinationY - InitialY ) )
		Super.ApplyTo( Shape )
	End Method
End Type