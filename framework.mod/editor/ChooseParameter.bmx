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

Function ChooseParameter:Int( Width:Int Var, Height:Int Var, Parameter:String, Units:String )
	Local Settings:TGadget =CreateWindow( "{{L_Choose}} " + Parameter + ":", 0.5 * ClientWidth( Desktop() ) - 72, 0.5 * ClientHeight( Desktop() ) - 78, 144, 157, Editor.Window, WINDOW_TITLEBAR )
	CreateLabel( "{{L_Height}}", 8, 10, 38, 16, Settings, Label_Right )
	Local WidthField:TGadget = CreateTextField( 48, 8, 40, 20, Settings )
	SetGadgetText( WidthField, Width )
	CreateLabel( "{{L_Width}}", 8, 35, 38, 16, Settings, Label_Right )
	Local HeightField:TGadget = CreateTextField( 48, 32, 40, 20, Settings )
	SetGadgetText( HeightField, Height )
	CreateLabel( Units, 92, 10, 36, 16, Settings, 0 )
	CreateLabel( Units, 92, 34, 36, 16, Settings, 0 )
	Local OKButton:TGadget = CreateButton( "{{B_OK}}", 32, 64, 72, 24, Settings )
	Local CancelButton:TGadget = CreateButton( "{{B_Cancel}}", 32, 96, 72, 24, Settings )
	
	Repeat
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local NewWidth:Int = TextFieldText( WidthField ).ToInt()
						Local NewHeight:Int = TextFieldText( HeightField ).ToInt()
						
						If NewWidth < 0 And NewHeight < 0 Then
							Notify( Parameter + LocalizeString( "{{N_MustBeMoreZero}}" ), True )
						Else
							Width = NewWidth
							Height = NewHeight
							Editor.SetChanged()
							FreeGadget( Settings )
							Return True
						End If
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	
	FreeGadget( Settings )
	Return False
End Function