'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type THUD Extends LTWindow
	Method Draw()
		Super.Draw()
		Local Ball:LTSprite = LTSprite( FindShape( "Ball" ) )
		Local NextBalls:Int[] = TGameProfile( L_CurrentProfile ).NextBalls
		Local StartingX:Double = FindShape( "TimePanel" ).X - 0.25 * ( NextBalls.Dimensions()[ 0 ] - 1 )
		Local N:Int = 0
		For Local BallNum:Int = Eachin NextBalls
			Ball.SetX( StartingX + N * 0.5 )
			Ball.Frame = BallNum
			Ball.Draw()
			N :+ 1
		Next
	End Method
	
	Method Act()
		Super.Act()
		LTLabel( FindShape( "Score" ) ).Text = Game.Score
		LTLabel( FindShape( "CurrentProfile" ) ).Text = LocalizeString( L_CurrentProfile.Name )
	End Method
End Type