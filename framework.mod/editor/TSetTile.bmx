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
		If MouseDown( 1 ) Or MouseDown( 2 ) Then Return True
	End Method
	
	
	
	Method Dragging()
		Local Tilemap:LTTileMap = Editor.CurrentTilemap
		If Not Tilemap Then Return
		Local Image:LTImage = LTImageVisualizer( Tilemap.Visualizer ).Image
		Local FrameMap:LTIntMap = TileMap.FrameMap
		Local TileNum:Int = Editor.TileNum[ MouseDown( 2 ) ]
		Local TileX:Int = Editor.TileX
		Local TileY:Int = Editor.TileY
		Local BlockWidth:Int = Editor.CurrentTileset.BlockWidth[ TileNum ]
		Local BlockHeight:Int = Editor.CurrentTileset.BlockHeight[ TileNum ]
		For Local DY:Int = 0 To BlockHeight
			Local Y:Int = TileY + DY
			If Y < 0 Or Y >= FrameMap.YQuantity Then Continue
			For Local DX:Int = 0 To BlockWidth
				Local X:Int = TileX + DX
				If X < 0 Or X >= FrameMap.XQuantity Then Continue
				FrameMap.Value[ X, Y ] = L_LimitInt( TileNum + DX + DY * Editor.TilesInRow, 0, Image.FramesQuantity() - 1 )
			Next
		Next
		Editor.SetChanged()

		If Editor.CurrentTileset And MenuChecked( Editor.ReplacementOfTiles ) Then
			For Local DY:Int = -3 To 3 + BlockHeight
				Local Y:Int = TileY + DY
				If Not Tilemap.Wrapped And ( Y < 0 Or Y >= FrameMap.YQuantity ) Then Continue
				For Local DX:Int = -3 To 3 + BlockWidth
					Local X:Int = TileX + DX
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