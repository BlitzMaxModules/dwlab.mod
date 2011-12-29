'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTIsModelActive Extends LTConditionalModel
	Field Model:LTBehaviorModel
	
	
	
	Function Create:LTIsModelActive( Model:LTBehaviorModel )
		Local BehaviorModel:LTIsModelActive = New LTIsModelActive
		BehaviorModel.Model = Model
		Return BehaviorModel
	End Function
	
	
	
	Method Condition:Int( Shape:LTShape )
		If Model Then Return Model.Active 
		Return False
	End Method
End Type
