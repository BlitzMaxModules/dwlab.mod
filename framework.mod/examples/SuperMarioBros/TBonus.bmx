'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TMagicMushroom.bmx"
Include "TFireFlower.bmx"
Include "TOneUpMushroom.bmx"
Include "TStarMan.bmx"

Type TBonus Extends TMovingObject
	Field DestinationY:Float
	Field Growing:Int = True
	
	
	
	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
	End Method

	
	
	Method Init( TileX:Int, TileY:Int )
		SetAsTile( Game.TileMap, TileX, TileY )
		DestinationY = Y - Height
		DY = -1.0
		ShapeType = Circle
		Frame = 0
		
		Game.MainLayer.AddLast( Self )
		PlaySound( Game.PowerupAppears )
	End Method

	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		If TCoin( Shape ) Then Return
		If Growing Then Return
		Super.HandleCollisionWithTile( TileMap, Shape, TileX, TileY, CollisionType )
	End Method
	
	
	
	Method Act()
		If CollidesWithSprite( Game.Mario ) Then
			Collect()
			Game.MainLayer.Remove( Self )
		End If
			
		If Growing Then
			If Y <= DestinationY Then
				Growing = False
				If Not TFireFlower( Self ) Then DX = 2.0
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