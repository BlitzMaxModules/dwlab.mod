'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBlock Extends LTVectorSprite
	Field LowestY:Float
	Field TileX:Int, TileY:Int
	Field CreatingTime:Float
	
	
	
	Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
		Select TileNum
			Case 9
				TCoin.FromTile( TileX, TileY )
			Case 11
				TMagicMushroom.FromTile( TileX, TileY )
			Case 13
				TOneUpMushroom.FromTile( TileX, TileY )
			Case 18
				TStarMan.FromTile( TileX, TileY )
		End Select
		
		Local Block:TBlock = New TBlock
		Block.SetAsTile( Game.TileMap, TileX, TileY )
		Game.TileMap.SetTile( TileX, TileY, 63 )
		Block.TileX = TileX
		Block.TileY = TileY
		Block.CreatingTime = Game.Time
		Block.LowestY = Block.Y
		Block.Y :- 0.01
		Block.DY = -1.0
		Block.Frame = 48
		Game.MainLayer.AddLast( Block )
	End Function
	
	
	
	Method Act()
		DY :+ 5.0 * L_DeltaTime
		If Y >= LowestY Then
			Y = LowestY
			Game.Tilemap.SetTile( TileX, TileY, 48 )
		Else
			MoveForward()
		End If
		If CreatingTime + 2.0 < Game.Time Then Game.DestroySprite( Self )
	End Method
End Type