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

Global ParameterProperties:TParameterProperties = New TParameterProperties

Type TParameterProperties Extends LTProject
	Field Succesful:Int
	Field Window:TGadget
	Field NameComboBox:TGadget
	Field ValueField:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
		
	Method Init()
		Window = CreateWindow( "{{W_ParameterProerties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		NameComboBox = Form.AddComboBox( "{{L_ParameterName}}", 75, 300, ComboBox_Editable )
		Form.NewLine()
		ValueField:TGadget = Form.AddTextField( "{{L_ParameterValue}}", 75, 300 )
		AddOKCancelButtons( Form, OKButton, CancelButton )
		
		For Local ParameterName:String = Eachin Editor.ParameterNames.Keys()
			AddGadgetItem( NameComboBox, ParameterName )
		Next
	
		SetGadgetText( NameComboBox, Editor.SelectedParameter.Name )
		SetGadgetText( ValueField, Editor.SelectedParameter.Value )
	End Method
	
	
	
	Method ProcessEvents()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Editor.SelectedParameter.Name = GadgetText( NameComboBox )
						Editor.ParameterNames.Insert( Editor.SelectedParameter.Name, Null )
						Editor.SelectedParameter.Value = TextFieldText( ValueField )
						Editor.SetChanged()
						Succesful = True
						Exiting = True
					Case CancelButton
						Succesful = False
						Exiting = True
				End Select
			Case Event_WindowClose
				Succesful = False
				Exiting = True
		End Select
	End Method
	
	
	
	Method Render()
		Editor.Render()
	End Method
	
	
	
	Method DeInit()
		FreeGadget( Window )
		ActivateGadget( Editor.Window )
	End Method
End Type