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
		Model.Foreground.SetAsTile( Game.GameField, TileX, TileY )
		Model.Foreground.Frame = Game.HoleForeground
		Game.Objects.AddLast( Model.Foreground )
		Game.GameField.SetTile( TileX, TileY, Game.Hole )
		Game.Balls.SetTile( TileX, TileY, Game.NoBall )
		Return Model
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Shape.Visualizer.DY :+ L_PerSecond( Speed )
		if Shape.Visualizer.DY >= 0.5 Then Remove( Shape )
	End Method

	Method Deactivate( Shape:LTShape )
		Game.Objects.Remove( Foreground )
		Game.Objects.Remove( Shape )
		Game.GameField.SetTile( TileX, TileY, Game.Plate )
	End Method
End Type