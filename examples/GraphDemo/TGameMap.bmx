'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGameMap Extends LTGraph
	Field PlayerPivot:LTSprite
	Field Events:TMap = New TMap
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		PlayerPivot = LTSprite( XMLObject.ManageObjectField( "player", PlayerPivot ) )
		'XMLObject.ManageObjectMapField( "events", Events )
	End Method
End Type