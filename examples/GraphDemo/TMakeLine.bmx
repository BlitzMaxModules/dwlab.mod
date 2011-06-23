'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMakeLine Extends LTDrag
	Field Line:LTLine
	
	
	
	Method DragKey:Int()
		If MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method DraggingConditions:Int()
		If Game.CurrentPivot Then Return True
	End Method
	
	
	
	Method StartDragging()
		Line = New LTLine
		Line.Pivot[ 0 ] = Game.CurrentPivot
		Line.Pivot[ 1 ] = Game.Cursor
	End Method
	
	
	
	Method Dragging()
		'debugstop
	End Method
	
	
	
	Method EndDragging()
		If Game.CurrentPivot Then
			Line.Pivot[ 1 ] = Game.CurrentPivot
			If Not game.Map.FindLine( Line.Pivot[ 0 ], Line.Pivot[ 1 ] ) Then LTAddLineToGraph.Create( Game.Map, Line ).Do()
		End If
	End Method
End Type