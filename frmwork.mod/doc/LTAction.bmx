SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "kolobok.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Const SpritesQuantity:Int = 50
	
	Field Sprites:LTLayer = New LTLayer
	Field SpriteImage:LTImage = LTImage.FromFile( "incbin::kolobok.png" )
	Field Drag:TMoveDrag = New TMoveDrag
	
	Method Init()
		For Local N:Int = 1 To SpritesQuantity
			Local Sprite:LTSprite = LTSprite.FromShape( Rnd( -15, 15 ), Rnd( -11, 11 ), , , LTSprite.Oval )
			Sprite.SetDiameter( Rnd( 1, 3 ) )
			Sprite.Visualizer.SetRandomColor()
			Sprite.Visualizer.Angle = Rnd( 360 )
			Sprite.Visualizer.Image = SpriteImage
			Sprite.Visualizer.SetVisualizerScales( 1.3 )
			Sprites.AddLast( Sprite )
		Next
		L_InitGraphics()
	End Method
	
	Method Logic()
		Drag.Execute()
		
		L_PushActionsList()
		If KeyDown( Key_LControl ) Or KeyDown( Key_RControl ) Then
			If KeyHit( Key_Z ) Then L_Undo()
			If KeyHit( Key_Y ) Then L_Redo()
		End If
		
		If KeyHit( Key_F2 ) Then Sprites.SaveToFile( "sprites2.lw" )
		If KeyHit( Key_F3 ) Then Sprites = LTLayer( LTObject.LoadFromFile( "sprites2.lw" ) )
		
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		Sprites.Draw()
		DrawText( "Drag sprites with left mouse button, press CTRL-Z to undo, CTRL-Y to redo, F2 to save, F3 to load", 0, 0 )
		L_PrintText( "LTAction, L_Undo, L_Redo, L_PushActionsList, LTDrag example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
	End Method
End Type



Type TMoveDrag Extends LTDrag
	Field Shape:LTShape
	Field Action:TMoveAction
	Field DX:Double, DY:Double

	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method

	Method StartDragging()
		Shape = L_Cursor.FirstCollidedSpriteOfLayer( Example.Sprites )
		If Shape Then
			Action = TMoveAction.Create( Shape )
			DX = Shape.X - L_Cursor.X
			DY = Shape.Y - L_Cursor.Y
		Else
			DraggingState = False
		End If
	End Method

	Method Dragging()
		Shape.SetCoords( L_Cursor.X + DX, L_Cursor.Y + DY )
	End Method

	Method EndDragging()
		Action.NewX = Shape.X
		Action.NewY = Shape.Y
		Action.Do()
	End Method
End Type



Type TMoveAction Extends LTAction
	Field Shape:LTShape
	Field OldX:Double, OldY:Double
	Field NewX:Double, NewY:Double
	
	Function Create:TMoveAction( Shape:LTShape )
		Local Action:TMoveAction = New TMoveAction
		Action.Shape = Shape
		Action.OldX = Shape.X
		Action.OldY = Shape.Y
		Return Action
	End Function
	
	Method Do()
		Shape.SetCoords( NewX, NewY )
		Super.Do()
	End Method
	
	Method Undo()
		Shape.SetCoords( OldX, OldY )
		Super.Undo()
	End Method
End Type