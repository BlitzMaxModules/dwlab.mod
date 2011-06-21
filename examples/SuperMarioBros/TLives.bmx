'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TLives Extends LTProject
	Method Init()
		Game.Mario.JumpTo( Game.HUD.FindShapeWithType( "TBackground" ) )
		Game.Mario.AlterCoords( -0.5, 0.0 )
	End Method
	
	
	
	Method Logic()
		If GetChar() Then Exiting = True
	End Method
	
	
	
	Method Render()
		L_CurrentCamera = Game.HUDCamera
		Game.HUD.Draw()
		Game.Mario.Draw()
		
		Game.Font.Print( "X" + Game.Lives, Game.Mario.RightX(), Game.Mario.Y, 0.5, LTAlign.ToLeft, LTAlign.ToCenter )
		L_CurrentCamera = Game.LevelCamera
	End Method
End Type