'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type LTGrid Extends LTActiveObject
	Field XSize:Float = 1.0
	Field YSize:Float = 1.0
	
	
	
	Method Draw()
		Local SX:Float, SY:Float
		SetColor( 0, 0, 0 )
		
		Local X:Float = Floor( L_CurrentCamera.CornerX() / XSize ) * XSize
		Local EndX:Float = L_CurrentCamera.CornerX() + L_CurrentCamera.XSize
		While X < EndX
			L_CurrentCamera.FieldToScreen( X, 0, SX, SY )
			DrawLine( SX, 0, SX, GraphicsHeight() )
			X :+ XSize
		WEnd
		
		Local Y:Float = Floor( L_CurrentCamera.CornerY() / YSize ) * YSize
		Local EndY:Float = L_CurrentCamera.CornerY() + L_CurrentCamera.YSize
		While Y < EndY
			L_CurrentCamera.FieldToScreen( 0, Y, SX, SY )
			DrawLine( 0, SY, GraphicsWidth(), SY )
			Y :+ YSize
		WEnd
		
		SetColor( 255, 255, 255 )
	End Method
	
	
	
	Method Snap( X:Float Var, Y:Float Var )
		If MenuChecked( Editor.SnapToGrid ) Then
			X = Round( X / XSize ) * XSize
			Y = Round( Y / YSize ) * YSize
		End If
	End method
End Type