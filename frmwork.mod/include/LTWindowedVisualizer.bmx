'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTWindowedVisualizer Extends LTVisualizer
	Field Viewport:LTShape
	Field Visualizer:LTVisualizer
	
	
	
	Method GetImage:LTImage()
		Return Visualizer.GetImage()
	End Method
	
	
	
	Method SetImage( NewImage:LTImage )
		Visualizer.SetImage( NewImage )
	End Method
	
	
	
	Method DrawUsingSprite( Sprite:LTSprite )
		Local X:Int, Y:Int, Width:Int, Height:Int
		GetViewport( X, Y, Width, Height )
		
		Local VX:Float, VY:Float, VWidth:Float, VHeight:Float
		L_CurrentCamera.FieldToScreen( Viewport.LeftX(), Viewport.TopY(), VX, VY )
		L_CurrentCamera.SizeFieldToScreen( Viewport.Width, Viewport.Height, VWidth, VHeight )
		SetViewport( VX, VY, VWidth, VHeight )
		Visualizer.DrawUsingSprite( Sprite )
		
		SetViewport( X, Y, Width, Height )
	End Method
End Type