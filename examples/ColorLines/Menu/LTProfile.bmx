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
	Field Resolution:LTResolution
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



Type LTResolution Extends LTTextListItem
	Field Width:Int
	Field Height:Int
	Field ColorDepths:TList = New TList
	
	Method GetValue:String()
		Return Width + " x " + Height
	End Method
End Type



Type LTColorDepth Extends LTTextListItem
	Field Depth:Int
	Field Frequencies:TList = New TList
	
	Method GetValue:String()
		Return Depth + " bit"
	End Method
End Type



Type LTFrequency
	Field Frequency:Int
	
	Method GetValue:String()
		Return Frequency + " Hz"
	End Method
End Type



Type LTLanguage Extends LTTextListItem
	Field Name:String
	Field Handle:TMaxGUILanguage
	
	
	
	Function Create:LTLanguage( Name:String, FileName:String ) 
		Local Language:LTLanguage = New LTLanguage
		Language.Name = Name
		Language.Handle = LoadLanguage( FileName )
		Return Language
	End Function
	
	
	
	Method GetValue:String()
		Return Name
	End Method	
End Type