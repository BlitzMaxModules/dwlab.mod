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
	Field ParentPivot:LTActor
	Field Pivot:LTActor
	Field Angle:Float
	Field Distance:Float
	
	
	
	Function Create:LTRevoluteJoint( ParentPivot:LTActor, Pivot:LTActor )
		Local Joint:LTRevoluteJoint = New LTRevoluteJoint
		Joint.ParentPivot = ParentPivot
		Joint.Pivot = Pivot
		Joint.Angle = ParentPivot.DirectionToActor( Pivot ) - ParentPivot.Model.GetAngle()
		Joint.Distance = ParentPivot.DistanceToActor( Pivot )
		L_JointList.AddLast( Joint )
		Return Joint
	End Function
	
	
	
	Method Operate()
		Pivot.X = ParentPivot.X + Cos( Angle + ParentPivot.Model.GetAngle() ) * Distance
		Pivot.Y = ParentPivot.Y + Sin( Angle + ParentPivot.Model.GetAngle() ) * Distance
	End Method
End Type