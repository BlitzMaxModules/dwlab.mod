'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TFallIntoPocket extends LTBehaviorModel
	Const Speed:Double = 0.5
	
	Field Foreground:LTSprite = New LTSprite
	Field TileX:Int, TileY:Int
	
	Function Create:TFallIntoPocket( TileX:Int, TileY:Int )
		Local Model:TFallIntoPocket = New TFallIntoPocket
		Model.TileX = TileX
		Model.TileY = TileY
		Model.Foreground.SetAsTile( Profile.GameField, TileX, TileY )
		Model.Foreground.Frame = Profile.PocketForeground
		Game.Objects.AddLast( Model.Foreground )
		Profile.GameField.SetTile( TileX, TileY, Profile.Pocket )
		Profile.Balls.SetTile( TileX, TileY, Profile.NoBall )
		Return Model
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visualizer.DY :+ L_PerSecond( Speed )
		if Shape.Visualizer.DY >= 0.5 Then Remove( Shape )
	End Method

	Method Deactivate( Shape:LTShape )
		Game.Objects.Remove( Foreground )
		Game.Objects.Remove( Shape )
		Profile.GameField.SetTile( TileX, TileY, Profile.Plate )
		For Local Goal:TPutBallsInHoles = Eachin Profile.Goals
			Goal.Count :- 1
		Next
	End Method
End Type