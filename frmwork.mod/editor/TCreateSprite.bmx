'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TCreateSprite Extends LTDrag
	Field StartX:Float
	Field StartY:Float
	Field Sprite:LTSprite
	
	
	
	Method DragKey:Int()
		If MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Not Editor.CurrentTilemap Then Return True
	End Method
	
	
	
	Method StartDragging()
		StartX = Editor.Cursor.X
		StartY = Editor.Cursor.Y
		Editor.Grid.Snap( StartX, StartY )
		
		Local CurrentSprite:LTSprite = LTSprite( Editor.CurrentShape )
		If CurrentSprite Then
			Sprite = LTSprite( CurrentSprite.Clone() )
		
			Local CurrentSpriteVisualizer:LTImageVisualizer = LTImageVisualizer( CurrentSprite.Visualizer )
			Local Visualizer:LTImageVisualizer = New LTImageVisualizer
			Visualizer.Red = CurrentSpriteVisualizer.Red
			Visualizer.Green = CurrentSpriteVisualizer.Green
			Visualizer.Blue = CurrentSpriteVisualizer.Blue
			Visualizer.Alpha = CurrentSpriteVisualizer.Alpha
			Visualizer.Angle = CurrentSpriteVisualizer.Angle
			Visualizer.Rotating = CurrentSpriteVisualizer.Rotating
			Visualizer.XScale = CurrentSpriteVisualizer.XScale
			Visualizer.YScale = CurrentSpriteVisualizer.YScale
			Visualizer.Scaling = CurrentSpriteVisualizer.Scaling
			Visualizer.Image = CurrentSpriteVisualizer.Image
			Sprite.Visualizer = Visualizer
		Else
			Select Editor.SpriteModel
				Case 0
					Sprite = New LTSprite
					Sprite.Name = "LTSprite"
				Case 1
					Sprite = New LTVectorSprite
					Sprite.Name = "LTVectorSprite"
				Case 2
					Sprite = New LTAngularSprite
					Sprite.Name = "LTAngularSprite"
			End Select
			Sprite.Visualizer = New LTImageVisualizer
		End If
		
		Editor.CurrentLayer.AddLast( Sprite )
		Editor.SelectShape( Sprite )
	End Method
	
	
	
	Method Dragging()
		Local X:Float = Editor.Cursor.X
		Local Y:Float = Editor.Cursor.Y
		Editor.Grid.Snap( X, Y )
		Sprite.X = 0.5 * ( X + StartX )
		Sprite.Y = 0.5 * ( Y + StartY )
		Sprite.Width = Abs( X - StartX )
		Sprite.Height = Abs( Y - StartY )
	End Method
	
	
	
	Method EndDragging()
		If Not Sprite.Width Or Not Sprite.Height Then
			Editor.CurrentLayer.Remove( Sprite )
		Else
			Editor.SetChanged()
			If Not LTImageVisualizer( Sprite.Visualizer ).Image Then ShapeImageProperties( Sprite )
		End If
		Editor.FillShapeFields()
		Editor.SetShapeModifiers( Sprite )
	End Method
End Type