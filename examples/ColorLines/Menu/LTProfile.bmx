'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTProfile Extends LTObject
	Field Name:String
	Field AudioDriver:LTAudioDriver
	Field VideoDriver:LTVideoDriver
	Field VideoMode:LTVideoMode
End Type



Type LTVideoDriver Extends LTTextListItem
	Field Driver:TGraphicsDriver
	
	Method GetValue:String()
		Return Driver.ToString()
	End Method
End Type



Type LTAudioDriver Extends LTTextListItem
	Field Driver:TAudioDriver
	
	Method GetValue:String()
		Return Driver.ToString()
	End Method
End Type



Type LTVideoMode Extends LTTextListItem
	Field Width:Int
	Field Height:Int
	
	Method GetValue:String()
		Return Width + " x " + Height
	End Method
End Type



Type LTLanguage Extends LTTextListItem
	Field Name:String
	Field Handle:
End Type