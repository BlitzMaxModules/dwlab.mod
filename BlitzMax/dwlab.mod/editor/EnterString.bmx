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

Function EnterString:Int( Message:String, St:String Var )
	Local InputWindow:TGadget = CreateWindow( Message, 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( InputWindow )
	Form.NewLine()
	Local StringField:TGadget = Form.AddTextField( "", 0, 300 )
	SetGadgetText( StringField, St )
	ActivateGadget( StringField )
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )
	
	Repeat
		Editor.Render()
	
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						St = TextFieldText( StringField )
						FreeGadget( InputWindow )
						Return True
					Case CancelButton
						FreeGadget( InputWindow )
						Return False
				End Select
		End Select
	Forever
End Function