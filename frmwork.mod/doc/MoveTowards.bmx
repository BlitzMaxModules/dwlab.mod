SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball:LTSprite = LTSprite.FromShape( 0, 0, 3, 3, LTSprite.Oval, 0, 5 )
	
	Method Init()
		L_InitGraphics()
		Ball.Visualizer = LTVisualizer.FromHexColor( "3F3F7F" )
		L_Cursor = LTSprite.FromShape( 0, 0, 1, 1, LTSprite.Oval )
		L_Cursor.Visualizer = LTVisualizer.FromHexColor( "7FFF3F" )
	End Method
	
	Method Logic()
		Ball.MoveTowards( L_Cursor, Ball.Velocity )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Ball.Draw()
		L_Cursor.Draw()
		If Ball.IsAtPositionOf( L_Cursor ) Then DrawText( "Ball is at position of cursor", 0, 0 )
		L_PrintText( "IsAtPositionOf, MoveTowards example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type