'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTLevelFailedWindow Extends LTLevelCompletedWindow
	Method Init()
		If Profile.TotalLevelTime > 0 And Profile.LevelTime > Profile.TotalLevelTime Then
			LTLabel( FindShape( "Title" ) ).Text = LocalizeString( "You are run out of time" )
		Else If Profile.TotalTurns > 0 And Profile.Turns > Profile.TotalTurns Then
			LTLabel( FindShape( "Title" ) ).Text = LocalizeString( "You are run out of turns" )
		End If
		Super.Init()
	End Method
End Type