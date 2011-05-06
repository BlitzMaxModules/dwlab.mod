'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TFireFlower Extends TBonus
	Const AnimationSpeed:Float = 0.1

	

	Function FromTile( TileX:Int, TileY:Int )
		Local Bonus:TBonus = New TFireFlower
		Bonus.Init( TileX, TileY )
		Bonus.Visualizer = Game.FireFlower
		Bonus.DX = 0.0
	End Function
	
	
	
	Method Act()
		Animate( Game, AnimationSpeed )
		Super.Act()
	End Method
	
	
	
	Method Collect()
		If Game.Mario.Big Then
			Game.Mario.Mode = Game.Mario.FireGaining
			Game.Mario.AnimationStartingTime = Game.Time
		Else
			Game.Mario.SetGrowth()
		End If
		PlaySound( Game.Powerup )
	End Method
End Type