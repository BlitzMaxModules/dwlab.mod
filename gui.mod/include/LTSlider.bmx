'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSlider Extends LTGadget
	Const Moving:Int = 0
	Const Filling:Int = 1
	
	Field ListBox:LTListBox
	Field Slider:LTShape
	Field Position:Double
	Field SliderType:Int 
	Field SelectionType:Int
	Field Size:Double = 1.0
	Field Dragging:Int
	Field StartingX:Double
	Field StartingY:Double
	Field StartingPosition:Double
	Field ListBoxSize:Double
	Field ContentsSize:Double
	
	
	
	Method GetClassTitle:String()
		Return "Slider"
	End Method

	
	
	Method Init()
		Local Name:String = GetName()
		If Name Then
			Slider = L_Window.FindShapeWithParameter( "slider_name", Name, "", True )
			ListBox = LTListBox( L_Window.FindShape( GetParameter( "list_box_name" ), True ) )
			'debugstop
			If Slider Then L_Window.Remove( Slider )
		End If
		If GetParameter( "type" ) = "vertical" Then SliderType = Vertical Else SliderType = Horizontal
		If GetParameter( "selection" ) = "filling" Then SelectionType = Filling Else SelectionType = Moving
	End Method
	
	
	
	Method Draw()
		If Not Visible Then Return
		Super.Draw()
		If Slider Then
			Select SliderType
				Case Horizontal
					Slider.SetCornerCoords( LeftX() + Width * Position * ( 1.0 - Size ), TopY() )
					Slider.SetWidth( Width * Size )
				Case Vertical
					Slider.SetCornerCoords( LeftX(), TopY() + Height * Position * ( 1.0 - Size ) )
					Slider.SetHeight( Height * Size )
			End Select
			Slider.Draw()
		End If
	End Method
	
	
	
	Method Act()
		Super.Act()
		If ListBox Then
			If ListBox.Items Then
				ContentsSize = ListBox.ItemSize * ListBox.Items.Count()
				If ContentsSize > 0 
					Select ListBox.ListType
						Case Horizontal
							ListBoxSize = ListBox.Width
						Case Vertical
							ListBoxSize = ListBox.Height
					End Select
					Size = ListBoxSize / ContentsSize
					If Size > 1.0 Then Size = 1.0
				End If
			End If
		End If
	End Method
	
	
	
	Method OnButtonDown( ButtonAction:LTButtonAction )
		If ButtonAction <> L_ClickButton Then Return
		Select SelectionType
			Case Moving
				If Dragging Then
					Select SliderType
						Case Horizontal
							Position = L_LimitDouble( StartingPosition + ( L_Cursor.X - StartingX ) / Width / ( 1.0 - Size ), 0.0, 1.0 )
						Case Vertical
							Position = L_LimitDouble( StartingPosition + ( L_Cursor.Y - StartingY ) / Height / ( 1.0 - Size ), 0.0, 1.0 )
					End Select
					
					If ListBox Then ListBox.Shift = Position * ( ContentsSize - ListBoxSize )'; DebugLog ContentsSize + "," + ListBoxSize + "," + ListBox.Shift
				Else
					Dragging = True
					StartingX = L_Cursor.X
					StartingY = L_Cursor.Y
					StartingPosition = Position
				End If
			Case Filling
				Position = 0.0
				Select SliderType
					Case Horizontal
						Size = L_LimitDouble( ( L_Cursor.X - LeftX() ) / Width, 0.0, 1.0 )
					Case Vertical
						Size = L_LimitDouble( ( L_Cursor.Y - TopY() ) / Height, 0.0, 1.0 )
				End Select
		End Select
	EndMethod
	
	
	
	Method OnButtonUnpress( ButtonAction:LTButtonAction )
		If ButtonAction <> L_ClickButton Then Return
		Dragging = False
	EndMethod
End Type