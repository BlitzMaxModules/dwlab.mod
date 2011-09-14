'
' Skeleton Slayer - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMessage Extends LTSprite
	Const FadingPeriod:Double = 0.2
	Const LifePeriod:Double = 2.0

	Field StartingTime:Double
	Field Text:String
	
	Function ApplyDamage( Person:TPerson )
		Local Message:TMessage = New TMessage
		Message.SetCoords( Person.X - 1.5, Person.Y - 1.5 )
		Message.Visualizer = New LTVisualizer
		Local Miss:Int = Rand( 0, 1 )
		If Miss Then
			Message.Text = "miss"
		Else
			Local Amount:Int = Rand( 1, 3 )
			Message.Text = "-" + Amount
			Person.Health :- Amount
			If Person.Health <= 0 Then Person.AttachModel( New TDeath )
			Message.Visualizer.SetColorFromRGB( 1.0, 0.0, 0.0 )
		End If
		Message.StartingTime = Game.Time
		Game.Level.AddLast( Message )
	End Function
	
	Method Draw()
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		Visualizer.ApplyColor()
		DrawText( Text, SX - Text.Length * 4, SY - 8 )
		Visualizer.ResetColor()
	End Method
	
	Method Act()
		If Game.Time < StartingTime + FadingPeriod Then
			Visualizer.Alpha = ( Game.Time - StartingTime ) / FadingPeriod
		ElseIf Game.Time > StartingTime + LifePeriod Then
			Game.Level.Remove( Self )
		ElseIf Game.Time > StartingTime + LifePeriod - FadingPeriod Then
			Visualizer.Alpha = ( LifePeriod - ( Game.Time - StartingTime ) ) / FadingPeriod
		Else
			Visualizer.Alpha = 1.0
		End If
		Move( -1.0, -1.0 )
	End Method
End Type