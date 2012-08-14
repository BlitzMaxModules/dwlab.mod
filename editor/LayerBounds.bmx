'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global LayerBounds:TLayerBounds  = New TLayerBounds
Type TLayerBounds Extends LTProject
	Field Layer:LTLayer
	Field Bounds:LTShape
	
	Field EditWindow:TGadget
	Field XTextField:TGadget
	Field YTextField:TGadget
	Field WidthTextField:TGadget
	Field HeightTextField:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
	
	Method Init()
		Layer = LTLayer( Editor.SelectedShape )
		Bounds = Layer.Bounds
		If Not Bounds Then Bounds = New LTShape
	
		EditWindow = CreateWindow( "{{W_LayerBounds}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( EditWindow )
		Form.NewLine()
		XTextField = Form.AddTextField( "{{L_X}}", 80 )
		YTextField = Form.AddTextField( "{{L_Y}}", 80 )
		Form.NewLine()
		WidthTextField = Form.AddTextField( "{{L_Width}}", 80 )
		HeightTextField = Form.AddTextField( "{{L_Height}}", 80 )
		Form.NewLine()
		AddOKCancelButtons( Form, OKButton, CancelButton )
	
		SetGadgetText( XTextField, L_TrimDouble( Bounds.X ) )
		SetGadgetText( YTextField, L_TrimDouble( Bounds.Y ) )
		SetGadgetText( WidthTextField, L_TrimDouble( Bounds.Width ) )
		SetGadgetText( HeightTextField, L_TrimDouble( Bounds.Height ) )
	End Method
	
	
	
	Method ProcessEvents()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Bounds.X = TextFieldText( XTextField ).ToDouble()
						Bounds.Y = TextFieldText( YTextField ).ToDouble()
						Bounds.Width = TextFieldText( WidthTextField ).ToDouble()
						Bounds.Height = TextFieldText( HeightTextField ).ToDouble()
						Layer.Bounds = Bounds
						Editor.SetChanged()
						Exiting = True
					Case CancelButton
						Exiting = True
				End Select
			Case Event_WindowClose
				Exiting = True
		End Select
	End Method
	
	
	
	Method Render()
		Editor.Render()
	End Method
	
	
	
	Method DeInit()
		FreeGadget( EditWindow )
	End Method
End Type