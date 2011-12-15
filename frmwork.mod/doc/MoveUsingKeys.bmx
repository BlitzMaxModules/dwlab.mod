SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball1:LTSprite = LTSprite.FromShape( -8, 0, 1, 1, LTSprite.Oval, 0, 7 )
	Field Ball2:LTSprite = LTSprite.FromShape( 0, 0, 2, 2, LTSprite.Oval, 0, 3 )
	Field Ball3:LTSprite = LTSprite.FromShape( 8, 0, 1.5, 1.5, LTSprite.Oval, 0, 5 )
	
	Method Init()
		Ball1.Visualizer = LTVisualizer.FromHexColor( "FF0000" )
		Ball2.Visualizer = LTVisualizer.FromHexColor( "00FF00" )
		Ball3.Visualizer = LTVisualizer.FromHexColor( "0000FF" )
		L_InitGraphics()
	End Method
	
	Method Logic()
		Ball1.MoveUsingWSAD( Ball1.Velocity )
		Ball2.MoveUsingArrows( Ball2.Velocity )
		Ball3.MoveUsingKeys( Key_I, Key_K, Key_J, Key_L, Ball3.Velocity )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawText( "Move red ball using WSAD keys", 0, 0 )
		DrawText( "Move green ball using arrow keys", 0, 16 )
		DrawText( "Move blue ball using IJKL keys", 0, 32 )
		Ball1.Draw()
		Ball2.Draw()
		Ball3.Draw()
	End Method
End Type
