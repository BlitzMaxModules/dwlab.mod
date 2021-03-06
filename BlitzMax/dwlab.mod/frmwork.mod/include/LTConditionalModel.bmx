'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTIsModelActive.bmx"
Include "LTIsButtonActionDown.bmx"

Type LTConditionalModel Extends LTBehaviorModel
	Field TrueModels:TList = New TList
	Field FalseModels:TList = New TList
	
	
	
	Method Condition:Int( Shape:LTShape )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Remove( Shape )
		If Condition( Shape ) Then
			Shape.AttachModels( TrueModels )
		Else
			Shape.AttachModels( FalseModels )
		End If
	End Method
End Type