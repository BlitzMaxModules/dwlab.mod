'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTRestartWindow Extends LTAudioWindow
	Method Init()
		Project.Locked = True
		Super.Init()
	End Method
	
	Method Save()
		LTLevelWindow.LevelIsCompleted = False
		Project.LoadWindow( Menu.Interface, "LTLevelWindow" )
	End Method
		
	Method DeInit()
		Project.Locked = False
		Super.DeInit()
	End Method
End Type