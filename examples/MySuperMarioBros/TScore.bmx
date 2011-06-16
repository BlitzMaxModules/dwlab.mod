'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TScore Extends LTSprite
	Const Speed:Double = 3.0
	Const LifeTime:Double = 1.0

	Field StartingTime:Double
	
	Const s1up:Int = 0	
	Const s100:Int = 1
	Const s200:Int = 2
	Const s400:Int = 3
	Const s500:Int = 4
	Const s800:Int = 5
	Const s1000:Int = 6
	Const s2000:Int = 7
	Const s4000:Int = 8
	Const s5000:Int = 9
	Const s8000:Int = 10

	
	
	Method Act()
		Move( 0, -Speed )
		If Game.Time > StartingTime + LifeTime Then Game.Level.Remove( Self )
	End Method
	
	

	Function FromSprite( Sprite:LTSprite, Frame:Int )
		Local Score:TScore = New TScore
		Score.SetCoords( Sprite.X, Sprite.Y - 1.0 )
		Score.Frame = Frame
		Score.Visualizer = Game.ScoreVisualizer
		Score.CorrectHeight()
		Score.StartingTime = Game.Time
		Select Frame
			Case s1up
				Game.Lives :+ 1
			Case s100
				Game.Score :+ 100
			Case s200
				Game.Score :+ 200
			Case s400
				Game.Score :+ 400
			Case s500
				Game.Score :+ 500
			Case s800
				Game.Score :+ 800
			Case s1000
				Game.Score :+ 1000
			Case s2000
				Game.Score :+ 2000
			Case s4000
				Game.Score :+ 4000
			Case s5000
				Game.Score :+ 5000
			Case s8000
				Game.Score :+ 8000
		End Select
		Game.Level.AddLast( Score )
	End Function
End Type