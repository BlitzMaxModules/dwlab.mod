SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const TurningSpeed:Double = 90

	Field Tank:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Rectangle, 0, 5 )
	
	Method Init()
		L_InitGraphics()
		Tank.Visualizer = LTVisualizer.FromFile( "tank.png" )
	End Method
	
	Method Logic()
		If KeyDown( Key_Left ) Then Tank.Turn( -TurningSpeed )
		If KeyDown( Key_Right ) Then Tank.Turn( TurningSpeed )
		If KeyDown( Key_Up ) Then Tank.MoveForward()
		If KeyDown( Key_Down ) Then Tank.MoveBackward()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Tank.Draw()
		DrawText( "Press arrow keys to move tank", 0, 0 )
	End Method
End Type