'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TModifyShape Extends LTDrag
	Field StartX:Double
	Field StartY:Double
	Field Shape:LTShape
	Field ModifierType:Int
	Field MDX:Int, MDY:Int
	Field LeftSide:Double, RightSide:Double
	Field TopSide:Double, BottomSide:Double
	Field NewLeftSide:Double, NewRightSide:Double
	Field NewTopSide:Double, NewBottomSide:Double
	
	
	
	Const Move:Int = 0
	Const ResizeHorizontally:Int = 1
	Const ResizeVertically:Int = 2
	Const Resize:Int = 3
	
	
	
	Method DraggingConditions:Int()
		If Editor.SelectedModifier Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method
	
	
	
	Method StartDragging()
		ModifierType = Editor.SelectedModifier.Frame
		Shape = LTShape( Editor.SelectedShapes.First() )
		MDX = Sgn( Editor.SelectedModifier.X - Shape.X )
		MDY = Sgn( Editor.SelectedModifier.Y - Shape.Y )
		
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
		LeftSide = Shape.X - 0.5 * Shape.Width
		RightSide = Shape.X + 0.5 * Shape.Width
		TopSide = Shape.Y - 0.5 * Shape.Height
		BottomSide = Shape.Y + 0.5 * Shape.Height
	End Method
	
	
	
	Method Dragging()
		Local X:Double, Y:Double, DX:Double, DY:Double
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		DX = X - StartX
		DY = Y - StartY
		
		NewLeftSide = LeftSide
		NewRightSide = RightSide
		NewTopSide = TopSide
		NewBottomSide = BottomSide
		
		Select ModifierType
			Case Move
				NewLeftSide = LeftSide + DX
				NewRightSide = RightSide + DX
				NewTopSide = TopSide + DY
				NewBottomSide = BottomSide + DY
				Editor.Grid.SetSnaps( NewLeftSide, NewRightSide, 0 )
				Editor.Grid.SetSnaps( NewTopSide, NewBottomSide, 1 )
			Case ResizeHorizontally
				HorizontalResize( DX )
			Case ResizeVertically
				VerticalResize( DY )
			Case Resize
				HorizontalResize( DX )
				VerticalResize( DY )
		End Select
				
		Shape.SetCoords( 0.5 * ( NewLeftSide + NewRightSide ), 0.5 * ( NewTopSide + NewBottomSide ) )
		Shape.SetSize( NewRightSide - NewLeftSide, NewBottomSide - NewTopSide )
	End Method
	
	
	
	Method HorizontalResize( DX:Double )
		If MDX < 0 Then
			NewLeftSide = Editor.Grid.SnapX( LeftSide + DX )
			If NewLeftSide > NewRightSide Then NewLeftSide = NewRightSide
		Else
			NewRightSide = Editor.Grid.SnapX( RightSide + DX )
			If NewRightSide < NewLeftSide Then NewRightSide = NewLeftSide
		End If
	End Method
	
	
	
	Method VerticalResize( DY:Double )
		If MDY < 0 Then
			NewTopSide = Editor.Grid.SnapY( TopSide + DY )
			If NewTopSide > NewBottomSide Then NewTopSide = NewBottomSide
		Else
			NewBottomSide = Editor.Grid.SnapY( BottomSide + DY )
			If NewBottomSide < NewTopSide Then NewBottomSide = NewTopSide
		End If
	End Method
	
	
	
	Method EndDragging()
		If Not Shape.Width Or Not Shape.Height Then
			Shape.X = 0.5 * ( LeftSide + RightSide )
			Shape.Y = 0.5 * ( TopSide + BottomSide )
			Shape.Width = RightSide - LeftSide
			Shape.Height = BottomSide - TopSide
		Else
			Editor.SetChanged()
		End If
		
		Editor.SetShapeModifiers( Shape )
		Editor.FillShapeFields()
	End Method
End Type