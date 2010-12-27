'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSpriteType Extends LTObject
	Field Shape:Int
	Field Name:String
	Field Image:LTImage
	Field ImageVisualizer:LTImageVisualizer
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
	
		XMLObject.ManageIntAttribute( "shape", Shape )
		XMLObject.ManageStringAttribute( "typename", Name )
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
		
		If L_XMLMode = L_XMLGet Then
			ImageVisualizer = New LTImageVisualizer
			ImageVisualizer.Image = Image
		End If
	End Method
End Type