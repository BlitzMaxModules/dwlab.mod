'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCollisions Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
	
		VectorSprite.Move( VectorSprite.DX, 0.0 )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, LTSprite.Horizontal )

		VectorSprite.Move( 0.0, VectorSprite.DY )
		VectorSprite.CollisionsWithTilemap( Game.Tilemap, LTSprite.Vertical )
	End Method
End Type





Type TGravity Extends LTBehaviorModel
	Method ApplyTo( Sprite:LTSprite )
		LTVectorSprite( Sprite ).DY :+ Game.PerSecond( Game.Gravity )
	End Method
End Type