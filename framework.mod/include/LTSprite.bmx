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
Include "LTTileMap.bmx"
Include "Collisions.bmx"
Include "Physics.bmx"

Const L_Pivot:Int = 0
Const L_Circle:Int = 1
Const L_Rectangle:Int = 2

Const L_Left:Int = 0
Const L_Right:Int = 1
Const L_Up:Int = 2
Const L_Down:Int = 3

Rem
bbdoc:Main shape for moving objects
about:
EndRem
Type LTSprite Extends LTShape
	Field Shape:Int = L_Rectangle
	Field X:Float
	Field Y:Float
	Field Width:Float = 1.0
	Field Height:Float = 1.0
	Field Angle:Float = 0.0
	Field Velocity:Float = 0.0
	Field Frame:Int
	Field CollisionMap:LTCollisionMap
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visualizer.DrawUsingSprite( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		Vis.DrawUsingSprite( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method GetCollisionType:Int( Obj:LTActiveObject )
		Local Sprite:LTSprite = LTSprite( Obj )
		If Sprite Then
			Local DX:Float = Sprite.X - X
			Local DY:Float = Sprite.Y - Y
			If Abs( DX ) > Abs( DY ) Then
				If DX < 0 Then Return L_Left Else Return L_Right
			Else	
				If DY < 0 Then Return L_Up Else Return L_Down
			End If
		End If
	End Method
	
	
	
	Method CollidesWith:Int( Obj:LTActiveObject )
		Return Obj.CollidesWithSprite( Self )
	End Method
	
	
	
	Method CollidesWithSprite:Int( Sprite:LTSprite )
		Select Shape
			Case L_Pivot
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithPivot( X, Y, Sprite.X, Sprite.Y )
					Case L_Circle
						Return L_PivotWithCircle( X, Y, Sprite.X, Sprite.Y, Sprite.Width )
					Case L_Rectangle
						Return L_PivotWithRectangle( X, Y, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				End Select
			Case L_Circle
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithCircle( Sprite.X, Sprite.Y, X, Y, Width )
					Case L_Circle
						Return L_CircleWithCircle( X, Y, Width, Sprite.X, Sprite.Y, Sprite.Width )
					Case L_Rectangle
						Return L_CircleWithRectangle( X, Y, Width, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				End Select
			Case L_Rectangle
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithRectangle( Sprite.X, Sprite.Y, X, Y, Width, Height )
					Case L_Circle
						Return L_CircleWithRectangle( Sprite.X, Sprite.Y, Sprite.Width, X, Y, Width, Height )
					Case L_Rectangle
						Return L_RectangleWithRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				End Select
		End Select
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
		Select Shape
			Case L_Pivot
				'Return L_PivotWithLine( Self, Line )
			Case L_Circle
				Return L_CircleWithLine( X, Y, Width, Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y )
			Case L_Rectangle
				'Return L_RectangleWithLine( Self, Line )
		End Select
	End Method
	
	
	
	Method CollidesWithTile:Int( Sprite:LTSprite, DX:Float, DY:Float, XScale:Float, YScale:Float )
		Select Shape
			Case L_Pivot
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithPivot( X, Y, Sprite.X * XScale + DX, Sprite.Y * YScale + DY )
					Case L_Circle
						Return L_PivotWithCircle( X, Y, Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale )
					Case L_Rectangle
						Return L_PivotWithRectangle( X, Y, Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale, Sprite.Height * YScale )
				End Select
			Case L_Circle
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithCircle( Sprite.X * XScale + DX, Sprite.Y * YScale + DY, X, Y, Width )
					Case L_Circle
						Return L_CircleWithCircle( X, Y, Width, Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale )
					Case L_Rectangle
						Return L_CircleWithRectangle( X, Y, Width, Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale, Sprite.Height * YScale )
				End Select
			Case L_Rectangle
				Select Sprite.Shape
					Case L_Pivot
						Return L_PivotWithRectangle( Sprite.X * XScale + DX, Sprite.Y * YScale + DY, X, Y, Width, Height )
					Case L_Circle
						Return L_CircleWithRectangle( Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale, X, Y, Width, Height )
					Case L_Rectangle
						Return L_RectangleWithRectangle( X, Y, Width, Height, Sprite.X * XScale + DX, Sprite.Y * YScale + DY, Sprite.Width * XScale, Sprite.Height * YScale )
				End Select
		End Select
	End Method
	
	
	
	Method OverlapsSprite:Int( Sprite:LTSprite )
		Select Shape
			Case L_Pivot
				L_Assert( false, " Pivot overlapping is not supported" )
			Case L_Circle
				Select Sprite.Shape
					Case L_Pivot
						Return L_CircleOverlapsCircle( X, Y, Width, Sprite.X, Sprite.Y, 0 )
					Case L_Circle
						Return L_CircleOverlapsCircle( X, Y, Width, Sprite.X, Sprite.Y, Sprite.Width )
					Case L_Rectangle
						Return L_RectangleOverlapsRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				End Select
			Case L_Rectangle
				Select Sprite.Shape
					Case L_Pivot
						Return L_RectangleOverlapsRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, 0, 0 )
					Case L_Circle
						Return L_RectangleOverlapsRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Width )
					Case L_Rectangle
						Return L_RectangleOverlapsRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height )
				End Select
		End Select
		
	End Method
	
	
	
	Method CollisionsWith( Obj:LTActiveObject )
		Obj.CollisionsWithSprite( Self )
	End Method
	
	
	
	Method CollisionsWithSprite( Sprite:LTSprite )
		If CollidesWithSprite( Sprite ) Then Sprite.HandleCollisionWith( Self, GetCollisionType( Sprite ) )
	End Method
	
	' ==================== Wedging off ====================
	
	Method WedgeOffWith( Obj:LTActiveObject, SelfMass:Float, ShapeMass:Float )
		Obj.WedgeOffWithSprite( Self, ShapeMass, SelfMass )
	End Method


	
	Method WedgeOffWithSprite( Sprite:LTSprite, SelfMass:Float, SpriteMass:Float )
		Local DX:Float, DY:Float
		Select Shape
			Case L_Pivot
				Select Sprite.Shape
					Case L_Pivot
						Return
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, 0, Sprite.X, Sprite.Y, Sprite.Width, DX, DY )
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, 0, 0, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height, DX, DY )
				End Select
			Case L_Circle
				Select Sprite.Shape
					Case L_Pivot
						L_WedgingValuesOfCircleAndCircle( X, Y, Width, Sprite.X, Sprite.Y, 0, DX, DY )
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, Width, Sprite.X, Sprite.Y, Sprite.Width, DX, DY )
					Case L_Rectangle
						L_WedgingValuesOfCircleAndRectangle( X, Y, Width, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height, DX, DY )
				End Select
			Case L_Rectangle
				Select Sprite.Shape
					Case L_Pivot
						L_WedgingValuesOfRectangleAndRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, 0, 0, DX, DY )
					Case L_Circle
						L_WedgingValuesOfCircleAndRectangle( Sprite.X, Sprite.Y, Sprite.Width, X, Y, Width, Height, DX, DY )
						L_Separate( Sprite, Self, DX, DY, SpriteMass, SelfMass )
						Return
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, Width, Height, Sprite.X, Sprite.Y, Sprite.Width, Sprite.Height, DX, DY )
				End Select
		End Select
		L_Separate( Self, Sprite, DX, DY, SelfMass, SpriteMass )
	End Method
	
	
	
	Method PushFromTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local TileSprite:LTSprite = TileMap.GetTileTemplate( TileX, TileY )
		If Not TileSprite Then Return
		
		Local CellWidth:Float = TileMap.GetCellWidth()
		Local CellHeight:Float = TileMap.GetCellHeight()
		PushFromTileSprite( TileSprite, TileMap.CornerX() + CellWidth * TileX, TileMap.CornerY() + CellHeight * TileY, CellWidth, CellHeight )
	End Method


	
	Method PushFromTileSprite( TileSprite:LTSprite, DX:Float, DY:Float, XScale:Float, YScale:Float )
		Local PushingDX:Float, PushingDY:Float
		Select Shape
			Case L_Pivot
				Select TileSprite.Shape
					Case L_Pivot
						Return
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, 0, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, PushingDX, PushingDY )
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, 0, 0, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, TileSprite.Height * YScale, PushingDX, PushingDY )
				End Select
			Case L_Circle
				Select TileSprite.Shape
					Case L_Pivot
						L_WedgingValuesOfCircleAndCircle( X, Y, Width, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, 0, PushingDX, PushingDY )
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, Width, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, PushingDX, PushingDY )
					Case L_Rectangle
						L_WedgingValuesOfCircleAndRectangle( X, Y, Width, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, TileSprite.Height * YScale, PushingDX, PushingDY )
				End Select
			Case L_Rectangle
				Select TileSprite.Shape
					Case L_Pivot
						L_WedgingValuesOfRectangleAndRectangle( X, Y, Width, Height, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, 0, 0, PushingDX, PushingDY )
					Case L_Circle
						L_WedgingValuesOfCircleAndRectangle( TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, X, Y, Width, Height, PushingDX, PushingDY )
						L_Separate( TileSprite, Self, PushingDX, PushingDY, 1.0, 0.0 )
						Return
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, Width, Height, TileSprite.X * XScale + DX, TileSprite.Y * YScale + DY, TileSprite.Width * XScale, TileSprite.Height * YScale, PushingDX, PushingDY )
				End Select
		End Select
		L_Separate( Self, TileSprite, PushingDX, PushingDY, 0.0, 1.0 )
	End Method


	' ==================== Position ====================
	
	Rem
	bbdoc:
	about:
	EndRem
	Method CornerX:Float()
 		Return X - 0.5 * Width
 	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method CornerY:Float()
 		Return Y - 0.5 * Height
 	End Method

	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DistanceToPoint:Float( PointX:Float, PointY:Float )
		Local DX:Float = X - PointX
		Local DY:Float = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DistanceToSprite:Float( Sprite:LTSprite )
		Local DX:Float = X - Sprite.X
		Local DY:Float = Y - Sprite.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method IsAtPositionOfSprite:Int( Sprite:LTSprite )
		If Sprite.X = X And Sprite.Y = Y Then Return True
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetCoords( NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X = NewX
		Y = NewY
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method AlterCoords( DX:Float, DY:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X :+ DX
		Y :+ DY
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetCornerCoords( NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X = NewX + Width * 0.5
		Y = NewY + Height * 0.5
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetCoordsRelativeToSprite( Sprite:LTSprite, NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Local Angle:Float = DirectionToPoint( NewX, NewY ) + Sprite.GetAngle()
		Local Radius:Float = Sqr( NewX * NewX + NewY * NewY )
		X = Sprite.X + Radius * Cos( Angle )
		Y = Sprite.Y + Radius * Sin( Angle )
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method JumpToSprite( Sprite:LTSprite )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X = Sprite.X
		Y = Sprite.Y
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetMouseCoords()
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method MoveTowardsSprite( Sprite:LTSprite )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Local Angle:Float = DirectionToSprite( Sprite )
		Local DX:Float = Cos( Angle ) * Velocity * L_DeltaTime
		Local DY:Float = Sin( Angle ) * Velocity * L_DeltaTime
		If Abs( DX ) >= Abs( X - Sprite.X ) And Abs( DY ) >= Abs( Y - Sprite.Y ) Then
			X = Sprite.X
			Y = Sprite.Y
		Else
			X :+ DX
			Y :+ DY
		End If
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method MoveForward()
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X :+ GetDX() * L_DeltaTime
		Y :+ GetDY() * L_DeltaTime
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method MoveUsingWSAD()
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Local DX:Float = KeyDown( Key_D ) - KeyDown( Key_A )
		Local DY:Float = KeyDown( Key_S ) - KeyDown( Key_W )
		If DX * DY Then
			DX :/ Sqr( 2 )
			DY :/ Sqr( 2 )
		End If
		X :+ DX * Velocity * L_DeltaTime
		Y :+ DY * Velocity * L_DeltaTime
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method PlaceBetweenSprites( Sprite1:LTSprite, Sprite2:LTSprite, K:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		X = Sprite1.X + ( Sprite2.X - Sprite1.X ) * K
		Y = Sprite1.Y + ( Sprite2.Y - Sprite1.Y ) * K
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	' ==================== Size ====================

	Rem
	bbdoc:
	about:
	EndRem
	Method SetSize( NewWidth:Float, NewHeight:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Width = NewWidth
		Height = NewHeight

		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetDiameter( NewDiameter:Float )
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Width = NewDiameter
		Height = NewDiameter
		
		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method CorrectHeight()
		Local ImageVisualizer:LTImageVisualizer = LTImageVisualizer( Visualizer )
		
		?debug
		L_Assert( ImageVisualizer <> Null, "Cannot correct Height: visual is not of LTImageVisual type" )
		?
		
		If CollisionMap Then CollisionMap.RemoveSprite( Self )
		
		Height = Width * ImageHeight( ImageVisualizer.Image.BMaxImage ) / ImageWidth( ImageVisualizer.Image.BMaxImage )

		Update()
		If CollisionMap Then CollisionMap.InsertSprite( Self )
	End Method
	
	' ==================== Angle ====================
	
	Rem
	bbdoc:
	about:
	EndRem
	Method GetAngle:Float()
		Return Angle
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetAngle:Float( NewAngle:Float )
		Angle = NewAngle
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DirectAsSprite( Sprite:LTSprite )
		Angle = Sprite.Angle
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method Turn( TurningSpeed:Float )
		Angle :+ L_DeltaTime * TurningSpeed
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DirectionToPoint:Float( PointX:Float, PointY:Float )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DirectionToSprite:Float( Sprite:LTSprite )
		Return ATan2( Sprite.Y - Y, Sprite.X - X )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method DirectToSprite( Sprite:LTSprite )
		Angle = ATan2( Sprite.Y - Y, Sprite.X - X )
	End Method
	
	' ==================== Moving vector ====================
	
	Rem
	bbdoc:
	about:
	EndRem
	Method GetDX:Float()
		Return Velocity * Cos( Angle )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method AlterDX( DDX:Float )
		SetDX( GetDX() + DDX )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetDX( NewDX:Float )
		Local DY:Float = GetDY()
		Angle = ATan2( DY, NewDX )
		Velocity = Sqr( NewDX * NewDX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method GetDY:Float()
		Return Velocity * Sin( Angle )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method AlterDY( DDY:Float )
		SetDY( GetDY() + DDY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetDY( NewDY:Float )
		Local DX:Float = GetDX()
		Angle = ATan2( NewDY, DX )
		Velocity = Sqr( DX * DX + NewDY * NewDY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method AlterDXDY( DDX:Float, DDY:Float )
		Local DX:Float = GetDX() + DDX
		Local DY:Float = GetDY() + DDY
		Angle = ATan2( DY, DX )
		Velocity = Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetDXDY( NewDX:Float, NewDY:Float )
		Angle = ATan2( NewDY, NewDX )
		Velocity = Sqr( NewDX * NewDX + NewDY * NewDY )
	End Method
	
	' ==================== Velocity ====================
	
	Rem
	bbdoc:
	about:
	EndRem
	Method GetVelocity:Float()
		Return Velocity
	End Method
	
	
	
	Rem
	bbdoc:
	about:
	EndRem
	Method SetVelocity:Float( NewVelocity:Float )
		Velocity = NewVelocity
	End Method
	
	' ==================== Other ====================
	
	Method Clone:LTActiveObject( Prefix:String, CollisionMap:LTCollisionMap )
		Local NewSprite:LTSprite = New LTSprite
		CopySpriteTo( NewSprite )
		NewSprite.SetName( Prefix + GetName() )
		If CollisionMap Then CollisionMap.InsertSprite( NewSprite )
		Return NewSprite
	End Method
	
	
	
	Method CopySpriteTo( Sprite:LTSprite )
		Sprite.Shape = Shape
		Sprite.X = X
		Sprite.Y = Y
		Sprite.Width = Width
		Sprite.Height = Height
		Sprite.Angle = Angle
		Sprite.Velocity = Velocity
		Sprite.Frame = Frame
		Sprite.Visualizer = Visualizer
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "shape", Shape )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
		XMLObject.ManageFloatAttribute( "width", Width, 1.0 )
		XMLObject.ManageFloatAttribute( "height", Height, 1.0 )
		XMLObject.ManageFloatAttribute( "angle", Angle )
		XMLObject.ManageFloatAttribute( "velocity", Velocity )
		XMLObject.ManageIntAttribute( "frame", Frame )
	End Method
End Type





Rem
bbdoc:
about:
EndRem
Type LTMoveSprite Extends LTAction
	Field Sprite:LTSprite
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:LTMoveSprite( Sprite:LTSprite, X:Float = 0, Y:Float = 0 )
		Local Action:LTMoveSprite = New LTMoveSprite
		Action.Sprite = Sprite
		Action.OldX = Sprite.X
		Action.OldY = Sprite.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Sprite.SetCoords( NewX, NewY )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Sprite.SetCoords( OldX, OldY )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type