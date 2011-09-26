'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTComboBox Extends LTTextField
	Field ListBox:LTListBox
	Field Slider:LTSlider
	Field MaxHeight:Double
	
	
	
	Method Init()
		Local Name:String = GetName()
		If Name Then
			ListBox = LTListBox( L_Window.FindShapeWithType( "LTListBox", Name, True ) )
			Slider = LTSlider( L_Window.FindShapeWithType( "LTSlider", Name, True ) )
		End If
		MaxHeight = GetParameter( "max_height" ).ToDouble()
	End Method
	
	
	
	Method Expand()
		If ListBox Then
			ListBox.Visible = True
			ListBox.Height = 1
			L_LimitDouble( ListBox.Height, 0.0, MaxHeight )
			
			If Slider Then
				Slider.Visible = True
				Slider.Slider.Visible = True
				Slider.Height = ListBox.Height
				'Slider.Init( ListBox )
			End If
		End If
	End Method
	
	
	
	Method Collapse()
		If ListBox Then ListBox.Visible = False
		If Slider Then
			Slider.Visible = False
			Slider.Slider.Visible = False
		End If
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
	End Method
End Type