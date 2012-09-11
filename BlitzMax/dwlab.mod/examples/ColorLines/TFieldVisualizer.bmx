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
		GameCamera.FieldToScreen( X, Y, SX, SY )
		
		Local TileValue:Int = GetTileValue( Profile.GameField, TileX, TileY )
		If TileValue > 0 Then
			Local TileVisualizer:LTVisualizer = Profile.GameField.Visualizer
			Local TileWidth:Double =  Width * TileVisualizer.XScale
			Local TileHeight:Double = Height * TileVisualizer.YScale
			Profile.GameField.TileSet.Image.Draw( SX + TileVisualizer.DX * TileWidth, SY + TileVisualizer.DY * TileHeight, ..
					TileWidth, TileHeight, TileValue )
			if( TileX = Game.SelectedTileX And TileY = Game.SelectedTileY ) Then Profile.GameField.TileSet.Image.Draw( ..
					SX + TileVisualizer.DX * TileWidth, SY + TileVisualizer.DY * TileHeight, TileWidth, TileHeight, Profile.TileCursor )
		End If
		
		If Not Game.HiddenBalls[ TileX, TileY ] Then
			Local BallValue:Int = GetTileValue( Profile.Balls, TileX, TileY )
			If BallValue > 0 Then
				Local Visualizer:LTVisualizer = Profile.Balls.Visualizer
				Local NewWidth:Double =  Width * Visualizer.XScale
				Local NewHeight:Double = Height * Visualizer.YScale
				Profile.Balls.TileSet.Image.Draw( SX + Visualizer.DX * NewWidth, SY + Visualizer.DY * NewHeight, ..
						NewWidth, NewHeight, BallValue )
				Local ModifierNum:Int = GetTileValue( Profile.Modifiers, TileX, TileY )
				If ModifierNum > 0 Then Profile.Modifiers.TileSet.Image.Draw( SX + Visualizer.DX * NewWidth, ..
						SY + Visualizer.DY * NewHeight, NewWidth, NewHeight, ModifierNum )
			End If
		End If
		
		Width = TileMap.GetTileWidth()
		Height = TileMap.GetTileHeight()
		For Local Sprite:LTSprite = Eachin Game.Objects
			If L_DoubleInLimits( Sprite.X, X - 0.95 * Width, X + 0.05 * Width + ( TileX = TileMap.XQuantity - 1 ) ) And ..
					L_DoubleInLimits( Sprite.Y, Y - 0.95 * Height, Y + 0.05 * Height + ( TileY = TileMap.YQuantity - 1 ) ) Then Sprite.Draw()
		Next
	End Method
End Type