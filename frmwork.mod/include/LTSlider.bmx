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
	Field Slider:LTShape
	Field Position:Double
	Field SliderType:Int 
	Field Size:Double = 1.0
	Field Dragging:Int
	Field StartingX:Double
	Field StartingY:Double
	Field StartingPosition:Double

	
	
	Method Init()
		Local Name:String = GetName()
		If GetParameter( "type" ) = "vertical" Then SliderType = Vertical Else SliderType = Horizontal
		If Name Then
			Local Shape:LTShape = L_Window.FindShapeWithType( "LTSprite", Name, True )
			If Shape Then Slider = Shape
		End If
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		If Slider Then
			Select SliderType
				Case Vertical
					Slider.SetSize( Width, Height * Size )
					Slider.SetCoords( X, Y + ( Position - 0.5 ) * ( Height - Slider.Height ) )
				Case Horizontal
					Slider.SetSize( Width * Size, Height )
					Slider.SetCoords( X + ( Position - 0.5 ) * ( Width - Slider.Width ), Y )
			End Select
			Slider.Draw()
		End If
	End Method
	
	
	
	Method Act()
		If Dragging And Size < 1 Then
			Select SliderType
				Case Horizontal
					Position = L_LimitDouble( StartingPosition + ( L_Cursor.X - StartingX ) * Height * ( 1.0 - Size ), 0.0, 1.0 )
				Case Vertical
					Position = L_LimitDouble( StartingPosition + ( L_Cursor.Y - StartingY ) * Width * ( 1.0 - Size ), 0.0, 1.0 )
			End Select
		End If
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
		If Button = 1 Then
			Dragging = True
			StartingX = L_Cursor.X
			StartingY = L_Cursor.Y
			StartingPosition = Position
		End If
	EndMethod
	
	
	
	Method OnMouseUp( Button:Int )
		If Button = 1 Then Dragging = False
	EndMethod
End Type