'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLevelCompletedWindow Extends LTAudioWindow
	Method Init()
		Project.Locked = True
		L_CurrentProfile.AddHighScore( LTLevelFailedWindow( Self ) = Null )
		LTLabel( FindShape( "Score" ) ).Text = LocalizeString( "{{You scored XXX points}}" ).Replace( "XXX", Profile.Score )
		LTLabel( FindShape( "Time" ) ).Text = LocalizeString( "{{Spent}} " ) + LocalizeString( ConvertTime( Profile.LevelTime ) )
		LTLabel( FindShape( "Turns" ) ).Text = LocalizeString( "{{And made XXX turns}}" ).Replace( "XXX", Profile.Turns )
		Super.Init()
	End Method

	Method OnButtonUnPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		Select Gadget.GetName()
			Case "SelectLevel"
				Project.CloseWindow( Self )
				Project.LoadWindow( Menu.Interface, "LTLevelSelectionWindow" )
			Case "Restart"
				Project.CloseWindow( Self )
				Menu.LoadLevel( Profile.LevelName )
				Menu.Project.Locked = False
			Case "NextLevel"
				Project.CloseWindow( Self )
				If Profile.LevelName = Profile.FirstLockedLevel Then Menu.NextLevel()
				Menu.LoadLevel( Profile.FirstLockedLevel )
				Menu.Project.Locked = False
		End Select
	End Method
	
	Function ConvertTime:String( Time:Int )
		Local Seconds:Int = Ceil( Time ) Mod 60
		Local Minutes:Int = Floor( Seconds / 60.0 ) Mod 60
		Local Hours:Int = Floor( Seconds / 3600.0 )
		If Hours Then Return Hours + " {{hrs}} " + Minutes + " {{min}} " + Seconds + " {{sec}}" Else Return Minutes + " {{min}} " + Seconds + " {{sec}}"
	End Function
End Type