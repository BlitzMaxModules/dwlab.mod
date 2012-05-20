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
	Field LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
	Field ModifierType:Int
	Field MDX:Int, MDY:Int
	
	
	
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
		
		LeftX = Shape.LeftX()
		TopY = Shape.TopY()
		RightX = Shape.RightX()
		BottomY = Shape.BottomY()
		
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
	End Method
	
	
	
	Method Dragging()
		Local X:Double, Y:Double, DX:Double, DY:Double
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		DX = X - StartX
		DY = Y - StartY
		
		Select ModifierType
			Case ResizeHorizontally
				HorizontalResize( DX )
			Case ResizeVertically
				VerticalResize( DY )
			Case Resize
				HorizontalResize( DX )
				VerticalResize( DY )
		End Select
	End Method
	
	
	
	Method HorizontalResize( DX:Double Var )
		If MDX < 0 Then
			Editor.Grid.SnapWidth( DX, LeftX, RightX )
			Shape.SetWidth( RightX - LeftX - DX )
			Shape.SetX( RightX - Shape.Width * 0.5 )
		Else
			Editor.Grid.SnapWidth( DX, RightX, LeftX )
			Shape.SetWidth( RightX - LeftX + DX )
			Shape.SetX( LeftX + Shape.Width * 0.5 )
		End If
	End Method
	
	
	
	Method VerticalResize( DY:Double )
		If MDY < 0 Then
			Editor.Grid.SnapHeight( DY, TopY, BottomY )
			Shape.SetHeight( BottomY - TopY - DY )
			Shape.SetY( BottomY - Shape.Height * 0.5 )
		Else
			Editor.Grid.SnapHeight( DY, BottomY, TopY )
			Shape.SetHeight( BottomY - TopY + DY )
			Shape.SetY( TopY + Shape.Height * 0.5 )
		End If
	End Method
	
	
	
	Method EndDragging()
		If Not Shape.Width Or Not Shape.Height Then
			Shape.X = 0.5 * ( LeftX + RightX )
			Shape.Y = 0.5 * ( TopY + BottomY )
			Shape.Width = RightX - LeftX
			Shape.Height = BottomY - TopY
		Else
			Editor.SetChanged()
		End If
		
		Editor.SetShapeModifiers( Shape )
		Editor.FillShapeFields()
	End Method
End Type