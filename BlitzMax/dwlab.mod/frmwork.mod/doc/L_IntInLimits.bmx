SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Word:String
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		If L_IntInLimits( MouseX(), 200, 600 ) Then Word = "" Else Word = "not "
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		SetColor( 255, 0, 0 )
		DrawLine( 200, 0, 200, 599 )
		DrawLine( 600, 0, 600, 599 )
		SetColor( 255, 255, 255 )
		DrawText( MouseX() + " is " + Word + "in limits of [ 200, 600 ]", 0, 0 )
		DrawOval( MouseX() - 2, MouseY() - 2, 5, 5 )
		L_PrintText( "L_IntInLimits example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type