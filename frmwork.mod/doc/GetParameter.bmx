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
		DrawText( "", 0, 0 )
	End Method
End Type