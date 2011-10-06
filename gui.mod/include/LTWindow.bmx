'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTWindow Extends LTLayer
	Field World:LTWorld
	Field Project:LTGUIProject
	Field MouseOver:TMap = New TMap
	Field Modal:Int
	
	
	
	Method Draw()
		If Not Visible Then Return
		If Modal Then L_CurrentCamera.Darken( 0.3 )
		Super.Draw()
	End Method
	
	
	
	Method Act()
		If Not Active Then Return
		
		For Local Gadget:LTGadget = Eachin Children
			If Not Gadget.Active Then Continue
			
			If Gadget.CollidesWithSprite( L_Cursor ) Then
				If Not MouseOver.Contains( Gadget ) Then
					OnMouseOver( Gadget )
					Gadget.OnMouseOver()
					MouseOver.Insert( Gadget, Null )
				End If
				
				For Local ButtonAction:LTButtonAction = Eachin L_GUIButtons
					If ButtonAction.WasPressed() Then
						OnButtonPress( Gadget, ButtonAction )
						Gadget.OnButtonPress( ButtonAction )
					End If
					If ButtonAction.WasUnpressed() Then
						OnButtonUnpress( Gadget, ButtonAction )
						Gadget.OnButtonUnpress( ButtonAction )
					End If
					If ButtonAction.IsDown() Then
						OnButtonDown( Gadget, ButtonAction )
						Gadget.OnButtonDown( ButtonAction )
					Else
						OnButtonUp( Gadget, ButtonAction )
						Gadget.OnButtonUp( ButtonAction )
					End If
				Next
			ElseIf MouseOver.Contains( Gadget ) Then
				Gadget.OnMouseOut()
				OnMouseOut( Gadget )
				MouseOver.Remove( Gadget )
			End If
		Next
	
		If L_ActiveTextField Then
			If L_ActiveTextField.Active Then
				Local LeftPart:String = L_ActiveTextField.LeftPart
				Local RightPart:String = L_ActiveTextField.RightPart
				If LeftPart Then
					If L_CharacterLeft.WasPressed() Then
						L_ActiveTextField.RightPart = LeftPart[ LeftPart.Length - 1.. ] + RightPart
						L_ActiveTextField.LeftPart = LeftPart[ ..LeftPart.Length - 1 ]
					End If
					If L_DeletePreviousCharacter.WasPressed() Then L_ActiveTextField.LeftPart = LeftPart[ ..LeftPart.Length - 1 ]
				End If
				If RightPart Then
					If L_CharacterRight.WasPressed() Then
						L_ActiveTextField.LeftPart = LeftPart + RightPart[ ..1 ]
						L_ActiveTextField.RightPart = RightPart[ 1.. ]
					End If
					If L_DeleteNextCharacter.WasPressed() Then L_ActiveTextField.RightPart = RightPart[ 1.. ]
				End If
				Local Key:Int = GetChar()
				If Key >= 32 Then L_ActiveTextField.LeftPart :+ Chr( Key )
				L_ActiveTextField.Text = L_ActiveTextField.LeftPart + L_ActiveTextField.RightPart
			End If
		End If
		
		Super.Act()
	End Method

	
	
	Method GetTextFieldText:String( Name:String )
	End Method
	
	
	
	Method OnButtonUnpress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		Select Gadget.GetParameter( "action" )
			Case "save"
				Save()
			Case "save_and_close"
				Save()
				Project.CloseWindow( Self )
			Case "close"
				Project.CloseWindow( Self )
			Case "save_and_end"
				Save()
				Project.Exiting = True
			Case "end"
				Project.Exiting = True
		End Select
		
		Local Name:String = Gadget.GetParameter( "window" )
		If Name Then
			Project.LoadWindow( World, Name ) 
		Else
			Local Class:String = Gadget.GetParameter( "windowclass" )
			If Class Then Project.LoadWindow( World, , Class ) 
		End If
	End Method
	
	
	
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	Method OnButtonDown( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	Method OnButtonUp( Gadget:LTGadget, ButtonAction:LTButtonAction )
	End Method
	
	Method OnMouseOver( Gadget:LTGadget )
	End Method
	
	Method OnMouseOut( Gadget:LTGadget )
	End Method
	
	Method Save()
	End Method
End Type