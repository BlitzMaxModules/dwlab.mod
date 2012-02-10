'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TFieldVisualizer Extends LTVisualizer
	Function Create:TFieldVisualizer( OldVisualizer:LTVisualizer )
		Local Visualizer:TFieldVisualizer = New TFieldVisualizer
		Visualizer.DX = OldVisualizer.DX
		Visualizer.DY = OldVisualizer.DY
		Visualizer.XScale = OldVisualizer.XScale
		Visualizer.YScale = OldVisualizer.YScale
		Return Visualizer
	End Function
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		ApplyColor()
		
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		Local TileValue:Int = GetTileValue( Game.GameField, TileX, TileY )
		If TileValue > 0 Then
			Local Visualizer:LTVisualizer = Game.GameField.Visualizer
			Local NewWidth:Double =  Width * Visualizer.XScale
			Local NewHeight:Double = Height * Visualizer.YScale
			Game.GameField.TileSet.Image.Draw( SX + Visualizer.DX * NewWidth, SY + Visualizer.DY * NewHeight, ..
					NewWidth, NewHeight, TileValue )
			if( TileX = Game.SelectedTileX And TileY = Game.SelectedTileY ) Then Game.GameField.TileSet.Image.Draw( ..
					SX + Visualizer.DX * NewWidth, SY + Visualizer.DY * NewHeight, NewWidth, NewHeight, Game.TileCursor )
		End If
		
		If Not Game.HiddenBalls[ TileX, TileY ] Then
			TileValue = GetTileValue( Game.Balls, TileX, TileY )
			If TileValue > 0 Then
				Local Visualizer:LTVisualizer = Game.Balls.Visualizer
				Local NewWidth:Double =  Width * Visualizer.XScale
				Local NewHeight:Double = Height * Visualizer.YScale
				Game.Balls.TileSet.Image.Draw( SX + Visualizer.DX * NewWidth, SY + Visualizer.DY * NewHeight, NewWidth, NewHeight, TileValue )
			End If
		End If
		
		Width = TileMap.GetTileWidth()
		Height = TileMap.GetTileHeight()
		For Local Sprite:LTSprite = Eachin Game.Objects
			If L_DoubleInLimits( Sprite.X, X - 0.5 * Width, X + 0.5 * Width ) And L_DoubleInLimits( Sprite.Y, Y - 0.5 * Height, Y + 0.5 * Height ) Then
				Sprite.Draw()
			End If
		Next
	End Method
End Type