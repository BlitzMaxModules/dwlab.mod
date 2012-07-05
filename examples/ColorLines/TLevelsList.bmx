'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TLevelsList Extends LTMenuListBox
	Field Speed:Double
	
	Field SelectedLevel:Object
	
	Method Init()
		Super.Init()
		Items = New TList
		For Local Layer:LTLayer = Eachin Game.Levels
			If Layer.GetName().StartsWith( "Level" ) Then Items.AddLast( Layer )
		Next
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		SetItemColor( Num, Sprite, Item = SelectedLevel )
		Sprite.Draw()
		
		SetColor( 0, 0, 0 )
		Sprite.PrintText( LocalizeString( LTShape( Item ).GetName() ), TextSize )
		LTVisualizer.ResetColor()
	End Method
	
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
		If ButtonAction <> L_LeftMouseButton Then Return
		SelectedLevel = Item
	End Method
End Type