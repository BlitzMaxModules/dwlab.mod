'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTWorld Extends LTLayer
	Field Images:TList = New TList
	Field Tilesets:TList = New TList
	
	
	
	Function FromFile:LTWorld( Filename:String )
		Return LTWorld( L_LoadFromFile( Filename ) )
	End Function
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageListField( "images", Images )
		XMLObject.ManageListField( "tilesets", Tilesets )
	End Method
End Type