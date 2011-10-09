'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Class for button gadgets.
about: Checkbox is the button which state changes anoter way: when user clicks checkbox first time, its state will be set to True.
When user clicks checkbox second time, state returns to False and so on.
End Rem
Type LTCheckBox Extends LTButton
	Method OnMouseOut()
		Focus = False
	End Method

	
	
	Method OnButtonPress( ButtonAction:LTButtonAction )
		State = Not State
	End Method
		
	

	Method OnButtonDown( ButtonAction:LTButtonAction )
	End Method
	
	
	
	Method OnButtonUp( ButtonAction:LTButtonAction )
	End Method
End Type