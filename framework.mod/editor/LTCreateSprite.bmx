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
	Field Sprite:LTActor
	
	
	
	Method DragKey:Int()
		If MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditSprites ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
		Editor.Grid.Snap( StartX, StartY )
		
		Local CurrentSprite:LTActor = Editor.CurrentSprite
		If CurrentSprite Then
			Sprite = New LTActor
			Sprite.Shape = CurrentSprite.Shape
			Sprite.Angle = CurrentSprite.Angle
			Sprite.Velocity = CurrentSprite.Velocity
			Sprite.Frame = CurrentSprite.Frame
		
			Local CurrentSpriteVisualizer:LTImageVisualizer = LTImageVisualizer( CurrentSprite.Visualizer )
			Local Visualizer:LTImageVisualizer = New LTImageVisualizer
			Visualizer.Red = CurrentSpriteVisualizer.Red
			Visualizer.Green = CurrentSpriteVisualizer.Green
			Visualizer.Blue = CurrentSpriteVisualizer.Blue
			Visualizer.Alpha = CurrentSpriteVisualizer.Alpha
			Visualizer.XScale = CurrentSpriteVisualizer.XScale
			Visualizer.Image = CurrentSpriteVisualizer.Image
			Sprite.Visualizer = Visualizer
			
			Local NamePrefix:String = L_GetPrefix( CurrentSprite.GetName() )
			Local NameNumber:Int = L_GetNumber( CurrentSprite.GetName() )
			Local SpriteName:String
			Repeat
				NameNumber :+ 1
				SpriteName = NamePrefix + NameNumber
				If Not FindByName( SpriteName ) Then Exit
			Forever
			Sprite.SetName( SpriteName )
		Else
			Sprite = New LTActor
			Sprite.Visualizer = New LTImageVisualizer
			Sprite.SetName( "Sprite1" )
		End If
		
		Editor.CurrentPage.Sprites.AddLast( Sprite )
		Editor.SelectSprite( Sprite )
		Editor.RefreshSpritesList()
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
		Else
			While Not LTImageVisualizer( Sprite.Visualizer ).Image
				Editor.SpriteImageProperties( Sprite )
			WEnd
		End If
		Editor.SetSpriteModifiers( Sprite )
	End Method
End Type