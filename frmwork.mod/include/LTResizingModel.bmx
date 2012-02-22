'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTResizingModel Extends LTValueChangingModel
	Function Create:LTResizingModel( Time:Double, DestinationSize:Double )
		Local Model:LTResizingModel = New LTResizingModel
		Model.Period = Time
		Model.DestinationValue = DestinationSize
		Return Model
	End Function
	
	
	
	Method Init( Shape:LTShape )
		InitialValue = Shape.GetDiameter()
	End Method
	
	
	
	Method ChangeValue( Shape:LTShape, NewValue:Double )
		Shape.SetDiameter( NewValue )
	End Method
End Type