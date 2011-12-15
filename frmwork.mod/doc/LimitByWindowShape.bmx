SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval )
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 10, 10 )
	
	Method Init()
		L_InitGraphics()
		Ball1.Visualizer.SetColorFromHex( "FF0000" )
		Ball2.Visualizer.SetColorFromHex( "FFFF00" )
		Ball1.LimitByWindowShape( Rectangle )
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
	End Method
	
	Method Logic()
		Ball1.SetMouseCoords()
		Ball2.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		Ball1.Draw()
		Ball2.Draw()
		DrawText( "Move cursor to see how ball is limited by rectangle", 0, 0 )
	End Method
End Type