'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

include "LTPage.bmx"

Type LTWorld Extends LTObject
	Field Pages:TList = New TList
	Field SpriteTypes:TList = New TList
	
	
	
	Method FindPage:LTPage( PageName:String )
		For Local Page:LTPage = Eachin Pages
			If Page.Name = PageName Then Return Page
		Next
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageChildList( Pages )
	End Method
End Type