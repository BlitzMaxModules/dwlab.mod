'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TSelected Extends LTBehaviorModel
	Const Speed:Double = 2.0
	Const Bump:Double = 0.3

	Field X:Int, Y:Int
	Field StartingTime:Double
	Field Sprite:LTSprite
	
	Function Create:TSelected( X:Int, Y:Int )
		Local Model:TSelected = New TSelected
		Model.X = X
		Model.Y = Y
		Model.StartingTime = Game.Time
		Model.Sprite = Game.TileToSprite( Model, X, Y )
		Return Model
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Angle:Double = ( Game.Time - StartingTime ) * 360.0 * Speed
		Shape.Visualizer.SetVisualizerScale( 1.0 + Sin( Angle ) * Bump, 2.0 * ( 1.0 + Cos( Angle ) * Bump ) )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.HiddenBalls[ X, Y ] = False
		Game.Objects.Remove( Sprite )
	End Method
End Type