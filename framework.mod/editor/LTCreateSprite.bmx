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

Type LTCreateSprite Extends LTDrag
	Field StartX:Float
	Field StartY:Float
	Field Sprite:LTSprite
	
	
	
	Method DragKey:Int()
		If MouseDown( 2 ) And MenuChecked( Editor.EditSprites ) And Editor.CurrentSpriteType Then Return True
	End Method
	
	
	
	Method StartDragging()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
		Editor.Grid.Snap( StartX, StartY )
		
		Sprite = New LTSprite
		Sprite.SpriteType = Editor.CurrentSpriteType
		Sprite.Visualizer = Editor.CurrentSpriteType.ImageVisualizer
		Editor.CurrentPage.Sprites.AddLast( Sprite )
		Editor.Dragging = True
		Editor.SelectSprite( Sprite )
	End Method
	
	
	
	Method Dragging()
		Local X:Float, Y:Float
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		Editor.Grid.Snap( X, Y )
		Sprite.X = 0.5 * ( X + StartX )
		Sprite.Y = 0.5 * ( Y + StartY )
		Sprite.XSize = Abs( X - StartX )
		Sprite.YSize = Abs( Y - StartY )
	End Method
	
	
	
	Method EndDragging()
		If Not Sprite.XSize Or Not Sprite.YSize Then
			Editor.CurrentPage.Sprites.Remove( Sprite )
		End If
		Editor.Dragging = False
		Editor.SetSpriteModifiers( Sprite )
	End Method
End Type