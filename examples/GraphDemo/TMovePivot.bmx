'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMovePivot Extends LTDrag
	Field DX:Double
	Field DY:Double
	Field MovingPivot:LTSprite
	Field MovePivotAction:TMovePivotAction
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Game.CurrentPivot Then Return True
	End Method
	
	
	
	Method StartDragging()
		DX = Game.CurrentPivot.X - Game.Cursor.X
		DY = Game.CurrentPivot.Y - Game.Cursor.Y
		MovingPivot = Game.CurrentPivot
		MovePivotAction = TMovePivotAction.Create( MovingPivot )
	End Method
	
	
	
	Method Dragging()
		MovingPivot.X = Game.Cursor.X + DX
		MovingPivot.Y = Game.Cursor.Y + DY
	End Method
	
	
	
	Method EndDragging()
		MovePivotAction.NewX = MovingPivot.X
		MovePivotAction.NewY = MovingPivot.Y
		MovePivotAction.Do()
	End Method
End Type





Type TMovePivotAction Extends LTAction
	Field Sprite:LTSprite
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:TMovePivotAction( Sprite:LTSprite, X:Float = 0, Y:Float = 0 )
		Local Action:TMovePivotAction = New TMovePivotAction
		Action.Sprite = Sprite
		Action.OldX = Sprite.X
		Action.OldY = Sprite.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Sprite.SetCoords( NewX, NewY )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Sprite.SetCoords( OldX, OldY )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type