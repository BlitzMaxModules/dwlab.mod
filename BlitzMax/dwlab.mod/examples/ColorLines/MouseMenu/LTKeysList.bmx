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

Type LTKeysList Extends  LTMenuListBox
	Method Init()
		Super.Init()
		Items = L_CurrentProfile.Keys
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		SetItemColor( Num, Sprite )
		Sprite.Draw()
		
		SetColor( 0, 0, 0 )
		Local ButtonAction:LTButtonAction = LTButtonAction( Item )
		Sprite.PrintText( LocalizeString( "{{" + ButtonAction.Name + "}}" ), TextSize, LTAlign.ToLeft, , 0.25 )
		Sprite.PrintText( LocalizeString( ButtonAction.GetButtonNames( True ) ), TextSize, LTAlign.ToRight, , 0.25 )
		LTColor.ResetColor()
	End Method
	
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
		L_CurrentButtonAction = LTButtonAction( Item )
		If ButtonAction = L_LeftMouseButton Then
			Menu.Project.LoadWindow( Menu.Interface, "LTKeyWindow" )
		ElseIf ButtonAction = L_RightMouseButton Then	
			L_CurrentButtonAction.Clear()
		End If
	End Method
End Type