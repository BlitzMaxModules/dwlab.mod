'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTFixedJoint Extends LTJoint
	Field ParentPivot:LTAngularSprite
	Field Pivot:LTAngularSprite
	Field Angle:Double
	Field Distance:Double
	Field DAngle:Double
	
	
	
	Function Create:LTFixedJoint( ParentPivot:LTAngularSprite, Pivot:LTAngularSprite )
		Local Joint:LTFixedJoint = New LTFixedJoint
		Joint.ParentPivot = ParentPivot
		Joint.Pivot = Pivot
		Joint.Angle = ParentPivot.DirectionTo( Pivot ) - ParentPivot.Angle
		Joint.Distance = ParentPivot.DistanceTo( Pivot )
		Joint.DAngle = Pivot.Angle - ParentPivot.Angle
		L_JointList.AddLast( Joint )
		Return Joint
	End Function
	
	
	
	Method Operate()
		Pivot.X = ParentPivot.X + Cos( Angle + ParentPivot.Angle ) * Distance
		Pivot.Y = ParentPivot.Y + Sin( Angle + ParentPivot.Angle ) * Distance
		Pivot.Angle = ParentPivot.Angle + DAngle
	End Method
End Type