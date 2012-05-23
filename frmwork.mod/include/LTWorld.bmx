'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTEditorData.bmx"

Rem
bbdoc: World is the root layer which can be created in the editor and loaded from file.
about: 
End Rem
Type LTWorld Extends LTLayer
	Field Camera:LTCamera
	
	
	
	Rem
	bbdoc: Loads a world from file.
	returns: Loaded world.
	about: See also: #Parallax example
	End Rem
	Function FromFile:LTWorld( Filename:String )
		Return LTWorld( LoadFromFile( Filename ) )
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		If L_EditorData Then
			L_EditorData = LTEditorData( XMLObject.ManageObjectField( "editor_data", L_EditorData ) )
			If XMLObject.FieldExists( "images" ) Then
				XMLObject.ManageIntAttribute( "incbin", L_EditorData.IncbinValue )
				XMLObject.ManageListField( "images", L_EditorData.Images )
				XMLObject.ManageListField( "tilesets", L_EditorData.Tilesets )
			End If
		End If
		
		Camera = LTCamera( XMLObject.ManageObjectField( "camera", Camera ) )
	End Method
End Type