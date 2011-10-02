'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TIntro Extends LTProject
	Field Help:String[] = [ "Color Lines", "", "Press left mouse button on ball to select it", "Press left mouse button on empty field to move ball there", ..
			"Press right mouse button to adjacent ball to swap it with selected", "Form lines of 5 and more equal balls to remove them and gain score", ..
			"", "Press any key to start" ]
	
	Field Panel:LTSprite = New LTSprite

	Method Init()
		Panel.JumpTo( L_CurrentCamera )
		Panel.SetSize( 14.0, 0.7 * ( Help.Length + 2.0 ) )
		Panel.Visualizer = Game.Panel.Visualizer
	End Method

	Method Render()
		Panel.Draw()
		For Local N:Int = 0 Until Help.Length
			Game.Font.Print( Help[ N ], Panel.X, Panel.Y - ( Help.Length - 1 ) * 0.35 + 0.7 * N, 0.7, LTAlign.ToCenter, LTAlign.ToCenter )
		Next
	End Method
	
	Method Logic()
		If GetChar() Or MouseHit( 1 ) Then Exiting = True
		if AppTerminate() Then End
	End Method
End Type