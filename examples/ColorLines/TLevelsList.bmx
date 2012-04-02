'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TLevelsList Extends LTListBox
	Field Speed:Double
	
	Field SelectedLevel:Object
	
	Method Init()
		Super.Init()
		ItemSize = 0.4
		Items = New TList
		For Local Layer:LTLayer = Eachin Game.World
			If Layer.GetName().StartsWith( "Level" ) Then Items.AddLast( Layer )
		Next
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		Sprite.Visualizer.SetColorFromRGB( 0.0, 0.0, 0.0 )
		If Item = SelectedLevel Then 
			Sprite.Visualizer.Alpha = 0.2
			Sprite.Draw()
		End If
		SetColor( 0, 0, 0 )
		Sprite.PrintText( LocalizeString( LTShape( Item ).GetName() ) )
		LTVisualizer.ResetColor()
	End Method
	
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
		If ButtonAction <> L_LeftMouseButton Then Return
		SelectedLevel = Item
	End Method
End Type