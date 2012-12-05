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
		If Editor.CurrentTileMap And Editor.MouseIsOver = Editor.MainCanvas Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 1 ) Or MouseDown( 2 )
	End Method
	
	
	
	Method Dragging()
		Local TileMap:LTTileMap = Editor.CurrentTilemap
		If Not TileMap Then Return
		
		Local TileSet:LTTileSet = TileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
		
		Local N:Int = MouseDown( 2 )
		Local TileNum:Int = Editor.TileNum[ N ]
		Local TileX:Int = Editor.TileX
		Local TileY:Int = Editor.TileY
		Local BlockWidth:Int = 0
		Local BlockHeight:Int = 0
		If Editor.TileBlock[ N ] Then
			BlockWidth :+ Editor.TileBlock[ N ].Width
			BlockHeight :+ Editor.TileBlock[ N ].Height
		End If
		For Local DY:Int = 0 To BlockHeight
			Local Y:Int = TileY + DY
			If Y < 0 Or Y >= TileMap.YQuantity Then Continue
			For Local DX:Int = 0 To BlockWidth
				Local X:Int = TileX + DX
				If X < 0 Or X >= TileMap.XQuantity Then Continue
				TileMap.Value[ X, Y ] = L_LimitInt( TileNum + DX + DY * Image.XCells, 0, Image.FramesQuantity() - 1 )
			Next
		Next
		Editor.SetChanged()

		If Editor.ReplacementOfTiles Then
			For Local DY:Int = -3 To 3 + BlockHeight
				Local Y:Int = TileY + DY
				If Tilemap.Wrapped Then
					Y = TileMap.WrapY( Y )
				Else
					If Y < 0 Or Y >= TileMap.YQuantity Then Continue
				End If
				For Local DX:Int = -3 To 3 + BlockWidth
					Local X:Int = TileX + DX
					If Tilemap.Wrapped Then
						X = TileMap.WrapX( X )
					Else
						If X < 0 Or X >= TileMap.XQuantity Then Continue
					End If
					TileSet.Enframe( TileMap, X, Y )
				Next
			Next
		End If
	End Method
End Type





Type LTTile
	Field X:Int, Y:Int
End Type