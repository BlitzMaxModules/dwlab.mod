'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTButton Extends LTGadget
	Method Draw()
		Super.Draw()
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		Local Name:String = LocalizeString( "{{B_" + GetParameter( "name" ) + "}}" )
		DrawText( Name, SX - Len( Name ) * 4, SY - 8 )
	End Method

	
	
	Method OnMouseOver()
		if Visualizer.Image.FramesQuantity() >= 2 Then Frame = 2 Else Frame = 0
	End Method
	
	
	
	Method OnMouseOut()
		Frame = 0
	End Method
	
	
	
	Method OnMouseDown( Button:Int )
		if Visualizer.Image.FramesQuantity() >= 3 Then
			Frame = 3
		Elseif Visualizer.Image.FramesQuantity() >= 1 Then
			Frame = 1
		End If
	End Method
	
	
	
	Method OnMouseUp()
		if Visualizer.Image.FramesQuantity() >= 2 Then Frame = 2 Else Frame = 0
	End Method
End Type