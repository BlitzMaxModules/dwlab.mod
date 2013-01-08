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
	Field Icon:LTSprite, IconDX:Double, IconDY:Double
	
	Rem
	bbdoc: Visualizer for button text.
	End Rem	
	Field TextColor:LTColor = LTColor.FromHex( "000000" )
	Field OnMouseOverTextColor:LTColor
	
	Field HAlign:Int = LTAlign.ToCenter
	Field VAlign:Int = LTAlign.ToCenter
	
	Field TextHMargin:Double, TextVMargin:Double
	
	Rem
	bbdoc: Focus of label
	about: Focus is changed to True when mouse cursor is over the label.
	End Rem
	Field Focus:Int

	
	
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
		Super.Init()
	
		Local Name:String = GetName()
		If Name Then Icon = LTSprite( L_Window.FindShapeWithParameter( "gadget-name", GetName(), "", True ) )
		
		If Not Text Then Text = GetParameter( "text" )
		If Text Then
			If Not Icon Then Icon = LTSprite( L_Window.FindShapeWithParameter( "gadget-text", Text, "", True ) )
			Text = LocalizeString( "{{" + Text + "}}" )
		End If
		
		Select GetParameter( "text-h-align" )
			Case "left"
				HAlign = LTAlign.ToLeft
			Case "right"
				HAlign = LTAlign.ToRight
			Default
				HAlign = LTAlign.ToCenter
		End Select
		
		Select GetParameter( "text-v-align" )
			Case "top"
				VAlign = LTAlign.ToTop
			Case "bottom"
				VAlign = LTAlign.ToBottom
			Default
				VAlign = LTAlign.ToCenter
		End Select
		
		If ParameterExists( "text-margin" ) Then
			TextHMargin = GetParameter( "text-margin" ).ToDouble()
			TextVMargin = TextHMargin
		Else
			TextHMargin = GetParameter( "text-h-margin" ).ToDouble()
			TextVMargin = GetParameter( "text-v-margin" ).ToDouble()
		End If
			
		If ParameterExists( "text-color" ) Then TextColor.SetColorFromHex( GetParameter( "text-color" ) )
		
		If Icon Then
			IconDX = Icon.X - X
			IconDY = Icon.Y - Y
			L_Window.Remove( Icon )
		End If
	End Method
	
	
	
	Method Draw( DrawingAlpha:Double = 1.0 )
		If Not Visible Then Return
		Super.Draw( DrawingAlpha )
		
		If Icon Then
			Icon.X = X + IconDX + GetDX()
			Icon.Y = Y + IconDY + GetDY()
			Icon.Draw()
		End If
		
		TextColor.ApplyColor( DrawingAlpha )
		PrintText( Text, TextSize, HAlign, VAlign, TextHMargin, TextVMargin, GetDX(), GetDY() )
		LTColor.ResetColor()
	End Method
	
	Method GetDX:Double()
		Return 0
	End Method
	
	Method GetDY:Double()
		Return 0
	End Method

	
	
	Method OnMouseOver()
		Focus = True
	End Method
	
	
	
	Method OnMouseOut()
		Focus = False
	End Method
	
	
	
	Rem
	bbdoc: Activates the label and also restores visualizer parameters.
	End Rem	
	Method Activate()
		Active = True
		Visualizer.Alpha = 1.0
		If Icon Then Icon.Visualizer.Alpha = 1.0
		TextColor.Alpha = 1.0
	End Method
	
	
	
	Rem
	bbdoc: Deactivates the label and also makes it half-transparent.
	End Rem	
	Method Deactivate()
		Active = False
		Visualizer.Alpha = 0.5
		If Icon Then Icon.Visualizer.Alpha = 0.5
		TextColor.Alpha = 0.5
	End Method
End Type