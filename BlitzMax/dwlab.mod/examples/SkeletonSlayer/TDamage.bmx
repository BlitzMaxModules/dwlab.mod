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
	Const FadingPeriod:Double = 0.1
	Const LifePeriod:Double = 1.0

	Field StartingTime:Double
	Field Text:String
	
	Function ApplyDamage( Person:TPerson, Amount:Int, Miss:Int )
		Local Message:TMessage = New TMessage
		Message.SetCoords( Person.X, Person.TopY() )
		If Miss Then
			Text = "miss"
		Else
			Text = Amount
		End If
		Message.StartingTime = Game.Time
		Game.Level.AddLast( Message )
	End Function
	
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
	End Method
End Type