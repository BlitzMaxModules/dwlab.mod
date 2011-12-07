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
bbdoc: Vector sprite has horizontal and vertical velocities forming velocity vector.
about: Handy for projects with gravity, platformers for example.

See also: #LTSprite
End Rem
Type LTVectorSprite Extends LTSprite
	Rem
	bbdoc: Horizontal velocity of the sprite.
	End Rem
	Field DX:Double
	
	Rem
	bbdoc: Vertical velocity of the sprite.
	End Rem
	Field DY:Double
	
	
	
	Function FromShapeAndVector:LTVectorSprite( X:Double, Y:Double, Width:Double = 1.0, Height:Double = 1.0, ShapeType:Int = LTSprite.Rectangle, DX:Double = 0.0, DY:Double = 0.0 )
		Local Sprite:LTVectorSprite = New LTVectorSprite
		Sprite.SetCoords( X, Y )
		Sprite.SetSize( Width, Height )
		Sprite.ShapeType = ShapeType
		Sprite.DX = DY
		Sprite.DX = DY
		Return Sprite
	End Function
	
	
	
	Method GetClassTitle:String()
		Return "Vector sprite"
	End Method
	
	
	
	Method Init()	
		UpdateFromAngularModel()
	End Method
	
	
	
	Method BounceInside( Shape:LTShape, LeftSide:Int = True, TopSide:Int = True, RightSide:Int = True, BottomSide:Int = True )
		If LeftSide Then
			If LeftX() < Shape.LeftX() Then
				X = Shape.LeftX() + 0.5 * Width
				DX = Abs( DX )
			End If
		End If
		If TopSide Then
			If TopY() < Shape.TopY() Then
				Y = Shape.TopY() + 0.5 * Height
				DY = Abs( DY )
			End If
		End If
		If RightSide Then
			If RightX() > Shape.RightX() Then
				X = Shape.RightX() - 0.5 * Width
				DX = -Abs( DX )
			End If
		End If
		If BottomSide Then
			If BottomY() > Shape.BottomY() Then
				Y = Shape.BottomY() - 0.5 * Height
				DY = -Abs( DY )
			End If
		End If
	End Method

	
	
	Method UpdateFromAngularModel()
		DX = Cos( Angle ) * Velocity
		DY = Sin( Angle ) * Velocity
	End Method
	
	
	
	Method UpdateAngularModel()
		Angle = ATan2( DY, DX )
		Velocity = L_Distance( DX, DY )
	End Method

	
	
	Method MoveForward()
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
End Type