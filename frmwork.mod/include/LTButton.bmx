'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTCheckBox.bmx"

Type LTButton Extends LTGadget
	Field Icon:LTShape
	Field State:Int
	Field Focus:Int

	
	
	Method Init()
		Local Name:String = GetName()
		If Name Then
			Icon = L_Window.FindShapeWithType( "LTSprite", Name, True )
			If Icon Then L_Window.Remove( Icon )
		End If
	End Method
	
	
	
	Method Draw()
		Select Visualizer.Image.FramesQuantity()
			Case 1; Frame = 0
			Case 2; Frame = State
			Case 4; Frame = State + Focus * 2
		End Select
		Super.Draw()
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		Local Caption:String = GetParameter( "caption" )
		If Caption Then Caption = LocalizeString( "{{B_" + Caption + "}}" )
		SetColor( 0, 0, 0 )
		DrawText( Caption, SX - Len( Caption ) * 4, SY - 8 )
		Visualizer.ResetColor()
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "Button"
	End Method

	
	
	Method OnMouseOver()
		Focus = True
	End Method
	
	
	
	Method OnMouseOut()
		Focus = False
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
		State = True
	End Method
	
	
	
	Method OnMouseUp( Button:Int )
		State = False
	End Method
End Type