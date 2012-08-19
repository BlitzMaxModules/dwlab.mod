'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAlphaChangingModel Extends LTValueChangingModel
	Function Create:LTAlphaChangingModel( Time:Double, DestinationAlpha:Double )
		Local Model:LTAlphaChangingModel = New LTAlphaChangingModel
		Model.Period = Time
		Model.DestinationValue = DestinationAlpha
		Return Model
	End Function
	
	
	
	Method Init( Shape:LTShape )
		InitialValue = Shape.Visualizer.Alpha
	End Method
	
	
	
	Method ChangeValue( Shape:LTShape, NewValue:Double )
		Shape.Visualizer.Alpha = NewValue
	End Method
End Type