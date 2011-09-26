'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTCheckBox Extends LTButton
	Method GetValue:String()
		Return State
	End Method
	
	
	
	Method SetValue( Value:String )
		State = Value.ToInt()
	End Method	
	
	

	Method OnMouseDown( Button:Int )
		State = Not State
	End Method
	
	
	
	Method OnMouseUp( Button:Int )
	End Method
End Type