'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTListBox Extends LTGadget
	Field Shift:Double
	
	
	
	Method GetClassTitle:String()
		Return "List box"
	End Method
	
	
	
	Method GetListType:Int()
		Return Vertical
	End Method
	
	
	
	Method GetItems:TList()
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		Local Items:TList = GetItems()
		If Not Items Then Return
		Local Num:Int = 0
		
		For Local Item:Object = Eachin Items
			DrawItem( Item, Num, GetItemSprite( Num ) )
			Num :+ 1
		Next
	End Method
	
	
	
	Method GetItemSprite:LTSprite( Num:Int )
		Local Sprite:LTSprite = New LTSprite
		If GetListType() = Vertical Then
			Sprite.SetSize( Width, GetItemSize() )
			Sprite.SetCornerCoords( LeftX(), TopY() + Num * GetItemSize() - Shift )
		Else
			Sprite.SetSize( GetItemSize(), Height )
			Sprite.SetCornerCoords( LeftX() + Num * GetItemSize() - Shift, TopY() )
		End If
		Return Sprite
	End Method
	
	
	
	Method GetItemSize:Double()
	End Method
	
	
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
	End Method
	
	
	
	Method OnClick( Button:Int )
		Local Items:TList = GetItems()
		If Not Items Then Return
		Local Num:Int
		If GetListType() = Vertical Then
			Num = Floor( ( L_Cursor.Y - TopY() ) / GetItemSize() )
		Else
			Num = Floor( ( L_Cursor.X - LeftX() ) / GetItemSize() )
		End If
		If Num < Items.Count() Then OnClickOnItem( Button, Items.ValueAtIndex( Num ), Num )
	End Method
	
	
	
	Method OnClickOnItem( Button:Int, Item:Object, Num:Int )
	End Method
End Type