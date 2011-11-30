SuperStrict

Framework brl.basic
Import dwlab.frmwork

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 16, 12 )
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		Rectangle.SetMouseCoords()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.DrawContour( 2 )
		Rectangle.PrintText( "topleft corner", LTAlign.ToLeft, LTAlign.ToTop )
		Rectangle.PrintText( "top", LTAlign.ToCenter, LTAlign.ToTop )
		Rectangle.PrintText( "topright corner", LTAlign.ToRight, LTAlign.ToTop )
		Rectangle.PrintText( "left side", LTAlign.ToLeft, LTAlign.ToCenter )
		Rectangle.PrintText( "center", LTAlign.ToCenter, LTAlign.ToCenter )
		Rectangle.PrintText( "right side", LTAlign.ToRight, LTAlign.ToCenter )
		Rectangle.PrintText( "bottomleft corner", LTAlign.ToLeft, LTAlign.ToBottom )
		Rectangle.PrintText( "bottom", LTAlign.ToCenter, LTAlign.ToBottom )
		Rectangle.PrintText( "bottomright corner", LTAlign.ToRight, LTAlign.ToBottom )
		DrawText( "", 0, 0 )
	End Method
End Type