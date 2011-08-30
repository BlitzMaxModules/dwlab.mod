'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global TileMapProperties:TTileMapProperties = New TTileMapProperties
Type TTileMapProperties Extends LTProject
	Field TileMap:LTTileMap
	
	Field EditWindow:TGadget
	Field LeftMarginTextField:TGadget
	Field TopMarginTextField:TGadget
	Field RightMarginTextField:TGadget
	Field BottomMarginTextField:TGadget
	Field HorizontalOrderComboBox:TGadget
	Field VerticalOrderComboBox:TGadget
	Field WrappedCheckBox:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
	
	Method Init()
		EditWindow = CreateWindow( "{{W_TileMapProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( EditWindow )
		Form.NewLine()
		LeftMarginTextField = Form.AddTextField( "{{L_LeftMargin}}", 165 )
		TopMarginTextField = Form.AddTextField( "{{L_TopMargin}}", 165 )
		Form.NewLine()
		RightMarginTextField = Form.AddTextField( "{{L_RightMargin}}", 165 )
		BottomMarginTextField = Form.AddTextField( "{{L_BottomMargin}}", 165 )
		Form.NewLine()
		HorizontalOrderComboBox = Form.AddComboBox( "{{L_HorizontalOrder}}", 200, 100 )
		AddGadgetItem( HorizontalOrderComboBox, LocalizeString( "{{I_LeftToRight}}" ) )
		AddGadgetItem( HorizontalOrderComboBox, LocalizeString( "{{I_RightToLeft}}" ) )
		Form.NewLine()
		VerticalOrderComboBox = Form.AddComboBox( "{{L_VerticalOrder}}", 200, 100 )
		AddGadgetItem( VerticalOrderComboBox, LocalizeString( "{{I_TopToBottom}}" ) )
		AddGadgetItem( VerticalOrderComboBox, LocalizeString( "{{I_BottomToTop}}" ) )
		Form.NewLine()
		WrappedCheckBox = Form.AddButton( "{{L_Wrapped}}", 200, Button_CheckBox )
		AddOKCancelButtons( Form, OKButton, CancelButton )
	
		SetGadgetText( LeftMarginTextField, L_TrimDouble( TileMap.LeftMargin ) )
		SetGadgetText( TopMarginTextField, L_TrimDouble( TileMap.TopMargin ) )
		SetGadgetText( RightMarginTextField, L_TrimDouble( TileMap.RightMargin ) )
		SetGadgetText( BottomMarginTextField, L_TrimDouble( TileMap.BottomMargin ) )
		SelectGadgetItem( HorizontalOrderComboBox, TileMap.HorizontalOrder = -1 )
		SelectGadgetItem( VerticalOrderComboBox, TileMap.VerticalOrder = -1 )
		SetButtonState( WrappedCheckBox, TileMap.Wrapped )
	End Method
	
	
	
	Method Logic()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						TileMap.LeftMargin = TextFieldText( LeftMarginTextField ).ToDouble()
						TileMap.TopMargin = TextFieldText( TopMarginTextField ).ToDouble()
						TileMap.RightMargin = TextFieldText( RightMarginTextField ).ToDouble()
						TileMap.BottomMargin = TextFieldText( BottomMarginTextField ).ToDouble()
						If SelectedGadgetItem( HorizontalOrderComboBox ) = 1 Then TileMap.HorizontalOrder = -1 Else TileMap.HorizontalOrder = 1
						If SelectedGadgetItem( VerticalOrderComboBox ) = 1 Then TileMap.VerticalOrder = -1 Else TileMap.VerticalOrder = 1
						TileMap.Wrapped = ButtonState( WrappedCheckBox )
						Editor.SetChanged()
						Exiting = True
					Case CancelButton
						Exiting = True
				End Select
			Case Event_WindowClose
				Exiting = True
		End Select
	End Method
	
	
	
	Method DeInit()
		FreeGadget( EditWindow )
	End Method
End Type