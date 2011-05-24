'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TStarMan Extends TBonus
	Const JumpStrength:Float = -10.0
	Const AnimationSpeed:Float = 0.2

	

	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TStarMan
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.StarMan
	End Function
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, Shape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		If TCoin( Shape ) Then Return
		If Growing Then Return
		Super.HandleCollisionWithTile( TileMap, Shape, TileX, TileY, CollisionType )
		If CollisionType = Vertical Then
			If DY >= 0.0 Then
				DY = JumpStrength
			Else
				DY = 0.0
			End If
		End If
	End Method
	
	
	
	Method Act()
		Animate( Game, AnimationSpeed )
		Super.Act()
	End Method
	
	
	
	Method Collect()
		Game.Mario.Invulnerable = True
		Game.Mario.ModeStartingTime = Game.Time
		TScore.FromSprite( Self, TScore.s1000 )
		PlaySound( Game.Powerup )
		Game.MusicChannel.Stop()
		Game.MusicChannel = PlaySound( Game.Invulnerability )
	End Method
End Type