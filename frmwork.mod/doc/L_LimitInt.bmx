SuperStrict

Framework brl.basic
Import dwlab.frmwork

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetColor( 255, 0, 0 )
		DrawLine( 200, 0, 200, 599 )
		DrawLine( 600, 0, 600, 599 )
		SetColor( 255, 255, 255 )
		Local X:Int = L_LimitInt( MouseX(), 200, 600 )
		DrawOval( X - 2, MouseY() - 2, 5, 5 )
		DrawText( "LimitInt(MouseX(),200,600) = " + X, 0, 0 )
	End Method
End Type