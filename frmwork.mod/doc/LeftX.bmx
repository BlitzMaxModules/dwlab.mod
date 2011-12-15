SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	
	Method Init()
		L_InitGraphics()
		Rectangle.Visualizer.SetColorFromHex( "FF0000" )
		Ball.Visualizer.SetColorFromHex( "FFFF00" )
	End Method
	
	Method Logic()
		Rectangle.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Ball.SetCoords( Rectangle.LeftX(), Rectangle.Y )
		Ball.Draw()
		Ball.SetCoords( Rectangle.X, Rectangle.TopY() )
		Ball.Draw()
		Ball.SetCoords( Rectangle.RightX(), Rectangle.Y )
		Ball.Draw()
		Ball.SetCoords( Rectangle.X, Rectangle.BottomY() )
		Ball.Draw()
	End Method
End Type