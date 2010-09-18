'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTList Extends LTObject
	Field List:TList = New TList
	
	
	
	Method Draw()
		For Local Obj:LTObject = Eachin List
			Obj.Draw()
		Next
	End Method
	
	
	
	Method Act()
		For Local Obj:LTObject = Eachin List
			Obj.Act()
		Next
	End Method
	
	
	
	Method AddLast:TLink( Obj:LTObject )
		Return List.AddLast( Obj )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageChildList( List )
	End Method
End Type