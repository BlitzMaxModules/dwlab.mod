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
		Shape.Visualizer.SetVisualizerScale( 1.0 + Sin( Angle ) * Bump, 1.0 + Cos( Angle ) * Bump )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.Level.SetTile( X, Y, Sprite.Frame )
		Game.Objects.Remove( Sprite )
	End Method
End Type