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

Type TGrid Extends LTShape
	Field CellWidth:Double = 1.0
	Field CellHeight:Double = 1.0
	Field CellXDiv:Int = 2
	Field CellYDiv:Int = 2
	
	
	
	Method Draw()
		Local SX:Double, SY:Double
		L_DebugVisualizer.ApplyColor()
		SetAlpha( 1.0 )
		
		Local SX2:Double, SY2:Double
		If L_CurrentCamera.Isometric Then
			
		End If
		
		Local X1:Double = Floor( L_CurrentCamera.LeftX() / CellWidth ) * CellWidth
		Local X2:Double = L_CurrentCamera.RightX()
		Local Y1:Double = Floor( L_CurrentCamera.TopY() / CellHeight ) * CellHeight
		Local Y2:Double = L_CurrentCamera.BottomY()
		
		X = X1
		While X < X2
			If L_CurrentCamera.Isometric Then
				L_CurrentCamera.FieldToScreen( X, Y1, SX, SY )
				L_CurrentCamera.FieldToScreen( X, Y2, SX2, SY2 )
				DrawLine( SX, SY, SX2, SY2 )
			Else
				L_CurrentCamera.FieldToScreen( X, 0, SX, SY )
				DrawLine( SX, 0, SX, GraphicsHeight() )
			End If
			X :+ CellWidth
		WEnd
		
		Y = Y1
		While Y < Y2
			If L_CurrentCamera.Isometric Then
				L_CurrentCamera.FieldToScreen( X1, Y, SX, SY )
				L_CurrentCamera.FieldToScreen( X2, Y, SX2, SY2 )
				DrawLine( SX, SY, SX2, SY2 )
			Else
				L_CurrentCamera.FieldToScreen( 0, Y, SX, SY )
				DrawLine( 0, SY, GraphicsWidth(), SY )
			End If
			Y :+ CellHeight
		WEnd
		
		SetColor( 255, 255, 255 )
	End Method
	
	
	
	Method SnapX:Double( X:Double )
		If Editor.SnapToGrid Then Return L_Round( X / CellWidth * CellXDiv ) * CellWidth / CellXDiv Else Return X
	End Method
	
	
	
	Method SnapY:Double( Y:Double )
		If Editor.SnapToGrid Then Return L_Round( Y / CellHeight * CellYDiv ) * CellHeight / CellYDiv Else Return Y
	End method
	
	
	
	Method Snap( X:Double Var, Y:Double Var )
		X = SnapX( X )
		Y = SnapY( Y )
	End Method
	
	
	
	Method SetSnaps( Side1:Double Var, Side2:Double Var, Vertical:Int )
		If Editor.SnapToGrid Then
			Local Snap1:Double, Snap2:Double
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
	
	
	
	Method SetCornerSnaps( NewHorizontalSide:Double Var, NewVerticalSide:Double Var, HorizontalSide:Double Var,..
	VerticalSide:Double Var, OppositeHorizontalSide:Double, OppositeVerticalSide:Double, X:Double, Y:Double )
	
		Local Diagonal:Double = L_Distance( HorizontalSide - OppositeHorizontalSide, VerticalSide - OppositeVerticalSide )
		Local R:Double = L_Distance( X - OppositeHorizontalSide, Y - OppositeVerticalSide )
		
		NewHorizontalSide = OppositeHorizontalSide + ( HorizontalSide - OppositeHorizontalSide ) * R / Diagonal
		NewVerticalSide = OppositeVerticalSide + ( VerticalSide - OppositeVerticalSide ) * R / Diagonal
		
		If Editor.SnapToGrid Then
			Local HorizontalSnap:Double = DXSnap( NewHorizontalSide )
			Local VerticalSnap:Double = DYSnap( NewVerticalSide )
			If Abs( HorizontalSnap ) < Abs( VerticalSnap ) Then
				NewHorizontalSide = NewHorizontalSide + HorizontalSnap
				NewVerticalSide = NewVerticalSide + HorizontalSnap * ( VerticalSide - OppositeVerticalSide ) / ( HorizontalSide - OppositeHorizontalSide )
			Else
				NewHorizontalSide = NewHorizontalSide + VerticalSnap * ( HorizontalSide - OppositeHorizontalSide ) / ( VerticalSide - OppositeVerticalSide )
				NewVerticalSide = NewVerticalSide + VerticalSnap
			End If
		End If
	End Method
	
	
	
	Method DXSnap:Double( Coord:Double )
		Return CellWidth * L_Round( Coord / CellWidth * CellXDiv ) / CellXDiv - Coord
	End Method
	
	
	
	Method DYSnap:Double( Coord:Double )
		Return CellHeight * L_Round( Coord / CellHeight * CellYDiv  ) / CellYDiv - Coord
	End Method
	
	
	
	Method Settings()
		Local GridSettingsWindow:TGadget = CreateWindow( "{{W_GridSettings}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( GridSettingsWindow )
		Form.NewLine()
		Local CellWidthField:TGadget = Form.AddTextField( "{{L_CellWidth}}", 200 )
		Form.NewLine()
		Local CellHeightField:TGadget = Form.AddTextField( "{{L_CellHeight}}", 200 )
		Form.NewLine()
		Local HorizontalDivField:TGadget = Form.AddTextField( "{{L_HorizontalCellDivision}}", 200 )
		Form.NewLine()
		Local VerticalDivField:TGadget = Form.AddTextField( "{{L_VerticalCellDivision}}", 200 )
		Form.NewLine()
		Local SelectColorButton:TGadget = Form.AddButton( "{{B_SelectColor}}", 80 )
		Local OKButton:TGadget = Form.AddButton( "{{B_OK}}", 80, Button_OK )
		Form.Finalize()
		
		SetGadgetText( CellWidthField, CellWidth )
		SetGadgetText( CellHeightField, CellHeight )
		SetGadgetText( HorizontalDivField, CellXDiv )
		SetGadgetText( VerticalDivField, CellYDiv )
		
		Repeat
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case SelectColorButton
							RequestColor( 255.0 * L_DebugVisualizer.Red, 255.0 * L_DebugVisualizer.Green, 255.0 * L_DebugVisualizer.Blue )
							L_DebugVisualizer.Red = RequestedRed() / 255.0
							L_DebugVisualizer.Green = RequestedGreen() / 255.0
							L_DebugVisualizer.Blue = RequestedBlue() / 255.0
						Case OKButton
							Local NewCellWidth:Double = TextFieldText( CellWidthField ).ToDouble()
							Local NewCellHeight:Double = TextFieldText( CellHeightField ).ToDouble()
							Local NewCellXDiv:Double = TextFieldText( HorizontalDivField ).ToInt()
							Local NewCellYDiv:Double = TextFieldText( VerticalDivField ).ToInt()
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