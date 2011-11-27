SuperStrict

Framework brl.basic
Import dwlab.frmwork

SeedRnd( MilliSecs() )
Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Ball:LTSprite[] = New LTSprite[ 7 ]
	Field Rectangle:LTSprite = LTSprite.FromShape( 0, 0, 22, 14 )
	
	Method Init()
		L_InitGraphics()
		Rectangle.Visualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000" )
		For Local N:Int = 0 To 6
			Ball[ N ] = New LTSprite
			Ball[ N ].ShapeType = LTSprite.Oval
			Ball[ N ].SetDiameter( 0.5 * ( 7 - N ) )
			Ball[ N ].Visualizer.SetRandomColor()
		Next
	End Method
	
	Method Logic()
		For Local N:Int = 0 To 6
			Ball[ N ].SetMouseCoords()
		Next
		Ball[ 0 ].LimitWith( Rectangle )
		Ball[ 1 ].LimitHorizontallyWith( Rectangle )
		Ball[ 2 ].LimitVerticallyWith( Rectangle )
		Ball[ 3 ].LimitLeftWith( Rectangle )
		Ball[ 4 ].LimitTopWith( Rectangle )
		Ball[ 5 ].LimitRightWith( Rectangle )
		Ball[ 6 ].LimitBottomWith( Rectangle )
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Rectangle.Draw()
		For Local N:Int = 0 To 6
			Ball[ N ].Draw()
		Next
		DrawText( "", 0, 0 )
	End Method
End Type