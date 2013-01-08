'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTResizingModel.bmx"
Include "LTAlphaChangingModel.bmx"

Type LTValueChangingModel Extends LTTemporaryModel
	Field InitialValue:Double, DestinationValue:Double
	Field Speed:Double

	
	
	Method ApplyTo( Shape:LTShape )
		If DestinationValue = InitialValue Then
			Remove( Shape )
		Else
			ChangeValue( Shape, InitialValue + ( L_CurrentProject.Time - StartingTime ) / Period * ( DestinationValue - InitialValue ) )
		End If
		Super.ApplyTo( Shape )
	End Method
	
	
	
	Method ChangeValue( Shape:LTShape, NewValue:Double )
	End Method
End Type