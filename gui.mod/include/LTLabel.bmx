'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTButton.bmx"

Type LTLabel Extends LTGadget
	Field Text:String
	Field Icon:LTShape
	Field TextVisualizer:LTVisualizer = New LTVisualizer
	Field DX:Double, DY:Double
	Field Align:Int = LTAlign.ToCenter
	
	
	
	Method GetClassTitle:String()
		Return "Label"
	End Method
	
	
	
	Method Init()
		Local Name:String = GetName()
		If Name Then Icon = L_Window.FindShapeWithParameter( "LTSprite", "gadget_name", GetName(), True )
		
		TextVisualizer.SetColorFromRGB( 0.0, 0.0, 0.0 )
		If Not Text Then Text = GetParameter( "text" )
		If Text Then
			If Not Icon Then Icon = L_Window.FindShapeWithParameter( "LTSprite", "gadget_text", Text, True )
			Text = LocalizeString( "{{" + Text + "}}" )
			Select GetParameter( "align" )
				Case "left"
					Align = LTAlign.ToLeft
				Case "center"
					Align = LTAlign.ToCenter
				Case "right"
					Align = LTAlign.ToRight
			End Select
		End If
		
		If Icon Then L_Window.Remove( Icon )
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		
		Local HorizontalShift:Double = 0
		If Icon Then
			L_CurrentCamera.SizeScreenToField( DX, DY, Icon.X, Icon.Y )
			Local FWidth:Double = L_CurrentCamera.DistScreenToField( TextWidth( " " + Text ) )
			Select Align
				Case LTAlign.ToLeft
					HorizontalShift = Height
					Icon.AlterCoords( LeftX() + 0.5 * Height, Y )
				Case LTAlign.ToCenter
					HorizontalShift = 0.5 * Icon.Width
					Icon.AlterCoords( X - 0.5 * FWidth, Y )
				Case LTAlign.ToRight
					HorizontalShift = -0.5 * ( Height - Icon.Height )
					Icon.AlterCoords( RightX() - FWidth - 0.5 * Height + DX, Y )
			End Select
			Icon.Draw()
		End If
		
		TextVisualizer.ApplyColor()
		PrintText( " " + Text, Align, , HorizontalShift + DX, DY )
		TextVisualizer.ResetColor()
	End Method
	
	
	
	Method Activate()
		Active = True
		Visualizer.Alpha = 1.0
		If Icon Then Icon.Visualizer.Alpha = 1.0
		TextVisualizer.Alpha = 1.0
	End Method
	
	
	
	Method Deactivate()
		Active = False
		Visualizer.Alpha = 0.5
		If Icon Then Icon.Visualizer.Alpha = 0.5
		TextVisualizer.Alpha = 0.5
	End Method
End Type