'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type THUDPanel Extends LTSprite
	Method Init()
		Visualizer = Game.Panel.Visualizer
	End Method
End Type

Type TScore Extends LTSprite
	Method Draw()
		Game.Font.Print( "Score: " + Game.Score, X, Y, 0.7, LTAlign.ToCenter, LTAlign.ToCenter )
	End Method
End Type

Type THiScore Extends LTSprite
	Method Draw()
		Game.Font.Print( "Hiscore: " + Game.HiScore, X, Y, 0.7, LTAlign.ToCenter, LTAlign.ToCenter )
	End Method
End Type

Type TScreenCenter Extends LTSprite
	Method Init()
		L_CurrentCamera.JumpTo( Self )
	End Method
End Type