'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBackground Extends LTVectorSprite
	Method Init()
		Game.HUDCamera.JumpTo( Self )
		Visible = False
	End Method
End Type





Type TScoreBar Extends LTVectorSprite
	Method Draw()
		Game.Font.PrintInShape( L_FirstZeroes( Game.Score, 8 ), Self, 0.5, LTAlign.ToLeft, LTAlign.ToCenter )
	End Method
End Type





Type TSmallCoin Extends LTVectorSprite
	Method Draw()
		Frame = Max( ( Floor( Game.Time / TTiles.FadingSpeed ) Mod ( TTiles.FadingPeriod + 4 ) ) - TTiles.FadingPeriod, 0 )
		If Frame = 3 Then Frame = 1
		Super.Draw()
	End Method
End Type





Type TCoinsQuantity Extends LTVectorSprite
	Method Draw()
		Game.Font.PrintInShape( "x" + L_FirstZeroes( Game.Coins, 2 ), Self, 0.5, LTAlign.ToLeft, LTAlign.ToCenter )
	End Method
End Type





Type TTimeBar Extends LTVectorSprite
	Method Draw()
		Game.Font.PrintInShape( "TIME:" + L_FirstZeroes( Game.TimeLeft, 3 ), Self, 0.5, LTAlign.ToRight, LTAlign.ToCenter )
	End Method
End Type