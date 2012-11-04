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
	Field BallIcon:LTSprite
	Field TileIcon:LTSprite
	Field Count:LTLabel
	Field Ball:LTSprite
	Field Size:Double
	Field Distance:Double
	Field Goal1X:Double
	Field GoalDX:Double
	Field LevelTimeBar:TBar
	Field TurnsBar:TBar
	Field TurnTimeBar:TBar
	
	Method Init()
		Super.Init()
		LevelTimeBar = TBar( FindShape( "level-time" ) )
		TurnsBar = TBar( FindShape( "turns" ) )
		TurnTimeBar = TBar( FindShape( "turn-time" ) )
		Game.Background = FindShape( "Background" )
		Remove( Game.Background )
		BallIcon = LTSprite( FindShape( "BallIcon" ) )
		Remove( BallIcon )
		TileIcon = LTSprite( FindShape( "TileIcon" ) )
		Remove( TileIcon )
		Count = LTLabel( FindShape( "GoalCount" ) )
		Remove( Count )
		Ball = LTSprite( FindShape( "Ball" ) )
		Remove( Ball )
		Size = BallIcon.GetDiameter()
		Distance = Ball.GetParameter( "distance" ).ToDouble()
		Goal1X = FindShape( "Goal1" ).X
		GoalDX = FindShape( "Goal2" ).X - Goal1X
	End Method

	Method Draw()
		LevelTimeBar.SetValue( Profile.LevelTime * ( Profile.TotalLevelTime > 0 ), Profile.TotalLevelTime )
		TurnsBar.SetValue( Profile.Turns * ( Profile.TotalTurns > 0 ), Profile.TotalTurns )
		TurnTimeBar.SetValue( Profile.TurnTime * ( Profile.TotalTurnTime > 0 ), Profile.TotalTurnTime )
		'debugstop
	
		Super.Draw()
		if Profile.NextBalls And Profile.ShowNextBalls Then
			If Profile.NextBalls.Length <= 5 Then
				Local StartingX:Double = FindShape( "Balls" ).X - 0.5 * Distance * ( Profile.NextBalls.Dimensions()[ 0 ] - 1 )
				Local N:Int = 0
				Ball.SetDiameter( Size )
				For Local BallNum:Int = Eachin Profile.NextBalls
					Ball.SetX( StartingX + N * Distance )
					Ball.Frame = BallNum
					Ball.Draw()
					N :+ 1
				Next
			End If
		End If
		
		Local GoalX:Double = Goal1X
		For Local Goal:TGoal = Eachin Profile.Goals
			Goal.Draw( GoalX, Ball, TileIcon, BallIcon, Count )
			GoalX :+ GoalDX
		Next
	End Method
	
	Method Act()
		Super.Act()
		LTLabel( FindShape( "Score" ) ).Text = Profile.Score
		LTLabel( FindShape( "CurrentProfile" ) ).Text = LocalizeString( Profile.Name )
	End Method
	
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		If Gadget.GetName() = "GiveUp" Then Game.LoadWindow( Menu.Interface, "LTRestartWindow" )
	End Method
End Type