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
		Visualizer = Null
		Super.XMLIO( XMLObject )
		
		SpriteType = LTSpriteType( XMLObject.ManageObjectAttribute( "type", SpriteType ) )
		Visualizer = SpriteType.ImageVisualizer
		Shape = SpriteType.Shape
	
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
		XMLObject.ManageFloatAttribute( "xsize", XSize, 1.0 )
		XMLObject.ManageFloatAttribute( "ysize", YSize, 1.0 )
		XMLObject.ManageFloatAttribute( "angle", Angle )
		XMLObject.ManageFloatAttribute( "velocity", Velocity )
		XMLObject.ManageIntAttribute( "frame", Frame )
	
	End Method
End Type