'
' PauseText - Digital Wizard's Lab template
' Copyright (C) 2011, Dmitry Volokitin
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPauseText Extends LTPause
	
	Field Initialized:Int
	Field x:Int, y:Int
	Field text:String 
	Field r%, g%, b%
	
	Method Init()
		r = 255; g = 0; b = 0
		text = "Pause"
		x = (GraphicsWidth() - TextWidth(text) ) / 2 
		y = (GraphicsHeight() - TextHeight(text) ) / 2 
		Initialized = True
	End Method
	
	Method update()
		CheckKey()
	End Method
	
	Method render()
		If Not Initialized Then Init()
		SetColor(0,0,0)
		SetAlpha(0.5)
		DrawRect(0,0,GraphicsWidth(),GraphicsHeight())
		SetColor(r,g,b)
		SetAlpha(1.0)
		DrawText(text, x, y)
	End Method
End Type