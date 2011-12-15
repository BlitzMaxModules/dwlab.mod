SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Player:LTSprite = LTSprite.FromShape( 0, 0, 1, 2 )
	Field StartingTime:Double
	Field PingPong:Int
	
	Method Init()
		Player.Visualizer.Image = LTImage.FromFile( "mario.png", 4 )
		L_InitGraphics()
	End Method
	
	Method Logic()
		If KeyDown( Key_Space ) Then
			If StartingTime = 0 Then StartingTime = Time
			Player.Animate( Self, 0.1, 3, 1, StartingTime, PingPong )
		Else
			Player.Frame = 0
			StartingTime = 0
		End If
		If KeyHit( Key_P ) Then PingPong = Not PingPong
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Player.Draw()
		DrawText( "Press space to animate sprite, P to toggle ping-pong animation (now it's " + PingPong + ")", 0, 0 )
	End Method
End Type