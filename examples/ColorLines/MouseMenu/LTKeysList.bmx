'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentButtonAction:LTButtonAction

Type LTKeysList Extends LTListBox
	Method Init()
		Super.Init()
		ItemSize = 0.3
		Items = L_CurrentProfile.Keys
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		Sprite.Visualizer.SetColorFromRGB( 0.0, 0.0, 0.0 )
		Sprite.Visualizer.Alpha = 0.1 + 0.1 * ( Num Mod 2 )
		Sprite.Draw()
		
		SetColor( 0, 0, 0 )
		Local ButtonAction:LTButtonAction = LTButtonAction( Item )
		Sprite.PrintText( LocalizeString( "{{" + ButtonAction.Name + "}}" ), LTAlign.ToLeft, , 0.25 )
		Sprite.PrintText( LocalizeString( ButtonAction.GetButtonNames( True ) ), LTAlign.ToRight, , -0.25 )
		LTVisualizer.ResetColor()
	End Method
	
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
		L_CurrentButtonAction = LTButtonAction( Item )
		If ButtonAction = L_LeftMouseButton Then
			Menu.Project.LoadWindow( Menu.World, , "LTKeyWindow" )
		ElseIf ButtonAction = L_RightMouseButton Then	
			L_CurrentButtonAction.Clear()
		End If
	End Method
End Type