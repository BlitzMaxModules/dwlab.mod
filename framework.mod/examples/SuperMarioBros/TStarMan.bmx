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
	Const JumpStrength:Float = -16.0
	Const AnimationSpeed:Float = 0.2

	

	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TStarMan
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.StarMan
	End Function
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
		If Growing Then Return
		Super.HandleCollisionWithTile( TileMap, TileX, TileY, CollisionType )
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
		Game.MusicChannel.Stop()
		Game.MusicChannel = PlaySound( Game.Invulnerability )
		Game.Mario.Invulnerable = True
		Game.Mario.ModeStartingTime = Game.Time
	End Method
End Type