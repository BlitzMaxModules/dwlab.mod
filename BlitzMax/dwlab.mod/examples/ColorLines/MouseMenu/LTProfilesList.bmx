'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTProfilesList Extends LTMenuListBox
	Method Init()
		Super.Init()
		Items = Menu.Profiles
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		SetItemColor( Num, Sprite, Item = Menu.SelectedProfile )
		Sprite.Draw()
		SetColor( 0, 0, 0 )
		Sprite.PrintText( LocalizeString( LTProfile( Item ).Name ), TextSize )
		LTColor.ResetColor()
	End Method
	
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
		If ButtonAction <> L_LeftMouseButton Then Return
		Menu.SelectedProfile = LTProfile( Item )
	End Method
End Type