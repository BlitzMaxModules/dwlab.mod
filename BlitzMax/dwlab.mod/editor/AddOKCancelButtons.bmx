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

Function AddOKCancelButtons( Form:LTForm, OKButton:TGadget Var, CancelButton:TGadget Var )
	Form.NewLine()
	OKButton = Form.AddButton( "{{B_OK}}", 64, Button_OK )
	CancelButton = Form.AddButton( "{{B_Cancel}}", 64, Button_Cancel )
	Form.Finalize()
End Function