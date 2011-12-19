'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global CameraProperties:TCameraProperties = New TCameraProperties

Type TCameraProperties Extends LTProject
	Field Window:TGadget
	Field IsometricCheckBox:TGadget
	Field X1TextField:TGadget
	Field Y1TextField:TGadget
	Field X2TextField:TGadget
	Field Y2TextField:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
		
	Method Init()
		Window = CreateWindow( "{{W_CameraProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		IsometricCheckBox = Form.AddButton( "{{L_Isometric}}", 80, Button_CheckBox )
		Form.NewLine()
		X1TextField = Form.AddTextField( "{{L_X1}}", 40 )
		Y1TextField = Form.AddTextField( "{{L_Y1}}", 40 )
		Form.NewLine()
		X2TextField = Form.AddTextField( "{{L_X2}}", 40 )
		Y2TextField = Form.AddTextField( "{{L_Y2}}", 40 )
		AddOKCancelButtons( Form, OKButton, CancelButton )
		
		L_CurrentCamera = Editor.MainCamera		
		SetGadgetText( X1TextField, L_TrimDouble( L_CurrentCamera.VX1 ) )
		SetGadgetText( Y1TextField, L_TrimDouble( L_CurrentCamera.VY1 ) )
		SetGadgetText( X2TextField, L_TrimDouble( L_CurrentCamera.VX2 ) )
		SetGadgetText( Y2TextField, L_TrimDouble( L_CurrentCamera.VY2 ) )
		SetButtonState( IsometricCheckBox, L_CurrentCamera.Isometric )
	End Method
	
	
	
	Method Logic()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local X1:Double = TextFieldText( X1TextField ).ToDouble()
						Local Y1:Double = TextFieldText( Y1TextField ).ToDouble()
						Local X2:Double = TextFieldText( X2TextField ).ToDouble()
						Local Y2:Double = TextFieldText( Y2TextField ).ToDouble()
						Local Isometric:Int = ButtonState( IsometricCheckBox )
						If X1 * Y2 = Y1 * X2 And Isometric Then
							Notify( LocalizeString( "{{N_VectorsAreParallel}}" ) )
						Else
							L_CurrentCamera.Isometric = Isometric
							L_CurrentCamera.VX1 = X1
							L_CurrentCamera.VY1 = Y1
							L_CurrentCamera.VX2 = X2
							L_CurrentCamera.VY2 = Y2
							Editor.SetChanged()
							Exiting = True
						End If
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
		FreeGadget( Window )
	End Method
End Type