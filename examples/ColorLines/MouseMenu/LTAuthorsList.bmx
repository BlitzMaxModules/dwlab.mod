'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAuthorsList Extends LTListBox
	Field Speed:Double
	
	Method Init()
		Super.Init()
		ItemSize = 0.5
		Items = TList.FromArray( LocalizeString( "{{AuthorsList}}" ).Split( "|" ) )
		Shift = -Height
		Speed = GetParameter( "speed" ).ToDouble()
	End Method
	
	Method Act()
		Super.Act()
		Shift :+ Menu.Project.PerSecond( Speed )
		If Shift > ItemSize * Items.Count() Then Shift = -Height
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		SetColor( 0, 0, 0 )
		Local Line:String = String( Item )
		Sprite.PrintText( LocalizeString( Line ), TextSize )
		LTVisualizer.ResetColor()
	End Method
End Type