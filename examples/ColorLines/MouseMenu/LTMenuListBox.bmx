'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMenuListBox Extends LTListBox
	Field Color1:LTColor = LTColor.FromHex( "7FFFFFFF" )
	Field Color2:LTColor = LTColor.FromHex( "7FCFCFCF" )
	Field SelectedColor:LTColor = LTColor.FromHex( "7F7F7F7F" )
	Field SelectedUnderMouseColor:LTColor = LTColor.FromHex( "7F9F9F9F" )
	Field MouseCursorColor:LTColor = LTColor.FromHex( "7FAFAFAF" )
	
	Method Init()
		Super.Init()
		If ParameterExists( "color_1" ) Then Color1 = LTColor.FromHex( GetParameter( "color_1" ) )
		If ParameterExists( "color_2" ) Then Color2 = LTColor.FromHex( GetParameter( "color_2" ) )
		If ParameterExists( "selected_color" ) Then SelectedColor = LTColor.FromHex( GetParameter( "selected_color" ) )
		If ParameterExists( "selected_under_mouse_cursor_color" ) Then ..
				SelectedUnderMouseColor = LTColor.FromHex( GetParameter( "selected_under_mouse_cursor_color" ) )
		If ParameterExists( "mouse_cursor_color" ) Then MouseCursorColor = LTColor.FromHex( GetParameter( "mouse_cursor_color" ) )
	End Method
	
	Method SetItemColor( Num:Int, Sprite:LTSprite, IsSelected:Int = False, ShowMouseCursor:Int = True )
		If Sprite.CollidesWithSprite( L_Cursor ) And ShowMouseCursor Then
			If IsSelected Then
				SelectedUnderMouseColor.CopyColorTo( Sprite.Visualizer )
			Else
				MouseCursorColor.CopyColorTo( Sprite.Visualizer )
			End If
		Else If IsSelected Then
			SelectedColor.CopyColorTo( Sprite.Visualizer )
		Else If Num Mod 2 Then
			Color2.CopyColorTo( Sprite.Visualizer )
		Else
			Color1.CopyColorTo( Sprite.Visualizer )
		End If
	End Method
End Type