' First sprite is moving at constant speed regardles of LogicFPS because it use delta-timing PerSecond() method to determine
' on which distance to move in particular logic frame.Second sprite use simple coordinate addition.

SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Sprite1:LTSprite = LTSprite.FromShape( -10, -2, 2, 2, LTSprite.Oval )
	Field Sprite2:LTSprite = LTSprite.FromShape( -10, 2, 2, 2, LTSprite.Oval )

	Method Init()
		L_InitGraphics()
		Sprite1.Visualizer = LTVisualizer.FromRGBColor( 1, 1, 0 )
		Sprite2.Visualizer = LTVisualizer.FromRGBColor( 0, 0.5, 1 )
		L_LogicFPS = 100
	End Method
	
	Method Logic()
		Sprite1.X :+ L_PerSecond( 8 )
		If Sprite1.X > 10 Then Sprite1.X :- 20
		
		Sprite2.X :+ 0.08
		If Sprite2.X > 10 Then Sprite2.X :- 20
		
		If KeyDown( Key_NumAdd ) Then L_LogicFPS :+ L_PerSecond( 100 )
		If KeyDown( Key_NumSubtract ) And L_LogicFPS > 20 Then L_LogicFPS :- L_PerSecond( 100 )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite1.Draw()
		Sprite2.Draw()
		DrawText( "Logic FPS: " + L_TrimDouble( L_LogicFPS ) + ", press num+ / num- to change", 0, 0 )
	End Method
End Type