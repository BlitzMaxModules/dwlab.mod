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
	Field Align:Int = LTAlign.ToCenter
	
	
	
	Method GetClassTitle:String()
		Return "Label"
	End Method
	
	
	
	Method Init()
		If Not Text Then Text = GetParameter( "text" )
		If Text Then
			Icon = L_Window.FindShapeWithParameter( "LTSprite", "gadget", Text, True )
			If Icon Then L_Window.Remove( Icon )
			Text = LocalizeString( "{{" + Text + "}}" )
			Select GetParameter( "align" )
				Case "left"; Align = LTAlign.ToLeft
				Case "center"; Align = LTAlign.ToCenter
				Case "right"; Align = LTAlign.ToRight
			End Select
		End If
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		
		Local SWidth:Double = TextWidth( " " + Text )
		Local TextX:Double, TextSDX:Double
		If Icon Then
			L_CurrentCamera.SizeScreenToField( DX, DY, Icon.X, Icon.Y )
			Select Align
				Case LTAlign.ToLeft
					Icon.AlterCoords( LeftX() + 0.5 * Height, Y )
				Case LTAlign.ToCenter
					Icon.AlterCoords( X - L_CurrentCamera.DistScreenToField( 0.5 * SWidth ), Y )
				Case LTAlign.ToCenter
					Icon.AlterCoords( RightX() - L_CurrentCamera.DistScreenToField( SWidth ) - 0.5 * Height + DX, Y )
			End Select
			TextX = Icon.X + 0.5 * Icon.Width
			Icon.Draw()
		Else
			Select Align
				Case LTAlign.ToLeft
					TextX = LeftX()
					TextSDX = TextWidth( " " ) + DX
				Case LTAlign.ToCenter
					TextX = X
					TextSDX = -0.5 * SWidth + DX
				Case LTAlign.ToRight
					TextX = RightX()
					TextSDX = -SWidth - TextWidth( " " ) + DX
			End Select
		End If
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( TextX, Y, SX, SY )
		SetColor( 0, 0, 0 )
		DrawText( " " + Text, SX + TextSDX, SY - 0.5 * TextHeight( Text ) + DY )
		Visualizer.ResetColor()
	End Method
End Type