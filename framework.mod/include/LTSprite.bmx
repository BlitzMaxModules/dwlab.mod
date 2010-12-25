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

Type LTSprite Extends LTActor
	Field SpriteType:LTSpriteType
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
	
		SpriteType = LTSpriteType( XMLObject.ManageObjectAttribute( "type", SpriteType ) )
		
		If L_XMLMode = L_XMLGet Then
			Shape = SpriteType.Shape
			
			If L_LoadImages Then
				Local NewVisualizer:LTImageVisualizer = New LTImageVisualizer
				NewVisualizer.Image = SpriteType
				Visualizer = NewVisualizer
			End If
		End If
	End Method
End Type