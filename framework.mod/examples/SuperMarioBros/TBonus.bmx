'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBonus Extends TMovingObject
	Field DestinationY:Float
	Field Growing:Int = True

	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		If Growing Then Return
		Super.HandleCollisionWithTile( TileMap, TileX, TileY, CollisionType )
	End Method
	
	
	
	Method Init( TileX:Int, TileY:Int )
		SetAsTile( Game.TileMap, TileX, TileY )
		DestinationY = Y - Height
		DY = -1.0
		ShapeType = Circle
		Game.MainLayer.AddLast( Self )
		Frame = 0
	End Method
	
	
	
	Method Act()
		If Growing Then
			If Y <= DestinationY Then
				Growing = False
				DX = 2.0
				DY = 0.0
			End If
		Else
			DY :+ L_DeltaTime * 32.0
		End If
		
		Super.Act()
	End Method
	
	
	
	Method Collect()
	End Method
End Type



Type TMushroom Extends TBonus
End Type



Type TMagicMushroom Extends TMushroom
	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TMushroom
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.MagicMushroom
	End Function
End Type



Type TOneUpMushroom Extends TMushroom
	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TMushroom
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.OneUpMushroom
	End Function
End Type



Type TStarMan Extends TBonus
	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TMushroom
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.StarMan
	End Function
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		If Growing Then Return
		Super.HandleCollisionWithTile( TileMap, TileX, TileY, CollisionType )
		If CollisionType = Vertical Then
			If DY >= 0.0 Then
				DY = -10.0
			Else
				DY = 0.0
			End If
		End If
	End Method
End Type