'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBallTileMapVisualizer Extends LTVisualizer
	Function Create:TBallTileMapVisualizer( OldVisualizer:LTVisualizer )
		Local Visualizer:TBallTileMapVisualizer = New TBallTileMapVisualizer
		Visualizer.DX = OldVisualizer.DX
		Visualizer.DY = OldVisualizer.DY
		Visualizer.XScale = OldVisualizer.XScale
		Visualizer.YScale = OldVisualizer.YScale
		Return Visualizer
	End Function

	Method GetTileValue:Int( TileMap:LTTileMap, TileX:Int, TileY:Int )
		If Game.HiddenBalls[ TileX, TileY ] Then Return TileMap.TileSet.EmptyTile
		Return TileMap.Value[ TileX, TileY ]
	End Method
End Type