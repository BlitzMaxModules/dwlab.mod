'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTIsButtonActionDown Extends LTConditionalModel
	Field ButtonAction:LTButtonAction
	
	
	
	Function Create:LTIsButtonActionDown( ButtonAction:LTButtonAction )
		Local BehaviorModel:LTIsButtonActionDown = New LTIsButtonActionDown
		BehaviorModel.ButtonAction = ButtonAction
		Return BehaviorModel
	End Function
	
	
	
	Method Condition:Int( Shape:LTShape )
		Return ButtonAction.IsDown()
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
		Return ButtonAction.Name
	End Method
End Type
