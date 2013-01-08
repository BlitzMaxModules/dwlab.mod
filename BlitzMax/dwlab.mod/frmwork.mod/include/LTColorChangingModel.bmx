'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTColorChangingModel Extends LTTemporaryModel
	Field InitialRed:Double, InitialGreen:Double, InitialBlue:Double
	Field DestinationRed:Double, DestinationGreen:Double, DestinationBlue:Double
	
	
	
	Function Create:LTColorChangingModel( DestinationRed:Double, DestinationGreen:Double, DestinationBlue:Double, Time:Double = 0.0, Speed:Double = 0.0 )
		Local Model:LTColorChangingModel = New LTColorChangingModel
		Model.Period = Time
		Model.DestinationRed = DestinationRed
		Model.DestinationGreen = DestinationGreen
		Model.DestinationBlue = DestinationBlue
		Return Model
	End Function
	
	
	
	Method Init( Shape:LTShape )
		InitialRed = Shape.Visualizer.Red
		InitialBlue = Shape.Visualizer.Blue
		InitialGreen = Shape.Visualizer.Green
		Shape.RemoveModel( "LTColorChangingModel" )
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Local K:Double = ( L_CurrentProject.Time - StartingTime ) / Period
		Shape.Visualizer.Red = InitialRed + K * ( DestinationRed - InitialRed )
		Shape.Visualizer.Green = InitialGreen + K * ( DestinationGreen - InitialGreen )
		Shape.Visualizer.Blue = InitialBlue + K * ( DestinationBlue - InitialBlue )
		Super.ApplyTo( Shape )
	End Method
End Type