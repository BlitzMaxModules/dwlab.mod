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

Type LTModifySprite Extends LTDrag
	Field StartX:Float
	Field StartY:Float
	Field Sprite:LTSprite
	Field ModifierType:Int
	Field MDX:Int, MDY:Int
	Field SpriteStartX:Float, SpriteStartY:Float
	Field SpriteStartXSize:Float, SpriteStartYSize:Float
	
	
	
	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditSprites ) And Not Editor.Modifiers.IsEmpty() Then
			For Local Modifier:LTActor = Eachin Editor.Modifiers
				Local MX:Float, MY:Float
				L_CurrentCamera.FieldToScreen( Modifier.X, Modifier.Y, MX, MY )
				If MouseX() >= MX - 8 And MouseX() <= MX + 8 And MouseY() >= MY - 8 And MouseY() <= MY + 8 Then
					ModifierType = Modifier.Frame
					
					Local SX:Float, SY:Float
					Sprite = LTSprite( Editor.SelectedSprites.First() )
					L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX, SY )
					MDX = Sgn( MX - SX )
					MDY = Sgn( MY - SY )
					
					L_CurrentCamera.ScreenToField( MouseX(), MouseY(), StartX, StartY )
					
					SpriteStartX = Sprite.X
					SpriteStartY = Sprite.Y
					SpriteStartXSize = Sprite.XSize
					SpriteStartYSize = Sprite.YSize
					Editor.Dragging = True
					
					Return True
				End If
			Next
		End If
	End Method
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method StartDragging()
		DraggingState = False
	End Method
	
	
	
	Method Dragging()
		Local X:Float, Y:Float, DX:Float, DY:Float
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		DX = X - StartX
		DY = Y - StartY
		Editor.Grid.Snap( DX, DY )
		
		Select ModifierType
			Case 0
				Sprite.X = SpriteStartX + DX
				Sprite.Y = SpriteStartY + DY
		End Select
	End Method
	
	
	
	Method EndDragging()
		Select ModifierType
			Case 8
				Sprite.Angle :- 45
			Case 9
				Sprite.Angle :+ 45
		End Select
		
		If Not Sprite.XSize Or Not Sprite.YSize Then
			Sprite.X = SpriteStartX
			Sprite.Y = SpriteStartY
			Sprite.XSize = SpriteStartXSize
			Sprite.YSize = SpriteStartYSize
		End If
		Editor.Dragging = False
		Editor.SetSpriteModifiers( Sprite )
	End Method
End Type