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
bbdoc: Class for slider gadget.
about: Sliders can act as scroll bars, volume selection bars, progress bars, etc.
End Rem
Type LTSlider Extends LTGadget
	Rem
	bbdoc: Constant for moving behavior of slider (for scroll bars).
	End Rem
	Const Moving:Int = 0
	
	Rem
	bbdoc: Constant for filling behavior of slider (for progress bars).
	End Rem
	Const Filling:Int = 1
	
	Rem
	bbdoc: Position of the moving part on the slider field ( 0.0 - 1.0 ).
	End Rem
	Field Position:Double
	
	Rem
	bbdoc: Size of the moving part relative to slider field ( 0.0 - 1.0 ).
	End Rem
	Field Size:Double = 1.0
	
	Rem
	bbdoc: Type of the slider - Vertical or Horizontal.
	End Rem
	Field SliderType:Int 
	
	Rem
	bbdoc: Slider behavior - Moving or Filling.
	End Rem
	Field SelectionType:Int
	
	Rem
	bbdoc: Value by which position will change if user roll mouse wheel button on slider.
	End Rem
	Field MouseWheelValue:Double = 0.1
	
	Field ListBox:LTListBox
	Field Slider:LTShape
	Field Dragging:Int
	Field StartingX:Double
	Field StartingY:Double
	Field StartingPosition:Double
	Field ListBoxSize:Double
	Field ContentsSize:Double
	Field ShowPercent:Int
	
	
	
	Method GetClassTitle:String()
		Return "Slider"
	End Method

	
	
	Rem
	bbdoc: Slider initialization method.
	about: You can set different slider properties using object parameters in editor:
	<ul><li>"type" - sets slider type ( "vertical" or "horizontal" )
	<li>"selection" - sets slider behavior ( "moving" or "filling" )</ul>
	<li>"percent" - sets showing slider position in percents </ul>
	You can also attach sprite (which should be inside same window) as slider moving part to the slider by naming silder and
	set "slider_name" parameter of the sprite to slider name.
	And you can attach a list box (which should be inside same window) to scroll its contents with the slider by naming list box and
	set "list_box_name" parameter of the slider to list box name.
		End Rem		
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
		If GetParameter( "percent" ) = "true" Then ShowPercent = True
	End Method
	
	
	
	Method Draw()
		If Not Visible Then Return
		Super.Draw()
		If Slider Then
			Select SliderType
				Case Horizontal
					Slider.SetWidth( Width * Size )
					Slider.SetCornerCoords( LeftX() + Width * Position * ( 1.0 - Size ), TopY() )
				Case Vertical
					Slider.SetHeight( Height * Size )
					Slider.SetCornerCoords( LeftX(), TopY() + Height * Position * ( 1.0 - Size ) )
			End Select
			Slider.Draw()
			If ShowPercent Then
				SetColor( 0, 0, 0 )
				Select SelectionType
					Case Moving
						PrintText( L_Round( 100 * Position ) + "%" )
					Case Filling
						PrintText( L_Round( 100 * Size ) + "%" )
				End Select
				SetColor( 255, 255, 255 )
			End If
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
		If ButtonAction = L_LeftMouseButton Then
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
		Else
			Local DValue:Double = 0
			If ButtonAction = L_MouseWheelDown Then DValue = -MouseWheelValue
			If ButtonAction = L_MouseWheelUp Then DValue = MouseWheelValue
			If DValue Then
				Select SelectionType
					Case Moving
						Position = L_LimitDouble( Size + DValue, 0.0, 1.0 )
					Case Filling
						Size = L_LimitDouble( Size + DValue, 0.0, 1.0 )
				End Select
			End If
		End If
	EndMethod
	
	
	
	Method OnButtonUnpress( ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		Dragging = False
	EndMethod
End Type