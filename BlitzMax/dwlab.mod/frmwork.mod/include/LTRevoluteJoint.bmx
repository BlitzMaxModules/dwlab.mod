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
	Field DX:Double, DY:Double
	
	
	
	Rem
	bbdoc: Creates revolute joint for specified parent pivot using current pivots position.
	returns: 
	about: 
	End Rem
	Function Create:LTRevoluteJoint( ParentPivot:LTSprite, DX:Double = 0, DY:Double = 0 )
		Local Joint:LTRevoluteJoint = New LTRevoluteJoint
		Joint.ParentPivot = ParentPivot
		Joint.DX = DX
		Joint.DY = DY
		Return Joint
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		Local Angle2:Double = ATan2( DY, DX )
		Local Distance2:Double = L_Distance( DX * Sprite.Width, DY * Sprite.Height )
		Local X:Double = Sprite.X + Cos( Angle2 + Sprite.Angle ) * Distance2
		Local Y:Double = Sprite.Y + Sin( Angle2 + Sprite.Angle ) * Distance2
		Angle = ParentPivot.DirectionToPoint( X, Y ) - ParentPivot.Angle
		Distance = ParentPivot.DistanceToPoint( X, Y )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTSprite = LTSprite( Shape )
		Local Angle2:Double = ATan2( DY, DX )
		Local Distance2:Double = L_Distance( DX * Sprite.Width, DY * Sprite.Height )
		Local DDX:Double = Cos( Angle2 + Sprite.Angle ) * Distance2
		Local DDY:Double = Sin( Angle2 + Sprite.Angle ) * Distance2
		Sprite.SetCoords( ParentPivot.X + Cos( Angle + ParentPivot.Angle ) * Distance - DDX, ParentPivot.Y + Sin( Angle + ParentPivot.Angle ) * Distance - DDY )
	End Method
End Type