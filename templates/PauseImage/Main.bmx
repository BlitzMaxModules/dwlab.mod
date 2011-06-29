'
' PauseImage - Digital Wizard's Lab template
' Copyright (C) 2011, Dmitry Volokitin
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPauseImage Extends LTPause

	Field Initialized:Int
	Field x:Int, y:Int
	Field image:TImage
	Field r%=255, g%=0, b%=0
	
	Method Init()
		SetMaskColor(224,0,128)
		image = LoadImage( "PauseImage\PauseImage.png", MASKEDIMAGE)
		If Not Image Then L_Error( "can't find image" )
		MidHandleImage( image )
		x = GraphicsWidth() * 0.5
		y = GraphicsHeight() * 0.5
		Initialized = True
	End Method
	
	Method update:Int()
		CheckKey()
	End Method

	Method render()
		If Not Initialized Then Init()
		SetColor(0,0,0)
		SetAlpha(0.5)
		DrawRect(0,0,GraphicsWidth(),GraphicsHeight())
		SetColor(r,g,b)
		SetAlpha(1.0)
		DrawImage(image,x,y)
	End Method
End Type