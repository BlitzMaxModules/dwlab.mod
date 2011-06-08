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
	Local Settings:TGadget =CreateWindow( "{{L_Choose}} " + Parameter + ":", 0, 0, 10, 10, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Settings )
	Form.NewLine()
	Local WidthField:TGadget = Form.AddTextField( "{{L_Width}}", 48 )
	SetGadgetText( WidthField, Width )
	Form.AddLabel( Units, 46, Label_Left )
	Form.NewLine()
	Local HeightField:TGadget = Form.AddTextField( "{{L_Height}}", 48 )
	SetGadgetText( HeightField, Height )
	Form.AddLabel( Units, 46, Label_Left )
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