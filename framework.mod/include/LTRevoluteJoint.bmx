'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRevoluteJoint Extends LTJoint
	Field ParentPivot:LTPivot
	Field Pivot:LTPivot
	Field Angle1:Float
	Field Distance1:Float
	Field Angle2:Float
	Field Distance2:Float
	
	
	
	Function Create:LTRevoluteJoint( ParentPivot:LTPivot, Pivot:LTPivot, X:Float, Y:Float )
		Local Joint:LTRevoluteJoint = New LTRevoluteJoint
		Joint.ParentPivot = ParentPivot
		Joint.Pivot = Pivot
		Joint.Angle1 = ParentPivot.DirectionToPoint( X, Y ) - ParentPivot.Model.GetAngle()
		Joint.Distance1 = ParentPivot.DistanceToPoint( X, Y )
		Joint.Angle2 = Pivot.DirectionToPoint( X, Y ) - Pivot.Model.GetAngle()
		Joint.Distance2 = Pivot.DistanceToPoint( X, Y )
		L_AddJoint( Joint )
		Return Joint
	End Function
	
	
	
	Method Operate()
		Local X:Float = ParentPivot.X + Cos( Angle1 + ParentPivot.Model.GetAngle() ) * Distance1
		Local Y:Float = ParentPivot.Y + Sin( Angle1 + ParentPivot.Model.GetAngle() ) * Distance1
		Pivot.X = X - Cos( Angle2 + Pivot.Model.GetAngle() ) * Distance2
		Pivot.Y = Y - Sin( Angle2 + Pivot.Model.GetAngle() ) * Distance2
	End Method
End Type