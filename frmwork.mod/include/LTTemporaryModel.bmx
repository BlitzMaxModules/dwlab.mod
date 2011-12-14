'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTemporaryModel Extends LTBehaviorModel
	Field StartingTime:Double
	Field Period:Double
	Field NextModel:LTBehaviorModel = Null
	
	
	
	Method DefaultInit( Shape:LTShape )
		StartingTime = L_CurrentProject.Time
	End Method
	
	
	
	Method DefaultApplyTo( Shape:LTShape )
		If L_CurrentProject.Time > StartingTime + Period Then
			Remove( Shape )
			If NextModel Then Shape.AttachModel( NextModel )
		End If
	End Method
End Type