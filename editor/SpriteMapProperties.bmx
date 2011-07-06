'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function SpriteMapProperties:Int( SpriteMap:LTSpriteMap )
	Local EditWindow:TGadget = CreateWindow( "{{W_SpriteMapProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( EditWindow )
	Form.NewLine()
	Local XQuantityTextField:TGadget = Form.AddTextField( "{{L_HorizontalCells}}", 165 )
	Local YQuantityTextField:TGadget = Form.AddTextField( "{{L_VerticalCells}}", 165 )
	Form.NewLine()
	Local CellWidthTextField:TGadget = Form.AddTextField( "{{L_CellWidth}}", 165 )
	Local CellHeightTextField:TGadget = Form.AddTextField( "{{L_CellHeight}}", 165 )
	Form.NewLine()
	Local LeftMarginTextField:TGadget = Form.AddTextField( "{{L_LeftMargin}}", 165 )
	Local TopMarginTextField:TGadget = Form.AddTextField( "{{L_TopMargin}}", 165 )
	Form.NewLine()
	Local RightMarginTextField:TGadget = Form.AddTextField( "{{L_RightMargin}}", 165 )
	Local BottomMarginTextField:TGadget = Form.AddTextField( "{{L_BottomMargin}}", 165 )
	Form.NewLine()
	Local Sorted:TGadget = Form.AddButton( "{{L_Sorted}}", 250, Button_CheckBox )
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )
	
	SetGadgetText( XQuantityTextField, SpriteMap.XQuantity )
	SetGadgetText( YQuantityTextField, SpriteMap.YQuantity )
	SetGadgetText( CellWidthTextField, L_TrimDouble( SpriteMap.CellWidth ) )
	SetGadgetText( CellHeightTextField, L_TrimDouble( SpriteMap.CellHeight ) )
	SetGadgetText( LeftMarginTextField, L_TrimDouble( SpriteMap.LeftMargin ) )
	SetGadgetText( TopMarginTextField, L_TrimDouble( SpriteMap.TopMargin ) )
	SetGadgetText( RightMarginTextField, L_TrimDouble( SpriteMap.RightMargin ) )
	SetGadgetText( BottomMarginTextField, L_TrimDouble( SpriteMap.BottomMargin ) )
	SetButtonState( Sorted, SpriteMap.Sorted )
	
	Repeat
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local XQuantity:Int = L_ToPowerOf2( TextFieldText( XQuantityTextField ).ToInt() )
						Local YQuantity:Int = L_ToPowerOf2( TextFieldText( YQuantityTextField ).ToInt() )
						
						Local CellWidth:Double = TextFieldText( CellWidthTextField ).ToDouble()
						Local CellHeight:Double = TextFieldText( CellHeightTextField ).ToDouble()
							
						if CellWidth > 0.0 And CellHeight > 0.0 Then
							SpriteMap.SetResolution( XQuantity, YQuantity )
							SpriteMap.CellWidth = CellWidth
							SpriteMap.CellHeight = CellHeight
							SpriteMap.LeftMargin = TextFieldText( LeftMarginTextField ).ToDouble()
							SpriteMap.TopMargin = TextFieldText( TopMarginTextField ).ToDouble()
							SpriteMap.RightMargin = TextFieldText( RightMarginTextField ).ToDouble()
							SpriteMap.BottomMargin = TextFieldText( BottomMarginTextField ).ToDouble()
							SpriteMap.Sorted = ButtonState( Sorted )
							
							FreeGadget( EditWindow )
							Return True
						Else
							Notify( LocalizeString( "{{N_CellSizeMoreThanZero}}" ) );
						End If
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( EditWindow )
	Return False
End Function