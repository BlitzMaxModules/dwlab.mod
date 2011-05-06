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
	Field TileX:Int, TileY:Int, TileNum:Int
	Field RemovingTime:Float
	
	
	
	Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
		Local Block:TBlock = New TBlock
		Block.SetAsTile( Game.TileMap, TileX, TileY )
		Game.TileMap.SetTile( TileX, TileY, 63 )
		Block.TileX = TileX
		Block.TileY = TileY
		Block.RemovingTime = Game.Time + 2.0
		Block.LowestY = Block.Y
		Block.Y :- 0.01
		Block.DY = -1.0
		Block.Frame = 48
		
		Select TileNum
			Case 9
				TCoin.FromTile( TileX, TileY )
			Case 11
				If Game.Mario.Big Then
					TFireFlower.FromTile( TileX, TileY )
				Else
					TMagicMushroom.FromTile( TileX, TileY )
				End If
			Case 13
				TOneUpMushroom.FromTile( TileX, TileY )
			Case 18
				TStarMan.FromTile( TileX, TileY )
			Case 10, 27
				Block.Frame = TileNum 
		End Select
		
		If ( TileNum = 10 Or TileNum = 27 ) And Game.Mario.Big Then
			Game.BreakBlock.Play()
			TBricks.FromTile( TileX, TileY, TileNum )
		Else
			Game.Bump.Play()
			Game.MainLayer.AddLast( Block )
		End If
	End Function
	
	
	
	Method Act()
		DY :+ 5.0 * L_DeltaTime
		If Y >= LowestY Then
			Y = LowestY
			Game.Tilemap.SetTile( TileX, TileY, Frame )
			If Frame = 10 Or Frame = 27 Or RemovingTime < Game.Time Then Game.MainLayer.Remove( Self )
		Else
			MoveForward()
		End If
	End Method
End Type