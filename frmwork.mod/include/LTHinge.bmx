'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTHinge Extends LTShape
	Field Sprite:LTSprite[] = New LTSprite[ 2 ]
	Field AngleToSprite:Double[] = New Double[ 2 ]
	Field DistanceToSprite:Double[] = New Double[ 2 ]
	Field SpriteAttachedAngle:Double[] = New Double[ 2 ]
	Field SpriteMovingResistance:Double[] = New Double[ 2 ]
	Field SpriteRotatingResistance:Double[] = New Double[ 2 ]
	Field Fixed:Int = False
	
	
	
	Function Create:LTHinge( Sprite1:LTSprite, Sprite2:LTSprite, X:Double, Y:Double, Fixed:Int = False, Sprite1AttachedAngle:Int = True, ..
			Sprite2AttachedAngle:Int = True, Sprite1MovingResistance:Double = 1.0, Sprite2MovingResistance:Double = 1.0, ..
			Sprite1RotatingResistance:Double = 1.0, Sprite2RotatingResistance:Double = 1.0 )
		Local Hinge:LTHinge = New LTHinge
		Hinge.X = X
		Hinge.Y = Y
		Hinge.Sprite[ 0 ] = Sprite1
		Hinge.Sprite[ 1 ] = Sprite2
		Hinge.AngleFromSprite[ 0 ] = Hinge.DirectionTo( Sprite1 )
		Hinge.AngleFromSprite[ 1 ] = Hinge.DirectionTo( Sprite2 )
		Hinge.DistanceFromSprite[ 0 ] = Hinge.DistanceTo( Sprite1 )
		Hinge.DistanceFromSprite[ 1 ] = Hinge.DistanceTo( Sprite2 )
		Return Hinge
	End Function
	
	
	
	Method Act()
		If Fixed Then
			Local Angle:Double = DirectionTo( Sprite[ 0 ] )
			Sprite[ 0 ].SetCoords( DistanceToSprite[ 0 ] * Cos( Angle ), DistanceToSprite[ 0 ] * Sin( Angle ) )
			Angle = DirectionTo( Sprite[ 1 ] )
			Sprite[ 1 ].SetCoords( DistanceToSprite[ 1 ] * Cos( Angle ), DistanceToSprite[ 1 ] * Sin( Angle ) )
		Else
			
		End If
	End Method
End Type



' X3 = X - X1
' Y3 = Y - Y1
' X4 = X2 - X1
' Y4 = Y2 - Y1
' X - X2 = X - X1 + X1 - X2 = X3 + X1 - X2 = X3 - X4
' Y - Y2 = Y3 - Y4
' X3 ^ 2 + Y3 ^ 2 = R1 ^ 2
' ( X3 - X4 ) ^ 2 + ( Y3 - Y4 ) ^ 2 = R2 ^ 2
' X3 ^ 2 - 2 * X3 * X4 + X4 ^ 2 + Y3 ^ 2 - 2 * Y3 * Y4 + Y4 ^ 2 = R2 ^ 2
' R1 ^ 2 - 2 * X3 * X4 + X4 ^ 2 - 2 * Y3 * Y4 + Y4 ^ 2 = R2 ^ 2
' R1 ^ 2 + X4 ^ 2 - 2 * Y3 * Y4 + Y4 ^ 2 - R2 ^ 2 = 2 * X3 * X4
' X3 = ( R1 ^ 2 + X4 ^ 2 - 2 * Y3 * Y4 + Y4 ^ 2 - R2 ^ 2 ) / 2 / X4
' ( R1 ^ 2 + X4 ^ 2 - 2 * Y3 * Y4 + Y4 ^ 2 - R2 ^ 2 ) ^ 2 / 4 / X4 ^ 2 + Y3 ^ 2 = R1 ^ 2
' ( ( R1 ^ 2 + X4 ^ 2 + Y4 ^ 2 - R2 ^ 2 )  - 2 * Y3 * Y4 ) ^ 2 + Y3 ^ 2 = R1 ^ 2
' R3 = ( R1 ^ 2 - R2 ^ 2 + X4 ^ 2 + Y4 ^ 2 )
' ( R3 - 2 * Y3 * Y4 ) ^ 2 + Y3 ^ 2 = R1 ^ 2
' R3 ^ 2 - 4 * R3 * Y3 * Y4 + 4 * Y3 ^ 2 * Y4 ^ 2 + Y3 ^ 2 = R1 ^ 2
' ( 4 * Y4 ^ 2 + 1 ) * Y3 ^ 2 + 2 * ( 2 * R3 * Y4 ) * Y3 + R3 ^ 2 - R1 ^ 2 = 0
' K = 2 * R3 * Y4
' A = 4 * Y4 ^ 2 + 1
' C = R3 ^ 2 - R1 ^ 2
' Y3 = ( -K +/- SQR( K - A * C ) ) / A
' X3 = +/-SQR( R1 ^ 2 - Y3 ^ 2 )