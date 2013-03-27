'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
	
Include "LTCamera.bmx"

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
	
	
	
	Function FromShapeAndVector:LTVectorSprite( X:Double, Y:Double, Width:Double = 1.0, Height:Double = 1.0, ..
			ShapeType:LTShapeType = Null, DX:Double = 0.0, DY:Double = 0.0 )
		If ShapeType = Null Then ShapeType = LTSprite.Rectangle
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
	
	' ==================== Limiting ====================
	
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
	
	
	
	Method DirectTo( Shape:LTShape )
		Local VectorLength:Double = L_Distance( DX, DY )
		DX = Shape.X - X
		DY = Shape.Y - Y
		If VectorLength Then
			Local NewVectorLength:Double = L_Distance( DX, DY )
			If NewVectorLength Then
				DX :* VectorLength / NewVectorLength
				DY :* VectorLength / NewVectorLength
			End If
		End If
	End Method
	
	
	
	Method ReverseDirection()
		DX = -DX
		DY = -DY
	End Method
	
	
	
	Method Clone:LTShape()
		Local NewSprite:LTVectorSprite = New LTVectorSprite
		CopySpriteTo( NewSprite )
		Return NewSprite
	End Method
End Type



Type LTHorizontalMovementModel Extends LTBehaviorModel
	Global Instance:LTHorizontalMovementModel = New LTHorizontalMovementModel

	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( Sprite.DX, 0.0 )
	End Method
End Type



Type LTVerticalMovementModel Extends LTBehaviorModel
	Global Instance:LTVerticalMovementModel = New LTVerticalMovementModel

	Method ApplyTo( Shape:LTShape )
		Local Sprite:LTVectorSprite = LTVectorSprite( Shape )
		Sprite.Move( 0.0, Sprite.DY )
	End Method
End Type