SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Print FileType( "border.png" )
Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field Frame:LTSprite
	Field FrameImage:LTRasterFrame = LTRasterFrame.FromFileAndBorders( "border.png", 8, 8, 8, 8 )
	Field Cursor:LTSprite = LTSprite.FromShape()
	Field Layer:LTLayer = New LTLayer
	Field CreateFrame:TCreateFrame = New TCreateFrame
	
	Method Init()
		L_InitGraphics()
	End Method
	
	Method Logic()
		Cursor.SetMouseCoords()
		CreateFrame.Execute()
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Layer.Draw()
		If Frame Then Frame.Draw()
		DrawText( "Drag left mouse button to create frames", 0, 0 )
	End Method
End Type



Type TCreateFrame Extends LTDrag
	Field StartingX:Int, StartingY:Int
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method

	Method StartDragging()
		StartingX = Example.Cursor.X
		StartingY = Example.Cursor.Y
		Example.Frame = LTSprite.FromShape()
		Example.Frame.Visualizer.SetRandomColor()
		Example.Frame.Visualizer.Image = Example.FrameImage
	End Method

	Method Dragging()
		Local CornerX:Double, CornerY:Double
		If StartingX < Example.Cursor.X Then CornerX = StartingX Else CornerX = Example.Cursor.X
		If StartingY < Example.Cursor.Y Then CornerY = StartingY Else CornerY = Example.Cursor.Y
		Example.Frame.SetSize( Abs( StartingX - Example.Cursor.X ), Abs( StartingY - Example.Cursor.Y ) )
		Example.Frame.SetCornerCoords( CornerX, CornerY )
	End Method
	
	Method EndDragging()
		Example.Layer.AddLast( Example.Frame )
		Example.Frame = Null
	End Method
End Type