'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Class for list box gadget.
End Rem
Type LTListBox Extends LTGadget
	Rem
	bbdoc: List type.
	about: Can be Vertical or Horizontal.
	End Rem
	Field ListType:Int = Vertical
	
	Rem
	bbdoc: List which contains list box items.
	End Rem
	Field Items:TList
	
	Rem
	bbdoc: List item size.
	about: Height for vertical lists, width for horizontal lists in units.
	End Rem
	Field ItemSize:Double = 1.0
	Field Shift:Double
	Field Slider:LTSLider
	
	
	Method GetClassTitle:String()
		Return "List box"
	End Method
	
	
	
	Method Init()
		Super.Init()
		If ParameterExists( "item-size" ) Then ItemSize = GetParameter( "item-size" ).ToDouble()
		Slider = LTSlider( L_Window.FindShapeWithParameter( "list_box_name", GetName(), , True ) )
	End Method
	
	
	
	Method Draw()
		If Not Visible Then Return
		Super.Draw()
		
		If Not Items Then Return
		Local Num:Int = 0
		SetAsViewport()
		For Local Item:Object = Eachin Items
			DrawItem( Item, Num, GetItemSprite( Num ) )
			Num :+ 1
		Next
		L_CurrentCamera.SetCameraViewport()
	End Method
	
	
	
	Method GetItemSprite:LTSprite( Num:Int )
		Local Sprite:LTSprite = New LTSprite
		If ListType = Vertical Then
			Sprite.SetSize( Width, ItemSize )
			Sprite.SetCornerCoords( LeftX(), TopY() + Num * ItemSize - Shift )
		Else
			Sprite.SetSize( ItemSize, Height )
			Sprite.SetCornerCoords( LeftX() + Num * ItemSize - Shift, TopY() )
		End If
		Return Sprite
	End Method
	
	
	
	Rem
	bbdoc: Method for drawing list box item.
	about: Fill this method with code which displays given item. You also can use its number in list and shape which it occupies in list box.
	End Rem
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
	End Method
	
	
	
	Method OnButtonPress( ButtonAction:LTButtonAction )
		If Not Items Then Return
		If ItemSize <= 0 Then Return
		Local Num:Int
		If ListType = Vertical Then
			Num = Floor( ( L_Cursor.Y - TopY() + Shift ) / ItemSize )
		Else
			Num = Floor( ( L_Cursor.X - LeftX() + Shift ) / ItemSize )
		End If
		If Num >= 0 And Num < Items.Count() Then OnButtonPressOnItem( ButtonAction, Items.ValueAtIndex( Num ), Num )
		
		Local DValue:Double = 0
		If ButtonAction = L_MouseWheelDown Then DValue = -1
		If ButtonAction = L_MouseWheelUp Then DValue = 1
		If DValue Then
			Local ListBoxSize:Double
			If ListType = Vertical Then
				ListBoxSize = Height
				DValue = -DValue
			Else
				ListBoxSize = Width
			End If
			Local MaxShift:Double = Max( 0.0, ItemSize * Items.Count() - ListBoxSize )
			Shift = L_LimitDouble( Shift + DValue * ItemSize, 0.0, MaxShift )
			If Slider And MaxShift > 0 Then Slider.Position = Shift / MaxShift
		End If
	End Method
	
	
	
	Rem
	bbdoc: Pressing button on list box item.
	about: Fill this method with code of reaction to user's button press on item (selection via click for example).
	End Rem
	Method OnButtonPressOnItem( ButtonAction:LTButtonAction, Item:Object, Num:Int )
	End Method
End Type