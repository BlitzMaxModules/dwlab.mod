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
Type TSetTile Extends LTDrag
	Method DraggingConditions:Int()
		If MenuChecked( Editor.EditTilemap ) And Editor.MouseIsOver = Editor.MainCanvas Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		If MouseDown( 1 ) Or MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method Dragging()
		Local Tilemap:LTTileMap = Editor.CurrentPage.Tilemap
		If Not Tilemap Then Return
		Local FrameMap:LTIntMap = TileMap.FrameMap
		FrameMap.Value[ Editor.TileX, Editor.TileY ] = Editor.TileNum[ MouseDown( 2 ) ]
		Editor.SetChanged()

		If Editor.CurrentTileset And MenuChecked( Editor.ReplacementOfTiles ) Then
			For Local DY:Int = -3 To 3
				If Not Tilemap.Wrapped And ( Editor.TileY + DY < 0 Or Editor.TileY + DY >= FrameMap.YQuantity ) Then Continue
				For Local DX:Int = -3 To 3
					Local X:Int = Editor.TileX + DX
					Local Y:Int = Editor.TileY + DY
					If Tilemap.Wrapped Then
						If FrameMap.Masked Then
							X = X & FrameMap.XMask
							Y = Y & FrameMap.YMask
						Else
							X = FrameMap.WrapX( X )
							Y = FrameMap.WrapY( Y )
						End If
					Else
						If X < 0 Or X >= FrameMap.XQuantity Then Continue
					End If
					Editor.TilesQueue.Insert( String( X + Y * FrameMap.XQuantity ), Null )
				Next
			Next
		End If
	End Method
End Type



Type LTTile
	Field X:Int, Y:Int
End Type