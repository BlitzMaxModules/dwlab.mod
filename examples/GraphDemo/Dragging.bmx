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
  Field Pivot:LTSprite
  Field MoveSprite:LTMoveSprite
  
  
  Method DragKey:Int()
    If MouseDown( 1 ) Then Return True
  End Method
  
  
  
  Method DraggingConditions:Int()
    If Editor.CurrentPivot Then Return True
  End Method
  
  
  
  Method StartDragging()
    DX = Editor.CurrentPivot.X - Editor.Cursor.X
    DY = Editor.CurrentPivot.Y - Editor.Cursor.Y
    Pivot = Editor.CurrentPivot
    MoveSprite = LTMoveSprite.Create( Pivot )
  End Method
  
  
  
  Method Dragging()
    Pivot.X = Editor.Cursor.X + DX
    Pivot.Y = Editor.Cursor.Y + DY
  End Method
  
  
  
  Method EndDragging()
    MoveSprite.NewX = Pivot.X
    MoveSprite.NewY = Pivot.Y
    MoveSprite.Do()
  End Method
End Type





Type TMakeLine Extends LTDrag
  Field Line:LTLine
  
  
  
  Method DragKey:Int()
    If MouseDown( 2 ) Then Return True
  End Method
  
  
  
  Method DraggingConditions:Int()
    If Editor.CurrentPivot Then Return True
  End Method
  
  
  
  Method StartDragging()
    Line = New LTLine
    Line.Pivot[ 0 ] = Editor.CurrentPivot
    Line.Pivot[ 1 ] = Editor.Cursor
  End Method
  
  
  
  Method Dragging()
    'debugstop
  End Method
  
  
  
  Method EndDragging()
    If Editor.CurrentPivot Then
      Line.Pivot[ 1 ] = Editor.CurrentPivot
      If Not Shared.Graph.FindLine( Line.Pivot[ 0 ], Line.Pivot[ 1 ] ) Then LTAddLineToGraph.Create( Shared.Graph, Line ).Do()
    End If
  End Method
End Type