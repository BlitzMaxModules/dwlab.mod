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

Function EnterString:String( Message:String, St:String = "" )
	Local InputWindow:TGadget = CreateWindow( Message, 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( InputWindow )
	Form.NewLine()
	Local StringField:TGadget = Form.AddTextField( "", 0, 200 )
	SetGadgetText( StringField, St )
	ActivateGadget( StringField )
	Form.NewLine()
	Local OKButton:TGadget = Form.AddButton( "{{B_OK}}", 72, Button_OK )
	Local CancelButton:TGadget = Form.AddButton( "{{B_Cancel}}", 72, Button_Cancel )
	Form.Finalize()
	
	Repeat
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						St = TextFieldText( StringField )
						FreeGadget( InputWindow )
						Return St
					Case CancelButton
						FreeGadget( InputWindow )
						Return ""
				End Select
		End Select
	Forever
End Function