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

Rem
bbdoc: Class for label gadgets.
End Rem
Type LTLabel Extends LTGadget
	Field Text:String
	Field Icon:LTShape
	
	Rem
	bbdoc: Visualizer for button text.
	End Rem	
	Field TextVisualizer:LTVisualizer = New LTVisualizer
	
	Rem
	bbdoc: Horizontal and vertical shift of button contens.
	End Rem	
	Field DX:Double, DY:Double
	
	Field Align:Int = LTAlign.ToCenter
	
	
	
	Method GetClassTitle:String()
		Return "Label"
	End Method
	
	
	
	Rem
	bbdoc: Label initialization method.
	about: You can set different properties using object parameters in editor:
	<ul><li>"text" - sets button text
	<li>"align" - sets align of button contents ("left", "center" or "right")</ul>
	You can also set a name of the label and set "gadget_name" parameter to this name for any sprite inside window layer to load it as label icon.
	End Rem	
	Method Init()
		Local Name:String = GetName()
		If Name Then Icon = L_Window.FindShapeWithParameter( "gadget_name", GetName(), "", True )
		
		TextVisualizer.SetColorFromRGB( 0.0, 0.0, 0.0 )
		If Not Text Then Text = GetParameter( "text" )
		If Text Then
			If Not Icon Then Icon = L_Window.FindShapeWithParameter( "gadget_text", Text, "", True )
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
		If Not Visible Then Return
		Super.Draw()
		
		Local HorizontalShift:Double = 0
		If Icon Then
			Local FWidth:Double = L_CurrentCamera.DistScreenToField( TextWidth( " " + Text ) )
			Select Align
				Case LTAlign.ToLeft
					HorizontalShift = Height
					Icon.SetCoords( LeftX() + 0.5 * Height + DX, Y + DY )
				Case LTAlign.ToCenter
					HorizontalShift = 0.5 * Icon.Width
					Icon.SetCoords( X - 0.5 * FWidth + DX, Y + DY )
				Case LTAlign.ToRight
					HorizontalShift = -0.5 * ( Height - Icon.Height )
					Icon.SetCoords( RightX() - FWidth - 0.5 * Height + DX, Y + DY )
			End Select
			Icon.Draw()
		End If
		
		TextVisualizer.ApplyColor()
		PrintText( " " + Text, Align, , HorizontalShift + DX, DY )
		TextVisualizer.ResetColor()
	End Method
	
	
	
	Rem
	bbdoc: Activates the label and also restores visualizer parameters.
	End Rem	
	Method Activate()
		Active = True
		Visualizer.Alpha = 1.0
		If Icon Then Icon.Visualizer.Alpha = 1.0
		TextVisualizer.Alpha = 1.0
	End Method
	
	
	
	Rem
	bbdoc: Deactivates the label and also makes it half-transparent.
	End Rem	
	Method Deactivate()
		Active = False
		Visualizer.Alpha = 0.5
		If Icon Then Icon.Visualizer.Alpha = 0.5
		TextVisualizer.Alpha = 0.5
	End Method
End Type