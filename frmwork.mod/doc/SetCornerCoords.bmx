SuperStrict

Framework brl.basic
Import dwlab.frmwork

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	Field Cursor:LTSprite = New LTSprite
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		Rectangle.SetCornerCoords( Cursor.X, Cursor.Y )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
	End Method
End Type