SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

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
		L_DrawEmptyRect( -1, -1, 102, 102 )
		L_DrawEmptyRect( 299, 249, 202, 102 )
		SetColor( 0, 255, 0 )
		DrawOval( L_WrapInt( MouseX(), 100 ) - 2, L_WrapInt( MouseY(), 100 ) - 2, 5, 5 )
		DrawText( "L_WrapInt(" + MouseX() + ", 100)=" + L_WrapInt( MouseX(), 100 ), 0, 102 )
		SetColor( 0, 0, 255 )
		DrawOval( L_WrapInt2( MouseX(), 300, 500 ) - 2, L_WrapInt2( MouseY(), 250, 350 ) - 2, 5, 5 )
		DrawText( "L_WrapInt2(" + MouseX() + ", 300, 500)=" + L_WrapInt2( MouseX(), 300, 500 ), 300, 352 )
		DrawText( "", 0, 0 )
		SetColor( 255, 255, 255 )
		L_PrintText( "L_WrapInt and L_WrapInt2 example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type