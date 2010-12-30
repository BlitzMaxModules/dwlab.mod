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

Type LTSetTile Extends LTDrag
	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditTilemap ) And Editor.MouseIsOver = Editor.MainCanvas Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Or MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method Dragging()
		Editor.CurrentPage.Tilemap.FrameMap.Value[ Editor.TileX, Editor.TileY ] = Editor.TileNum[ MouseDown( 2 ) ]
	End Method
End Type