'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRevoluteJoint Extends LTBehaviorModel
	Field ParentPivot:LTAngularSprite
	Field Pivot:LTSprite
	Field Angle:Double
	Field Distance:Double
	
	
	
	Function Create:LTRevoluteJoint( ParentPivot:LTAngularSprite )
		Local Joint:LTRevoluteJoint = New LTRevoluteJoint
		Joint.ParentPivot = ParentPivot
		Return Joint
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTAngularSprite = LTAngularSprite( Shape )
		Angle = ParentPivot.DirectionTo( Sprite ) - ParentPivot.Angle
		Distance = ParentPivot.DistanceTo( Sprite )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTAngularSprite = LTAngularSprite( Shape )
		Sprite.X = ParentPivot.X + Cos( Angle + ParentPivot.Angle ) * Distance
		Sprite.Y = ParentPivot.Y + Sin( Angle + ParentPivot.Angle ) * Distance
	End Method
End Type