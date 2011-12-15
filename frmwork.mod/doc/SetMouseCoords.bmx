SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval, 0, 5 )
	Field Cursor:LTSprite = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
	
	Method Init()
		L_InitGraphics()
		Ball.Visualizer = LTVisualizer.FromHexColor( "3F3F7F" )
		Cursor.Visualizer = LTVisualizer.FromHexColor( "7FFF3F" )
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Ball.MoveTowards( Cursor, Ball.Velocity )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Ball.Draw()
		Cursor.Draw()
		If Ball.IsAtPositionOf( Cursor ) Then DrawText( "Ball is at position of cursor", 0, 0 )
	End Method
End Type