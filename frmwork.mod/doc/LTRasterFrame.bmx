SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "border.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Frame:LTSprite
	Field FrameImage:LTRasterFrame = LTRasterFrame.FromFileAndBorders( "incbin::border.png", 8, 8, 8, 8 )
	Field Layer:LTLayer = New LTLayer
	Field CreateFrame:TCreateFrame = New TCreateFrame
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		CreateFrame.Execute()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Frame Then Frame.Draw()
		DrawText( "Drag left mouse button to create frames", 0, 0 )
		L_PrintText( "LTRasterFrame, LTDrag example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TCreateFrame Extends LTDrag
	Field StartingX:Double, StartingY:Double
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method

	Method StartDragging()
		StartingX = L_Cursor.X
		StartingY = L_Cursor.Y
		Example.Frame = LTSprite.FromShape()
		Example.Frame.Visualizer.SetRandomColor()
		Example.Frame.Visualizer.Image = Example.FrameImage
	End Method

	Method Dragging()
		Local CornerX:Double, CornerY:Double
		If StartingX < L_Cursor.X Then CornerX = StartingX Else CornerX = L_Cursor.X
		If StartingY < L_Cursor.Y Then CornerY = StartingY Else CornerY = L_Cursor.Y
		Example.Frame.SetSize( Abs( StartingX - L_Cursor.X ), Abs( StartingY - L_Cursor.Y ) )
		Example.Frame.SetCornerCoords( CornerX, CornerY )
	End Method
	
	Method EndDragging()
		Example.Layer.AddLast( Example.Frame )
		Example.Frame = Null
	End Method
End Type