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
	
	Field EditWindow:TGadget
	Field LeftMarginTextField:TGadget
	Field TopMarginTextField:TGadget
	Field RightMarginTextField:TGadget
	Field BottomMarginTextField:TGadget
	Field WrappedCheckBox:TGadget
	Field OKButton:TGadget, CancelButton:TGadget, ClearButton:TGadget
	
	
	
	Method Init()
		Layer = LTLayer( Editor.SelectedShapes.First() )
	
		EditWindow = CreateWindow( "{{W_LayerBounds}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( EditWindow )
		Form.NewLine()
		XTextField = Form.AddTextField( "{{L_X}}", 165 )
		YTextField = Form.AddTextField( "{{L_Y}}", 165 )
		Form.NewLine()
		WidthTextField = Form.AddTextField( "{{L_Width}}", 165 )
		HeightTextField = Form.AddTextField( "{{L_Height}}", 165 )
		Form.NewLine()
		AddOKCancelButtons( Form, OKButton, CancelButton )
		ClearButton = Form.AddButton( "{{B_ClearButton}}" )
	
		SetGadgetText( XTextField, L_TrimDouble( Layer.X ) )
		SetGadgetText( YTextField, L_TrimDouble( Layer.Y ) )
		SetGadgetText( WidthTextField, L_TrimDouble( Layer.Width ) )
		SetGadgetText( HeightTextField, L_TrimDouble( Layer.Height ) )
	End Method
	
	
	
	Method ProcessEvents()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Layer.Bounds.X = TextFieldText( XTextField ).ToDouble()
						Layer.Bounds.Y = TextFieldText( YTextField ).ToDouble()
						Layer.Bounds.Width = TextFieldText( WidthTextField ).ToDouble()
						Layer.Bounds.Height = TextFieldText( HeightTextField ).ToDouble()
						Editor.SetChanged()
						Exiting = True
					Case ClearButton
						Bounds = Null
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