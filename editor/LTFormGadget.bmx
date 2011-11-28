
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTFormGadget
	Const Button:Int = 0
	Const TextField:Int = 1
	Const ComboBox:Int = 2
	Const SliderWithTextField:Int = 3
	Const Label:Int = 4
	Const Canvas:Int = 5
	
	Field GadgetType:Int
	
	Field Gadget:TGadget
	Field X:Int, Y:Int
	
	Field LabelGadget:TGadget
	Field LabelX:Int, LabelY:Int
	
	Field SliderGadget:TGadget
	Field SliderX:Int 
End Type