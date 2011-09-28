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
	Field DX:Int, DY:Int
	
	
	
	Method GetClassTitle:String()
		Return "Label"
	End Method
	
	
	
	Method Init()
		Text = GetParameter( "text" )
		If Text Then
			Icon = L_Window.FindShapeWithParameter( "LTSprite", "gadget", Text, True )
			If Icon Then L_Window.Remove( Icon )
			Text = LocalizeString( "{{B_" + Text + "}}" )
		End If
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		
		Local IconShift:Double = 0
		Local SWidth:Double = TextWidth( " " + Text )
		If Icon Then
			Icon.SetCoords( X - L_CurrentCamera.DistScreenToField( 0.5 * SWidth ), Y )
			IconShift = 0.5 * Icon.Width
			Icon.Draw()
		End If
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X + IconShift, Y, SX, SY )
		SetColor( 0, 0, 0 )
		DrawText( " " + Text, SX - SWidth * 0.5 + DX, SY - 0.5 * TextHeight( Text ) + DY )
		Visualizer.ResetColor()
	End Method
End Type