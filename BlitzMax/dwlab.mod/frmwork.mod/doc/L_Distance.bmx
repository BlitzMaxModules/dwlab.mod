SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field X:Int = 400
	Field Y:Int = 300
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		If MouseHit( 1 ) Then
			X = MouseX()
			Y = MouseY()
		End If
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawOval( X - 2, Y - 2, 5, 5 )
		DrawLine( X, Y, MouseX(), MouseY() )
		DrawText( "Distance is " + L_TrimDouble( L_Distance( Y - MouseY(), X - MouseX() ) ) + " pixels", 0, 0 )
		L_PrintText( "L_Distance example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type