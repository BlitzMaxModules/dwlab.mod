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
bbdoc: Revolute joint moves angular sprite if parent pivot moves or rotates, but the sprite can be rotated freely.
about: See also: #LTFixedJoint
End Rem
Type LTRevoluteJoint Extends LTBehaviorModel
	Field ParentPivot:LTSprite
	Field Angle:Double
	Field Distance:Double
	
	
	
	Rem
	bbdoc: Creates revolute joint for specified parent pivot using current pivots position.
	returns: 
	about: 
	End Rem
	Function Create:LTRevoluteJoint( ParentPivot:LTSprite )
		Local Joint:LTRevoluteJoint = New LTRevoluteJoint
		Joint.ParentPivot = ParentPivot
		Return Joint
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		Angle = ParentPivot.DirectionTo( Sprite ) - ParentPivot.Angle
		Distance = ParentPivot.DistanceTo( Sprite )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		Sprite.SetCoords( ParentPivot.X + Cos( Angle + ParentPivot.Angle ) * Distance, ParentPivot.Y + Sin( Angle + ParentPivot.Angle ) * Distance )
	End Method
End Type