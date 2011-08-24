Type THUDPanel Extends LTSprite
	Method Init()
		Visualizer = Game.FrameVisualizer
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