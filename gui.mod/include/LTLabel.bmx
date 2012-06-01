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
	Field TextVisualizer:LTVisualizer = New LTVisualizer
	
	Field HAlign:Int = LTAlign.ToCenter
	Field VAlign:Int = LTAlign.ToCenter
	
	Field TextDX:Double, TextDY:Double
	
	
	
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
		If Name Then Icon = LTSprite( L_Window.FindShapeWithParameter( "gadget_name", GetName(), "", True ) )
		
		If Not Text Then Text = GetParameter( "text" )
		If Text Then
			If Not Icon Then Icon = LTSprite( L_Window.FindShapeWithParameter( "gadget_text", Text, "", True ) )
			Text = LocalizeString( "{{" + Text + "}}" )
		End If
		
		Select GetParameter( "text_h_align" )
			Case "left"
				HAlign = LTAlign.ToLeft
			Case "center"
				HAlign = LTAlign.ToCenter
			Case "right"
				HAlign = LTAlign.ToRight
		End Select
		Select GetParameter( "text_v_align" )
			Case "top"
				VAlign = LTAlign.ToTop
			Case "center"
				VAlign = LTAlign.ToCenter
			Case "bottom"
				VAlign = LTAlign.ToBottom
		End Select
		
		If ParameterExists( "text_color" ) Then
			TextVisualizer.SetColorFromHex( GetParameter( "text_color" ) )
		Else
			TextVisualizer.SetColorFromRGB( 0.0, 0.0, 0.0 )
		End If
		
		If ParameterExists( "text_shift" ) Then
			TextDX = GetParameter( "text_shift" ).ToDouble()
			TextDY = TextDX
		End If

		TextDX = GetParameter( "text_dx" ).ToDouble()
		TextDY = GetParameter( "text_dy" ).ToDouble()
		
		If Icon Then
			IconDX = Icon.X - X
			IconDY = Icon.Y - Y
			L_Window.Remove( Icon )
		End If
	End Method
	
	
	
	Method Draw()
		If Not Visible Then Return
		Super.Draw()
		
		If Icon Then
			Icon.X = X + IconDX + GetDX()
			Icon.Y = Y + IconDY + GetDY()
			Icon.Draw()
		End If
		
		TextVisualizer.ApplyColor()
		Local Chunks:String[] = Text.Split( "|" )
		Local ChunkY:Double = GetDY() - 0.5 * ( Chunks.Dimensions()[ 0 ] - 1 ) * TextSize
		For Local Chunk:String = Eachin Chunks
			PrintText( Chunk, TextSize, HAlign, VAlign, TextDX + GetDX(), TextDY + ChunkY )
			ChunkY :+ TextSize
		Next
		TextVisualizer.ResetColor()
	End Method
	
	Method GetDX:Double()
		Return 0
	End Method
	
	Method GetDY:Double()
		Return 0
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