'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTButton.bmx"
Include "LTComboBox.bmx"
Include "LTTextField.bmx"
Include "LTButton.bmx"

Global L_DefaultVisualizers:TMap = New TMap

Type LTGadget Extends LTSprite
	Method OnMouseOver()
	End Method
	
	Method OnMouseOut()
	End Method	
End Type