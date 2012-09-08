SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval )
	Field Ball3:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval )
	
	Field Rectangle1:LTSprite = LTSprite.FromShape( 10, 0, 10, 10 )
	Field Rectangle2:LTSprite = LTSprite.FromShape( -10, 5, 6, 9 )
	Field Rectangle3:LTSprite = LTSprite.FromShape( -10, -5, 6, 9 )
	Field Rectangle4:LTSprite = LTSprite.FromShape( -3, 0, 6, 8 )
	
	Field RectangleArray:LTSprite[] = [ Rectangle2, Rectangle3, Rectangle4 ]
	
	Method Init()
		L_InitGraphics()
		Ball1.Visualizer.SetColorFromHex( "FF0000" )
		Ball2.Visualizer.SetColorFromHex( "FFFF00" )
		Ball3.Visualizer.SetColorFromHex( "0000FF" )
		Ball1.LimitByWindowShape( Rectangle1 )
		Ball3.LimitByWindowShapes( RectangleArray )
		Rectangle1.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
		Rectangle2.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
		Rectangle3.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
		Rectangle4.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "00FF00" )
	End Method
	
	Method Logic()
		Ball1.SetMouseCoords()
		Ball2.SetMouseCoords()
		Ball3.SetMouseCoords()
		If AppTerminate() Or KeyHit( KEY_ESCAPE ) Then Exiting = True
	End Method

	Method Render()
		Rectangle1.Draw()
		Rectangle2.Draw()
		Rectangle3.Draw()
		Rectangle4.Draw()
			
		Ball1.Draw()
		Ball3.Draw()
		Ball2.Draw()
		
		DrawText( "Move cursor to see how balls are limited by rectangles", 0, 0 )
		L_PrintText( "LimitByWindowShape, LimitByWindowShapes example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type