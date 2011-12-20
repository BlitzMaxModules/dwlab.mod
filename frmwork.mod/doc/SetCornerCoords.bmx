SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 8, 6 )
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		Rectangle.SetCornerCoords( L_Cursor.X, L_Cursor.Y )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		L_PrintText( "SetCornerCoords example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type