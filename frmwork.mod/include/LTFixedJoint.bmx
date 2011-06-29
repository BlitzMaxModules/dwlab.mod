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
bbdoc: Fixed joint moves and rotates angular sprite as parent angular sprite moves or rotates.
about: See also: #LTRevoluteJoint
End Rem
Type LTFixedJoint Extends LTBehaviorModel
	Field ParentPivot:LTAngularSprite
	Field Angle:Double
	Field Distance:Double
	Field DAngle:Double
	
	
	
	Rem
	bbdoc: Creates fixed joint for specified parent pivot using current pivots position.
	returns: New fixed joint
	End Rem
	Function Create:LTFixedJoint( ParentPivot:LTAngularSprite )
		Local Joint:LTFixedJoint = New LTFixedJoint
		Joint.ParentPivot = ParentPivot
		Return Joint
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTAngularSprite = LTAngularSprite( Shape )
		Angle = ParentPivot.DirectionTo( Sprite ) - ParentPivot.Angle
		Distance = ParentPivot.DistanceTo( Sprite )
		DAngle = Sprite.Angle - ParentPivot.Angle
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTAngularSprite = LTAngularSprite( Shape )
		Sprite.X = ParentPivot.X + Cos( Angle + ParentPivot.Angle ) * Distance
		Sprite.Y = ParentPivot.Y + Sin( Angle + ParentPivot.Angle ) * Distance
		Sprite.Angle = ParentPivot.Angle + DAngle
	End Method
End Type