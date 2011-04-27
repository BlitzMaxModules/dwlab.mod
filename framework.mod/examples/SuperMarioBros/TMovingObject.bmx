'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TMario.bmx"
Include "TEnemy.bmx"
Include "TBonus.bmx"

Type TMovingObject Extends LTVectorSprite
	Method HandleCollisionWith( Obj:LTShape, CollisionType:Int )
		DX = -DX
		Visualizer.XScale = -Visualizer.XScale
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		PushFromTile( TileMap, TileX, TileY )
		If CollisionType = L_Left Or CollisionType = L_Right Then 
			DX = -DX
			Visualizer.XScale = -Visualizer.XScale
		Else
			DY = 0.0
		End If
	End Method
	
	
	
	Method Act()
		MoveForward()
		DY :+ L_DeltaTime * 32.0
	End Method
End Type