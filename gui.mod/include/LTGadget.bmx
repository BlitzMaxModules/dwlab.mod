'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTLabel.bmx"
Include "LTTextField.bmx"
Include "LTListBox.bmx"
Include "LTSlider.bmx"

Rem
bbdoc: Class for GUI gagdet for placing on window.
End Rem
Type LTGadget Extends LTSprite
	Rem
	bbdoc: Gadget initialization method.
	about: Called after loading window with this gadget.
	End Rem
	Method Init()
	End Method
	
	
	
	Rem
	bbdoc: Button pressing event method.
	about: Called when button just being pressed on the gadget.
	
	See also: #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonPress( ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Button unpressing event method
	about: Called when button just being unpressed on gadget.
	
	See also: #OnButtonPress, #OnButtonDown, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem
	Method OnButtonUnpress( ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Button down event method.
	about: Called when button is currently pressed and cursor is over gadget.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem	
	Method OnButtonDown( ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Button up event method.
	about: Called when button is currently released and cursor is over gadget.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonUp, #OnMouseOver, #OnMouseOut
	End Rem	
	Method OnButtonUp( ButtonAction:LTButtonAction )
	End Method
	
	
	
	Rem
	bbdoc: Mouse cursor entering gadget event method.
	about: Called when mouse is just entered gadget area.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOut
	End Rem
	Method OnMouseOver()
	End Method
	
	
	
	Rem
	bbdoc: Mouse cursor leaving gadget event method.
	about: Called when mouse is just left gadget area.
	
	See also: #OnButtonPress, #OnButtonUnpress, #OnButtonDown, #OnButtonUp, #OnMouseOver
	End Rem
	Method OnMouseOut()
	End Method	
End Type