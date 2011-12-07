'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Distance joint keeps fixed distance between parent pivot and given shape.
End Rem
Type LTDistanceJoint Extends LTBehaviorModel
	Field ParentPivot:LTSprite
	Field Distance:Double
	Field FixedAngle:Int = True
	
	
	
	Rem
	bbdoc: Creates distance joint for specified parent pivot using current pivots position.
	returns: 
	about: 
	End Rem
	Function Create:LTDistanceJoint( ParentPivot:LTSprite, FixedAngle:Int = True )
		Local Joint:LTDistanceJoint = New LTDistanceJoint
		Joint.ParentPivot = ParentPivot
		Joint.FixedAngle = FixedAngle
		Return Joint
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Distance = ParentPivot.DistanceTo( Shape )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local NewDistance:Double = ParentPivot.DistanceTo( Shape )
		If NewDistance = 0 Then
			Shape.SetCoords( ParentPivot.X + Distance, ParentPivot.Y )
		Else
			Local K:Double = Distance / NewDistance
			Local VectorSprite:LTVectorSprite = LTVectorSprite( Shape )
			If VectorSprite And FixedAngle Then
				Local DDistance:Double = NewDistance - Distance
				VectorSprite.DX :+ ( ParentPivot.X - Shape.X ) * DDistance
				VectorSprite.DY :+ ( ParentPivot.Y - Shape.Y ) * DDistance
				VectorSprite.UpdateAngularModel()
			End If
			Shape.SetCoords( ParentPivot.X + ( Shape.X - ParentPivot.X ) * K, ParentPivot.Y + ( Shape.Y - ParentPivot.Y ) * K )
		End If
	End Method
End Type