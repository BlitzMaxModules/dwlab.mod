'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLabel Extends LTGadget
	Method GetClassTitle:String()
		Return "Label"
	End Method
	
	
	
	Method Draw()
		Super.Draw()
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		Local Caption:String = GetParameter( "caption" )
		If Caption Then Caption = LocalizeString( "{{B_" + Caption + "}}" )
		SetColor( 0, 0, 0 )
		DrawText( Caption, SX - Len( Caption ) * 4, SY - 8 )
		Visualizer.ResetColor()
	End Method
End Type