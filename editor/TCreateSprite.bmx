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
	Field StartX:Double
	Field StartY:Double
	Field Sprite:LTSprite
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Not Editor.CurrentTileMap And Editor.CurrentContainer Then Return True
	End Method
	
	
	
	Method StartDragging()
		StartX = Editor.Cursor.X
		StartY = Editor.Cursor.Y
		Editor.Grid.SnapCoords( StartX, StartY )
		
		Local CurrentSprite:LTSprite = LTSprite( Editor.CurrentShape )
		If CurrentSprite Then
			Sprite = LTSprite( CurrentSprite.Clone() )
			Sprite.Visualizer = CurrentSprite.Visualizer.Clone()
		Else
			Sprite = New LTSprite
			Sprite.Visualizer = New LTVisualizer
		End If
		
		Editor.InsertIntoContainer( Sprite, Editor.CurrentContainer )
		Editor.SelectShape( Sprite )
	End Method
	
	
	
	Method Dragging()
		Local X:Double = Editor.Cursor.X
		Local Y:Double = Editor.Cursor.Y
		Editor.Grid.SnapCoords( X, Y )
		Sprite.SetCoords( 0.5 * ( X + StartX ), 0.5 * ( Y + StartY ) )
		Sprite.SetSize( Abs( X - StartX ), Abs( Y - StartY ) )
	End Method
	
	
	
	Method EndDragging()
		If Not Sprite.Width Or Not Sprite.Height Then
			Local Layer:LTLayer = LTLayer( Editor.CurrentContainer )
			If Layer Then
				Layer.Remove( Sprite )
			Else
				LTSpriteMap( Editor.CurrentContainer ).RemoveSprite( Sprite )
			End If
		Else
			Editor.SetChanged()
			If Not Sprite.Visualizer.Image Then SelectImageOrTileset( Sprite )
		End If
		Editor.FillShapeFields()
		Editor.SetShapeModifiers( Sprite )
	End Method
End Type