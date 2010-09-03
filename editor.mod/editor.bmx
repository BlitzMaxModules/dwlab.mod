'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global Editor:LTEditor = New LTEditor
Editor.Execute()

Type LTEditor Extends LTProject
	Field Window:TGadget
	Field Canvas:TGadget
	Field Resources:TGadget
	
	
	
	Method Init()
		Window = CreateWindow( "Digital Wizard's Lab Editor", 10, 10, 800, 600 )
		
		Resources = CreateTreeView( 0, 0, 250, 523, Window )
		Canvas = CreateCanvas( 250, 0, 780, 523, Window )
		SetGraphics( CanvasGraphics( Canvas ) )
		
		
	End Method
	
	
	
	Method Logic()
	End Method
End Type