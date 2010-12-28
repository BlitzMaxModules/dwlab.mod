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

Type LTModifySprite Extends LTDrag
	Field StartX:Float
	Field StartY:Float
	Field Sprite:LTActor
	Field ModifierType:Int
	Field MDX:Int, MDY:Int
	Field LeftSide:Float, RightSide:Float
	Field TopSide:Float, BottomSide:Float
	Field NewLeftSide:Float, NewRightSide:Float
	Field NewTopSide:Float, NewBottomSide:Float
	
	
	
	Method DraggingConditions:Int()
		If Editor.SelectedModifier Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		ModifierType = Editor.SelectedModifier.Frame
		Sprite = LTActor( Editor.SelectedSprites.First() )
		MDX = Sgn( Editor.SelectedModifier.X - Sprite.X )
		MDY = Sgn( Editor.SelectedModifier.Y - Sprite.Y )
		
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
		LeftSide = Sprite.X - 0.5 * Sprite.XSize
		RightSide = Sprite.X + 0.5 * Sprite.XSize
		TopSide = Sprite.Y - 0.5 * Sprite.YSize
		BottomSide = Sprite.Y + 0.5 * Sprite.YSize
	End Method
	
	
	
	Method Dragging()
		Local X:Float, Y:Float, DX:Float, DY:Float
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		DX = X - StartX
		DY = Y - StartY
		
		NewLeftSide = LeftSide
		NewRightSide = RightSide
		NewTopSide = TopSide
		NewBottomSide = BottomSide
		
		Select ModifierType
			Case Editor.Move
				NewLeftSide = LeftSide + DX
				NewRightSide = RightSide + DX
				NewTopSide = TopSide + DY
				NewBottomSide = BottomSide + DY
				Editor.Grid.SetSnaps( NewLeftSide, NewRightSide, 0 )
				Editor.Grid.SetSnaps( NewTopSide, NewBottomSide, 1 )
			Case Editor.ResizeHorizontally
				HorizontalResize( DX )
			Case Editor.ResizeVertically
				VerticalResize( DY )
			Case Editor.Resize
				HorizontalResize( DX )
				VerticalResize( DY )
			Case Editor.ResizeDiagonally1
				If MDX < 0 Then
					Editor.Grid.SetCornerSnaps( NewLeftSide, NewTopSide, LeftSide, TopSide, RightSide, BottomSide, X, Y )
				Else
					Editor.Grid.SetCornerSnaps( NewRightSide, NewBottomSide, RightSide, BottomSide, LeftSide, TopSide, X, Y )
				End If
			Case Editor.ResizeDiagonally2
				If MDX < 0 Then
					Editor.Grid.SetCornerSnaps( NewLeftSide, NewBottomSide, LeftSide, BottomSide, RightSide, TopSide, X, Y )
				Else
					Editor.Grid.SetCornerSnaps( NewRightSide, NewTopSide, RightSide, TopSide, LeftSide, BottomSide, X, Y )
				End If
		End Select
				
		Sprite.X = 0.5 * ( NewLeftSide + NewRightSide )
		Sprite.Y = 0.5 * ( NewTopSide + NewBottomSide )
		Sprite.XSize = NewRightSide - NewLeftSide
		Sprite.YSize = NewBottomSide - NewTopSide
	End Method
	
	
	
	Method HorizontalResize( DX:Float )
		If MDX < 0 Then
			NewLeftSide = Editor.Grid.SnapX( LeftSide + DX )
			If NewLeftSide > NewRightSide Then NewLeftSide = NewRightSide
		Else
			NewRightSide = Editor.Grid.SnapX( RightSide + DX )
			If NewRightSide < NewLeftSide Then NewRightSide = NewLeftSide
		End If
	End Method
	
	
	
	Method VerticalResize( DY:Float )
		If MDY < 0 Then
			NewTopSide = Editor.Grid.SnapY( TopSide + DY )
			If NewTopSide > NewBottomSide Then NewTopSide = NewBottomSide
		Else
			NewBottomSide = Editor.Grid.SnapY( BottomSide + DY )
			If NewBottomSide < NewTopSide Then NewBottomSide = NewTopSide
		End If
	End Method
	
	
	
	Method EndDragging()
		Select ModifierType
			Case 8
				Sprite.Angle :- 45
			Case 9
				Sprite.Angle :+ 45
		End Select
		
		If Not Sprite.XSize Or Not Sprite.YSize Then
			Sprite.X = 0.5 * ( LeftSide + RightSide )
			Sprite.Y = 0.5 * ( TopSide + BottomSide )
			Sprite.XSize = RightSide - LeftSide
			Sprite.YSize = BottomSide - TopSide
		End If
		Editor.SetSpriteModifiers( Sprite )
	End Method
End Type