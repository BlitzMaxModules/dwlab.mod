'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCollisionsWithAll Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
	
		VectorSprite.Move( VectorSprite.DX, 0 )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, VectorSprite.Horizontal )
		VectorSprite.CollisionsWithCollisionMap( Game.MovingObjects, VectorSprite.Horizontal )

		VectorSprite.Move( 0, VectorSprite.DY )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, VectorSprite.Vertical )
		VectorSprite.CollisionsWithCollisionMap( Game.MovingObjects, VectorSprite.Vertical )
	End Method
End Type



Type TCollisionsWithTileMap Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
	
		VectorSprite.Move( VectorSprite.DX, 0 )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, VectorSprite.Horizontal )

		VectorSprite.Move( 0, VectorSprite.DY )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, VectorSprite.Vertical )
	End Method
End Type



Type TGravity Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		LTVectorSprite( Sprite ).DY :+ L_DeltaTime * Game.Gravity
	End Method
End Type



Type TMovingAnimation Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Sprite.Animate( Game, 0.3, 2 )
	End Method
End Type



Type TRemoveIfOutside Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		If Sprite.TopY() > Game.MainLayer.Bounds.BottomY() Then
			Game.MainLayer.Remove( Sprite )
			Game.MovingObjects.RemoveSprite( Sprite )
		End If
	End Method
End Type