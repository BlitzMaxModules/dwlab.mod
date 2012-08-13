SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

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

	Const TextSize:Double = 0.7
	
	Method Render()
		Rectangle.DrawContour( 2 )
		
		Rectangle.PrintText( "topleft corner", TextSize, LTAlign.ToLeft, LTAlign.ToTop )
		Rectangle.PrintText( "top", TextSize, LTAlign.ToCenter, LTAlign.ToTop )
		Rectangle.PrintText( "topright corner", TextSize, LTAlign.ToRight, LTAlign.ToTop )
		Rectangle.PrintText( "left side", TextSize, LTAlign.ToLeft, LTAlign.ToCenter )
		Rectangle.PrintText( "center", TextSize, LTAlign.ToCenter, LTAlign.ToCenter )
		Rectangle.PrintText( "right side", TextSize, LTAlign.ToRight, LTAlign.ToCenter )
		Rectangle.PrintText( "bottomleft corner", TextSize, LTAlign.ToLeft, LTAlign.ToBottom )
		Rectangle.PrintText( "bottom", TextSize, LTAlign.ToCenter, LTAlign.ToBottom )
		Rectangle.PrintText( "bottomright corner", TextSize, LTAlign.ToRight, LTAlign.ToBottom )
		L_PrintText( "PrintText example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type