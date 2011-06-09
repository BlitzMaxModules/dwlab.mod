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

Function ChooseParameter:Int( Width:Int Var, Height:Int Var, Title:String, WidthLabel:String, HeightLabel:String )
	Local Settings:TGadget =CreateWindow( Title, 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Settings )
	Form.NewLine()
	Form.MaxWidth = 250
	Local WidthField:TGadget = Form.AddTextField( WidthLabel, 100 )
	SetGadgetText( WidthField, Width )
	Form.NewLine()
	Local HeightField:TGadget = Form.AddTextField( HeightLabel, 100 )
	SetGadgetText( HeightField, Height )
	Form.NewLine()
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )
	
	Repeat
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local NewWidth:Int = TextFieldText( WidthField ).ToInt()
						Local NewHeight:Int = TextFieldText( HeightField ).ToInt()
						
						If NewWidth >= 0 And NewHeight >= 0 Then
							Width = NewWidth
							Height = NewHeight
							FreeGadget( Settings )
							Return True
						Else
							Notify( LocalizeString( "{{N_ParametersMustBeMoreThanZero}}" ), True )
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