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
	Method Act()
		Local D:Double = Game.PerSecond( Friction )
		If Abs( DX ) < D Then DX = 0.0 Else DX :- Sgn( DX ) * D
		If Abs( DY ) < D Then DY = 0.0 Else DY :- Sgn( DY ) * D
		
		If DX <> 0.0 Or DY <> 0.0 Then
			Move( DX, DY )
			Game.ActingMap.Insert( Self, Null )
		End If
		
		CollisionsWithSpriteMap( Game.Blocks, CollisionWithBlock )
		CollisionsWithSpriteMap( Game.Trees, CollisionWithTree )
	End Method
	
	
	
	Method Draw()
		If ShapeType = LTSprite.Rectangle Then Frame = Floor( Game.Time / BlinkingSpeed ) Mod 2
		Super.Draw()
	End Method
End Type



Global CollisionWithBlock:TCollisionWithBlock = New TCollisionWithBlock
Type TCollisionWithBlock Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.WedgeOffWithSprite( Sprite2, Sprite1.Height * Sprite1.Width, Sprite2.Height * Sprite2.Width )
		Game.ActingMap.Insert( Sprite1, Null )
		Game.ActingMap.Insert( Sprite2, Null )
		Local Block:TBlock = TBlock( Sprite1 )
		Block.DX :* ( 1.0 - Game.PerSecond( 0.4 ) )
		Block.DY :* ( 1.0 - Game.PerSecond( 0.4 ) )
	End Method
End Type



Global CollisionWithTree:TCollisionWithTree = New TCollisionWithTree
Type TCollisionWithTree Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Sprite1.PushFromSprite( Sprite2 )
		Local Block:TBlock = TBlock( Sprite1 )
		Block.DX :* ( 1.0 - Game.PerSecond( 0.4 ) )
		Block.DY :* ( 1.0 - Game.PerSecond( 0.4 ) )
	End Method
End Type