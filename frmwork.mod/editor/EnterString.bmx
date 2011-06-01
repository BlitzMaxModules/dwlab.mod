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
	Local InputWindow:TGadget = CreateWindow( Message, 0.5 * ClientWidth( Desktop() ) - 100, 0.5 * ClientHeight( Desktop() ) - 40, 200, 100, Editor.Window, WINDOW_TITLEBAR )
	Local StringField:TGadget = CreateTextField( 8, 8, 180, 20, InputWindow )
	SetGadgetText( StringField, St )
	ActivateGadget( StringField )
	Local OKButton:TGadget = CreateButton( "{{B_OK}}", 24, 36, 72, 24, InputWindow, Button_OK )
	Local CancelButton:TGadget = CreateButton( "{{B_Cancel}}", 104, 36, 72, 24, InputWindow, Button_Cancel )
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