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

Type TGrid Extends LTActiveObject
	Field CellWidth:Float = 1.0
	Field CellHeight:Float = 1.0
	Field CellXDiv:Int = 1
	Field CellYDiv:Int = 1
	
	
	
	Method Draw()
		Local SX:Float, SY:Float
		Editor.ShapeVisualizer.ApplyColor()
		
		Local X:Float = Floor( L_CurrentCamera.CornerX() / CellWidth ) * CellWidth
		Local EndX:Float = L_CurrentCamera.CornerX() + L_CurrentCamera.Width
		While X < EndX
			L_CurrentCamera.FieldToScreen( X, 0, SX, SY )
			DrawLine( SX, 0, SX, GraphicsHeight() )
			X :+ CellWidth
		WEnd
		
		Local Y:Float = Floor( L_CurrentCamera.CornerY() / CellHeight ) * CellHeight
		Local EndY:Float = L_CurrentCamera.CornerY() + L_CurrentCamera.Height
		While Y < EndY
			L_CurrentCamera.FieldToScreen( 0, Y, SX, SY )
			DrawLine( 0, SY, GraphicsWidth(), SY )
			Y :+ CellHeight
		WEnd
		
		SetColor( 255, 255, 255 )
	End Method
	
	
	
	Method SnapX:Float( X:Float )
		If MenuChecked( Editor.SnapToGrid ) Then Return L_Round( X / CellWidth * CellXDiv ) * CellWidth / CellXDiv Else Return X
	End Method
	
	
	
	Method SnapY:Float( Y:Float )
		If MenuChecked( Editor.SnapToGrid ) Then Return L_Round( Y / CellHeight * CellYDiv ) * CellHeight / CellYDiv Else Return Y
	End method
	
	
	
	Method Snap( X:Float Var, Y:Float Var )
		X = SnapX( X )
		Y = SnapY( Y )
	End Method
	
	
	
	Method SetSnaps( Side1:Float Var, Side2:Float Var, Vertical:Int )
		If MenuChecked( Editor.SnapToGrid ) Then
			Local Snap1:Float, Snap2:Float
			If Vertical Then
				Snap1 = DYSnap( Side1 )
				Snap2 = DYSnap( Side2 )
			Else
				Snap1 = DXSnap( Side1 )
				Snap2 = DXSnap( Side2 )
			End If
			
			If Abs( Snap1 ) < Abs( Snap2 ) Then
				Side1 :+ Snap1
				Side2 :+ Snap1
			Else
				Side1 :+ Snap2
				Side2 :+ Snap2
			End If
		End If
	End Method
	
	
	
	Method SetCornerSnaps( NewHorizontalSide:Float Var, NewVerticalSide:Float Var, HorizontalSide:Float Var,..
	VerticalSide:Float Var, OppositeHorizontalSide:Float, OppositeVerticalSide:Float, X:Float, Y:Float )
	
		Local Diagonal:Float = L_Distance( HorizontalSide - OppositeHorizontalSide, VerticalSide - OppositeVerticalSide )
		Local R:Float = L_Distance( X - OppositeHorizontalSide, Y - OppositeVerticalSide )
		
		NewHorizontalSide = OppositeHorizontalSide + ( HorizontalSide - OppositeHorizontalSide ) * R / Diagonal
		NewVerticalSide = OppositeVerticalSide + ( VerticalSide - OppositeVerticalSide ) * R / Diagonal
		
		If MenuChecked( Editor.SnapToGrid ) Then
			Local HorizontalSnap:Float = DXSnap( NewHorizontalSide )
			Local VerticalSnap:Float = DYSnap( NewVerticalSide )
			If Abs( HorizontalSnap ) < Abs( VerticalSnap ) Then
				NewHorizontalSide = NewHorizontalSide + HorizontalSnap
				NewVerticalSide = NewVerticalSide + HorizontalSnap * ( VerticalSide - OppositeVerticalSide ) / ( HorizontalSide - OppositeHorizontalSide )
			Else
				NewHorizontalSide = NewHorizontalSide + VerticalSnap * ( HorizontalSide - OppositeHorizontalSide ) / ( VerticalSide - OppositeVerticalSide )
				NewVerticalSide = NewVerticalSide + VerticalSnap
			End If
		End If
	End Method
	
	
	
	Method DXSnap:Float( Coord:Float )
		Return CellWidth * L_Round( Coord / CellWidth * CellXDiv ) / CellXDiv - Coord
	End Method
	
	
	
	Method DYSnap:Float( Coord:Float )
		Return CellHeight * L_Round( Coord / CellHeight * CellYDiv  ) / CellYDiv - Coord
	End Method
	
	
	
	Method Settings()
		Local GridSettingsWindow:TGadget = CreateWindow( "Grid settings", 0.5 * ClientWidth( Editor.Window ) - 96, 0.5 * ClientHeight( Editor.Window ) - 85, 193, 171, Desktop(), WINDOW_TITLEBAR|WINDOW_RESIZABLE )
		CreateLabel( "Cell width:", 64, 11, 51, 16, GridSettingsWindow, 0 )
		CreateLabel( "Cell height:", 60, 37, 55, 16, GridSettingsWindow, 0 )
		CreateLabel( "Vertical cell division:", 19, 59, 96, 16, GridSettingsWindow, 0 )
		CreateLabel( "Horizontal cell division:", 6, 83, 109, 16, GridSettingsWindow, 0 )
		Local CellWidthField:TGadget = CreateTextField( 120, 8, 56, 20, GridSettingsWindow )
		Local CellHeightField:TGadget = CreateTextField( 120, 32, 56, 20, GridSettingsWindow )
		Local VerticalDivField:TGadget = CreateTextField( 120, 56, 56, 20, GridSettingsWindow )
		Local HorizontalDivField:TGadget = CreateTextField( 120, 80, 56, 20, GridSettingsWindow )
		Local SelectColorButton:TGadget = CreateButton( "Select color", 8, 112, 80, 24, GridSettingsWindow, BUTTON_PUSH )
		Local OKButton:TGadget = CreateButton( "OK", 96, 112, 80, 24, GridSettingsWindow, BUTTON_PUSH )
		
		SetGadgetText( CellWidthField, CellWidth )
		SetGadgetText( CellHeightField, CellHeight )
		SetGadgetText( VerticalDivField, CellXDiv )
		SetGadgetText( HorizontalDivField, CellYDiv )
		
		Repeat
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case SelectColorButton
							RequestColor( 255.0 * Editor.ShapeVisualizer.Red, 255.0 * Editor.ShapeVisualizer.Green, 255.0 * Editor.ShapeVisualizer.Blue )
							Editor.ShapeVisualizer.Red = RequestedRed() / 255.0
							Editor.ShapeVisualizer.Green = RequestedGreen() / 255.0
							Editor.ShapeVisualizer.Blue = RequestedBlue() / 255.0
						Case OKButton
							Local NewCellWidth:Float = TextFieldText( CellWidthField ).ToFloat()
							Local NewCellHeight:Float = TextFieldText( CellHeightField ).ToFloat()
							Local NewCellXDiv:Float = TextFieldText( VerticalDivField ).ToInt()
							Local NewCellYDiv:Float = TextFieldText( HorizontalDivField ).ToInt()
							If NewCellWidth > 0 And NewCellHeight > 0 Then
								If NewCellXDiv > 0 And NewCellYDiv > 0 Then
									CellWidth = NewCellWidth
									CellHeight = NewCellHeight
									CellXDiv = NewCellXDiv
									CellYDiv = NewCellYDiv
									Exit
								Else
									Notify( "Cell divisions must be more than 0", True )
								End If
							Else
								Notify( "Cell width and height must be more than 0", True )
							End If
					End Select
				Case Event_WindowClose
					Exit
			End Select
		Forever
		FreeGadget( GridSettingsWindow )
	End Method
End Type