SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Sprite1:LTSprite = LTSprite.FromShape( 6, 0, 0, 0, LTSprite.Pivot )
	Field Sprite2:LTSprite = LTSprite.FromShape( -4, -2, 3, 5, LTSprite.Oval )
	Field Sprite3:LTSprite = LTSprite.FromShape( 0, 5, 4, 4, LTSprite.Rectangle )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 16, 12 )
	Field Text:String
	
	Method Init()
		Sprite1.Visualizer.SetColorFromHex( "FF0000" )
		Sprite2.Visualizer.SetColorFromHex( "00FF00" )
		Sprite3.Visualizer.SetColorFromHex( "0000FF" )
		Cursor.Visualizer.Alpha = 0.5
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Text = ""
		If Cursor.Overlaps( Sprite1 ) Then Text = ", pivot"
		If Cursor.Overlaps( Sprite2 ) Then Text :+ ", oval"
		If Cursor.Overlaps( Sprite3 ) Then Text :+ ", rectangle"
		If Not Text Then Text = ", nothing"
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprite1.Draw()
		Sprite2.Draw()
		Sprite3.Draw()
		Cursor.Draw()
		DrawText( "Cursor rectangle fully overlaps " + Text[ 2.. ], 0, 0 )
		L_PrintText( "Overlaps example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type