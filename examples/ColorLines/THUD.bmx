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
	Field Icon:LTSprite
	Field Count:LTLabel
	
	Method Init()
		Super.Init()
		Game.Background = FindShape( "Background" )
		Remove( Game.Background )
		Icon = LTSprite( FindShape( "GoalIcon" ) )
		Remove( Icon )
		Count = LTLabel( FindShape( "GoalCount" ) )
		Remove( Count )
	End Method

	Method Draw()
		Super.Draw()
		Local Ball:LTSprite = LTSprite( FindShape( "Ball" ) )
		if Profile.NextBalls Then
			Local StartingX:Double = FindShape( "TimePanel" ).X - 0.8 * ( Profile.NextBalls.Dimensions()[ 0 ] - 1 )
			Local N:Int = 0
			For Local BallNum:Int = Eachin Profile.NextBalls
				Ball.SetX( StartingX + N * 1.6 )
				Ball.Frame = BallNum
				Ball.Draw()
				N :+ 1
			Next
		End If
		
		Local StartingX:Double = FindShape( "Goals" ).X - 1.5 * ( Profile.Goals.Count() - 1 )
		For Local Goal:TGoal = Eachin Profile.Goals
			Icon.SetX( StartingX - 0.75 )
			Icon.Draw()
			Count.SetX( StartingX + 0.75 )
			Count.Text = "x" + Goal.Count
			Count.Draw()
			StartingX :+ 1.5
		Next
	End Method
	
	Method Act()
		Super.Act()
		LTLabel( FindShape( "Score" ) ).Text = Profile.Score
		LTLabel( FindShape( "CurrentProfile" ) ).Text = LocalizeString( Profile.Name )
	End Method
End Type