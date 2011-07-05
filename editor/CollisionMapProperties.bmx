'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function CollisionMapProperties:Int( CollisionMap:LTCollisionMap )
	Local EditWindow:TGadget = CreateWindow( "{{W_CollisionMapProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( EditWindow )
	Form.NewLine()
	Local XQuantityTextField:TGadget = Form.AddTextField( "{{L_HorizontalCells}}", 165 )
	Local YQuantityTextField:TGadget = Form.AddTextField( "{{L_VerticalCells}}", 165 )
	Form.NewLine()
	Local CellWidthTextField:TGadget = Form.AddTextField( "{{L_CellWidth}}", 165 )
	Local CellHeightTextField:TGadget = Form.AddTextField( "{{L_CellHeight}}", 165 )
	Form.NewLine()
	Local Sorted:TGadget = Form.AddButton( "{{L_Sorted}}", 165, Button_CheckBox )
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )
	
	SetGadgetText( XQuantityTextField, CollisionMap.XQuantity )
	SetGadgetText( YQuantityTextField, CollisionMap.YQuantity )
	SetGadgetText( CellWidthTextField, CollisionMap.CellWidth )
	SetGadgetText( CellHeightTextField, CollisionMap.CellHeight )
	SetButtonState( Sorted, CollisionMap.Sorted )
	
	Repeat
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local XQuantity:Int = L_ToPowerOf2( TextFieldText( XQuantityTextField ).ToInt() )
						Local YQuantity:Int = L_ToPowerOf2( TextFieldText( YQuantityTextField ).ToInt() )
						
						Local CellWidth:Double = TextFieldText( CellWidthTextField ).ToFloat()
						Local CellHeight:Double = TextFieldText( CellHeightTextField ).ToFloat()
							
						if CellWidth > 0.0 And CellHeight > 0.0 Then
							CollisionMap.SetResolution( XQuantity, YQuantity )
							CollisionMap.CellWidth = CellWidth
							CollisionMap.CellHeight = CellHeight
							CollisionMap.Sorted = ButtonState( Sorted )
							
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