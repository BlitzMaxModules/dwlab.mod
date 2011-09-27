'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTListBox Extends LTGadget
	Field InnerArea:LTShape
	Field Items:TList = New TList
	Field ListType:Int = Vertical
	
	
	
	Method Init()
	End Method
	
	
	
	Method Draw()
	End Method
	
	
	
	Method GetClassTitle:String()
		Return "List box"
	End Method
	
	
	Method Act()
		
	End Method
End Type