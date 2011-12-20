SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Pivot1:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Pivot2:LTSprite = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	Field Oval1:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field Oval2:LTSprite = LTSprite.FromShape( 0, 0, 0.75, 0.75, LTSprite.Oval )
	Field Line:LTLine = LTLine.FromPivots( Pivot1, Pivot2 )
	
	Method Init()
		L_InitGraphics()
		Line.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.2, "0000FF", 1.0, 2.0 )
		Oval1.Visualizer.SetColorFromHex( "FF0000" )
		Oval2.Visualizer.SetColorFromHex( "00FF00" )
	End Method
	
	Method Logic()
		Pivot2.SetMouseCoords()
		Oval1.PlaceBetween( Pivot1, Pivot2, 0.5 )
		Oval2.PlaceBetween( Pivot1, Pivot2, 0.3 )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Line.Draw()
		Oval1.Draw()
		Oval2.Draw()
		L_PrintText( "PlaceBetween example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type