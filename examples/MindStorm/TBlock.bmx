'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBlock Extends LTVectorSprite
	Field BlinkingSpeed:Double = Rnd( 0.1, 0.8 )
	Field Friction:Double = 15.0


	Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
		If TTree( Sprite ) Then
			PushFromSprite( Sprite )
		Else
			WedgeOffWithSprite( Sprite, Height * Width, Sprite.Height * Sprite.Width )
			Game.ActingMap.Insert( Self, Null )
			Game.ActingMap.Insert( Sprite, Null )
		End If
		DX :* ( 1.0 - Game.PerSecond( 0.4 ) )
		DY :* ( 1.0 - Game.PerSecond( 0.4 ) )
	End Method
	
	
	
	Method Act()
		Local D:Double = Game.PerSecond( Friction )
		If Abs( DX ) < D Then DX = 0.0 Else DX :- Sgn( DX ) * D
		If Abs( DY ) < D Then DY = 0.0 Else DY :- Sgn( DY ) * D
		
		If DX <> 0.0 Or DY <> 0.0 Then
			Move( DX, DY )
			Game.ActingMap.Insert( Self, Null )
		End If
		
		CollisionsWithSpriteMap( Game.Blocks )
		CollisionsWithSpriteMap( Game.Trees )
	End Method
	
	
	
	Method Draw()
		If ShapeType = LTSprite.Rectangle Then Frame = Floor( Game.Time / BlinkingSpeed ) Mod 2
		Super.Draw()
	End Method
End Type