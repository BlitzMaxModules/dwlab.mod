'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTChannelPack.bmx"
Include "LTMusic.bmx"

Type LTSound Extends LTObject
	Field BMaxSound:TSound
	Field Filename:String
	
	
	
	Function FromFile:LTSound( Filename:String )
		Local Sound:LTSound = New LTSound
		Sound.Filename = Filename
		Sound.Init()
	End Function
	
	
	
	Method Init()
		BMaxSound = LoadSound( Filename )
	End Method
	
	
	
	Method Play()
		PlaySound( BMaxSound )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "filename", Filename )
		
		If L_XMLMode = L_XMLGet Then Init()
	End Method
End Type