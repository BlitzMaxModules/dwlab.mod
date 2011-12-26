'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTModelActivator Extends LTCommandModel
	Field Model:LTBehaviorModel

	
	
	Function Create:LTModelActivator( Model:LTBehaviorModel )
		Local Activator:LTModelActivator = New LTModelActivator
		Activator.Model = Model
		Return Activator
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Model.Activate( Shape )
	End Method
End Type