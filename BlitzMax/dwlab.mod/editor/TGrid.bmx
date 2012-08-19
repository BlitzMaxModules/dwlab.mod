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
	Method Draw()
		L_EditorData.GridColor.ApplyColor()
		
		Local MinX:Double, MinY:Double, MaxX:Double, MaxY:Double
		L_GetEscribedRectangle( 0, 0, 0, 0, MinX, MinY, MaxX, MaxY )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		
		X = Floor( MinX / L_EditorData.GridCellWidth ) * L_EditorData.GridCellWidth
		While X <= MaxX
			L_CurrentCamera.FieldToScreen( X, MinY, SX1, SY1 )
			L_CurrentCamera.FieldToScreen( X, MaxY, SX2, SY2 )
			DrawLine( SX1, SY1, SX2, SY2 )
			X :+ L_EditorData.GridCellWidth
		WEnd
		
		Y = Floor( MinY / L_EditorData.GridCellHeight ) * L_EditorData.GridCellHeight
		While Y <= MaxY
			L_CurrentCamera.FieldToScreen( MinX, Y, SX1, SY1 )
			L_CurrentCamera.FieldToScreen( MaxX, Y, SX2, SY2 )
			DrawLine( SX1, SY1, SX2, SY2 )
			Y :+ L_EditorData.GridCellHeight
		WEnd
		
		LTColor.ResetColor()
	End Method
	
	
	
	Method SnapCoords( X:Double Var, Y:Double Var )
		Local XStep:Double = L_EditorData.GridCellWidth / L_EditorData.GridCellXDiv
		X = XStep * L_Round( X / XStep )
		Local YStep:Double = L_EditorData.GridCellHeight / L_EditorData.GridCellYDiv
		Y = YStep * L_Round( Y / YStep )
	End Method
	
	
	
	Method SnapPosition( DX:Double Var, DY:Double Var, LeftX:Double, TopY:Double, RightX:Double, BottomY:Double )
		SnapCoord( DX, LeftX, RightX, L_EditorData.GridCellWidth / L_EditorData.GridCellXDiv )
		SnapCoord( DY, TopY, BottomY, L_EditorData.GridCellHeight / L_EditorData.GridCellYDiv )
	End Method
	
	
	
	Method SnapCoord( DX:Double Var, X1:Double, X2:Double, XStep:Double )
		If Not Editor.SnapToGrid Then Return 
		Select L_EditorData.GridPositionSnappingMode
			Case LTEditorData.EdgesSnapping
				Local DX1:Double = XStep * L_Round( ( X1 + DX ) / XStep ) - X1
				Local DX2:Double = XStep * L_Round( ( X2 + DX ) / XStep ) - X2
				If Abs( DX - DX1 ) < Abs( DX - DX2 ) Then DX = DX1 Else DX = DX2
			Case LTEditorData.CenterSnapping
				Local CenterX:Double = 0.5:Double * ( X1 + X2 )
				DX = XStep * L_Round( ( CenterX + DX ) / XStep ) - CenterX
			Case LTEditorData.FixedShifting
				DX = XStep * L_Round( DX / XStep )
		End Select
	End Method
	
	
	
	Method SnapWidth( DX:Double Var, X1:Double, X2:Double )
		SnapSize( DX, X1, X2, L_EditorData.GridCellWidth / L_EditorData.GridCellXDiv )
	End Method
	
	
	
	Method SnapHeight( DY:Double Var, Y1:Double, Y2:Double )
		SnapSize( DY, Y1, Y2, L_EditorData.GridCellHeight / L_EditorData.GridCellYDiv )
	End Method
	
	
	
	Method SnapSize( DX:Double Var, X:Double, X2:Double, XStep:Double )
		If Not Editor.SnapToGrid Then Return 
		Select L_EditorData.GridResizingSnappingMode
			Case LTEditorData.EdgesSnapping
				DX = XStep * L_Round( ( X + DX ) / XStep ) - X
			Case LTEditorData.SizeSnapping
				Local Size:Double = Abs( X2 - X )
				DX = XStep * L_Round( ( Size + DX ) / XStep ) - Size
			Case LTEditorData.FixedResizing
				DX = XStep * L_Round( DX / XStep )
		End Select
		
		If X < X2 Then
			If X + DX > X2 Then DX = X2 - X
		Else
			If X + DX < X2 Then DX = X2 - X
		End If
	End Method
	
	
	
	Method Settings()
		Local GridSettingsWindow:TGadget = CreateWindow( "{{W_GridSettings}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( GridSettingsWindow )
		Form.NewLine()
		Local PositionSnappingGadget:TGadget = Form.AddComboBox( "{{L_PositionSnapping}}", 250, 200 )
		Form.NewLine()
		Local ResizingSnappingGadget:TGadget = Form.AddComboBox( "{{L_ResizingSnapping}}", 250, 200 )
		Form.NewLine()
		Local CellWidthField:TGadget = Form.AddTextField( "{{L_CellWidth}}", 200 )
		Form.NewLine()
		Local CellHeightField:TGadget = Form.AddTextField( "{{L_CellHeight}}", 200 )
		Form.NewLine()
		Local HorizontalDivField:TGadget = Form.AddTextField( "{{L_HorizontalCellDivision}}", 200 )
		Form.NewLine()
		Local VerticalDivField:TGadget = Form.AddTextField( "{{L_VerticalCellDivision}}", 200 )
		Form.NewLine()
		Local SelectColorButton:TGadget = Form.AddButton( "{{B_SelectColor}}", 100 )
		Local OKButton:TGadget = Form.AddButton( "{{B_OK}}", 80, Button_OK )
		Form.Finalize()
		
		AddGadgetItem( PositionSnappingGadget, LocalizeString( "{{I_EdgeSnap}}" ) )
		AddGadgetItem( PositionSnappingGadget, LocalizeString( "{{I_CenterSnap}}" ) )
		AddGadgetItem( PositionSnappingGadget, LocalizeString( "{{I_FixedMovement}}" ) )
		SelectGadgetItem( PositionSnappingGadget, L_EditorData.GridPositionSnappingMode )
		
		AddGadgetItem( ResizingSnappingGadget, LocalizeString( "{{I_EdgeSnap}}" ) )
		AddGadgetItem( ResizingSnappingGadget, LocalizeString( "{{I_SizeSnap}}" ) )
		AddGadgetItem( ResizingSnappingGadget, LocalizeString( "{{I_FixedResize}}" ) )
		SelectGadgetItem( ResizingSnappingGadget, L_EditorData.GridResizingSnappingMode )
		
		SetGadgetText( CellWidthField, L_TrimDouble( L_EditorData.GridCellWidth ) )
		SetGadgetText( CellHeightField, L_TrimDouble( L_EditorData.GridCellHeight ) )
		SetGadgetText( HorizontalDivField, L_EditorData.GridCellXDiv )
		SetGadgetText( VerticalDivField, L_EditorData.GridCellYDiv )
		
		Repeat
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case SelectColorButton
							SelectColor( L_EditorData.GridColor )
							Editor.SetChanged()
						Case OKButton
							Local NewCellWidth:Double = TextFieldText( CellWidthField ).ToDouble()
							Local NewCellHeight:Double = TextFieldText( CellHeightField ).ToDouble()
							Local NewCellXDiv:Double = TextFieldText( HorizontalDivField ).ToInt()
							Local NewCellYDiv:Double = TextFieldText( VerticalDivField ).ToInt()
							If NewCellWidth > 0 And NewCellHeight > 0 Then
								If NewCellXDiv > 0 And NewCellYDiv > 0 Then
									L_EditorData.GridCellWidth = NewCellWidth
									L_EditorData.GridCellHeight = NewCellHeight
									L_EditorData.GridCellXDiv = NewCellXDiv
									L_EditorData.GridCellYDiv = NewCellYDiv
									L_EditorData.GridPositionSnappingMode = SelectedGadgetItem( PositionSnappingGadget )
									L_EditorData.GridResizingSnappingMode = SelectedGadgetItem( ResizingSnappingGadget )
									Editor.SetChanged()
									Exit
								Else
									Notify( LocalizeString( "{{N_CellDivisionsMore}}" ), True )
								End If
							Else
								Notify( LocalizeString( "{{N_CellSizesMore}}" ), True )
							End If
					End Select
				Case Event_WindowClose
					Exit
			End Select
		Forever
		FreeGadget( GridSettingsWindow )
	End Method
End Type



Function SelectColor:Int( Color:LTColor, SelectAlpha:Int = True )
	If Not RequestColor( 255.0 * Color.Red, 255.0 * Color.Green, 255.0 * Color.Blue ) Then Return False
	If SelectAlpha Then
		Local AlphaString:String = L_TrimDouble( Color.Alpha )
		If Not EnterString( "{{W_EnterAlpha}} (0.0 - 1.0)", AlphaString ) Then Return False
		Color.Alpha = AlphaString.ToDouble()
	End If
	Color.Red = RequestedRed() / 255.0
	Color.Green = RequestedGreen() / 255.0
	Color.Blue = RequestedBlue() / 255.0
	Return True
End Function