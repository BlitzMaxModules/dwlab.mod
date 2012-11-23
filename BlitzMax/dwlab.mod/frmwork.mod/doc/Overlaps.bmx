SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Pivot:LTSprite = LTSprite.FromShape( 6, 0, 0, 0, LTSprite.Pivot )
	Field Oval:LTSprite = LTSprite.FromShape( -4, -2, 3, 5, LTSprite.Oval )
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 5, 4, 4, LTSprite.Rectangle )
	Field Triangle:LTSprite = LTSprite.FromShape( 4, 4, 3, 5, LTSprite.TopLeftTriangle )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 16, 16, LTSprite.Rectangle )
	Field Text:String
	
	Method Init()
		Pivot.Visualizer.SetColorFromHex( "FF0000" )
		Oval.Visualizer.SetColorFromHex( "00FF00" )
		Rectangle.Visualizer.SetColorFromHex( "0000FF" )
		Triangle.Visualizer.SetColorFromHex( "007FFF" )
		Cursor.Visualizer.Alpha = 0.5
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Text = ""
		If Cursor.Overlaps( Pivot ) Then Text = ", pivot"
		If Cursor.Overlaps( Oval ) Then Text :+ ", oval"
		If Cursor.Overlaps( Rectangle ) Then Text :+ ", rectangle"
		If Cursor.Overlaps( Triangle ) Then Text :+ ", triangle"
		If Not Text Then Text = ", nothing"
		If MouseHit( 2 ) Then Cursor.ShapeType = LTShapeType.GetByNum( 3 - Cursor.ShapeType.GetNum() )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Pivot.Draw()
		Oval.Draw()
		Rectangle.Draw()
		Triangle.Draw()
		Cursor.Draw()
		DrawText( "Press right mouse button to change cursor shape", 0, 0 )
		DrawText( "Cursor rectangle fully overlaps " + Text[ 2.. ], 0, 16 )
		L_PrintText( "Overlaps example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type