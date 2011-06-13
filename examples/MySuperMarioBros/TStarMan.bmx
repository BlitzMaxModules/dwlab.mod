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
	Const Speed:Float = 2.0
	Const JumpStrength:Float = 10.0
	Const AnimationSpeed:Float = 0.2
	
	

	Function FromTile( TileX:Int, TileY:Int )
		Local StarMan:TStarMan = New TStarMan
		StarMan.SetAsTile( Game.TileMap, TileX, TileY )
		StarMan.Visualizer = Game.StarMan
		StarMan.DX = Speed
		StarMan.AttachModel( New TAppearing )
	End Function
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileShape:LTShape, TileX:Int, TileY:Int, CollisionType:Int )
		Super.HandleCollisionWithTile( TileMap, TileShape, TileX, TileY, CollisionType )
		If CollisionType = Vertical And DY >= 0.0 Then DY = -JumpStrength
	End Method
	
	
	
	Method Act()
		Animate( Game, AnimationSpeed )
		Super.Act()
	End Method
	
	
	
	Method Collect()
		Game.Mario.AttachModel( New TInvulnerable )
	End Method
End Type