'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTModelDeactivator Extends LTCommandModel Final
	Field Model:LTBehaviorModel

	
	
	Function Create:LTModelDeactivator( Model:LTBehaviorModel )
		Local Deactivator:LTModelDeactivator = New LTModelDeactivator
		Deactivator.Model = Model
		Return Deactivator
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Model.Deactivate( Shape )
	End Method
End Type