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
	Const AnimationSpeed:Double = 0.1

	

	Function FromTile( TileX:Int, TileY:Int )
		Local FireFlower:TFireFlower = New TFireFlower
		FireFlower.SetAsTile( Game.TileMap, TileX, TileY )
		FireFlower.Visualizer = Game.FireFlower
		FireFlower.DX = 0
		FireFlower.AttachModel( New TAppearing )
	End Function
	
	
	
	Method Act()
		Animate( AnimationSpeed )
		Super.Act()
	End Method
	
	

	Method Collect()
		TScore.FromSprite( Self, TScore.s1000 )
		If Mario.FindModel( "TBig" ) Then
			Mario.AttachModel( New TFlashing )
		Else
			Mario.AttachModel( New TGrowing )
		End If
	End Method
End Type