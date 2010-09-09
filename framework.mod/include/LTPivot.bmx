'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPivot Extends LTShape
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingPivot( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingPivot( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Shape:LTShape )
		Return Shape.CollidesWithPivot( Self )
	End Method

	
	
	Method CollidesWithPivot:Int( Piv:LTPivot )
		If L_PivotWithPivot( Self, Piv ) Then Return True
	End Method

	
	
	Method CollidesWithCircle:Int( Circ:LTCircle )
		If L_PivotWithCircle( Self, Circ ) Then Return True
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		If L_PivotWithRectangle( Self, Rectangle ) Then Return True
	End Method
	
	' ==================== Collision map ===================
	
	Method InsertIntoMap( Map:LTCollisionMap )
		Map.InsertPivot( Self )
	End Method
	
	
	
	Method RemoveFromMap( Map:LTCollisionMap )
		Map.RemovePivot( Self )
	End Method
	
	
	
	Method Collisions( Map:LTCollisionMap )
		Map.CollisionsWithPivot( Self )
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
	End Method
	
	' ==================== Angle ====================

	' ==================== Other ====================
	
	Method CloneShape:LTShape( DX:Float, DY:Float, XK:Float, YK:Float )
		Local Pivot:LTPivot = New LTPivot
		Pivot.X = DX + X
		Pivot.Y = DX + Y
		Return Pivot
	End Method
End Type





Type LTMovePivot Extends LTAction
	Field Pivot:LTPivot
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:LTMovePivot( Pivot:LTPivot, X:Float = 0, Y:Float = 0 )
		Local Action:LTMovePivot = New LTMovePivot
		Action.Pivot = Pivot
		Action.OldX = Pivot.X
		Action.OldY = Pivot.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Pivot.X = NewX
		Pivot.Y = NewY
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Pivot.X = OldX
		Pivot.Y = OldY
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type