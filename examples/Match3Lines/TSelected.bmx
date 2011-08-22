Type TSelected Extends LTBehaviorModel
	Const Period:Double = 0.5
	Const Bump:Double = 0.3

	Field X:Int, Y:Int
	Field StartingTime:Double
	
	Function Create:LTSprite( X:Int, Y:Int )
		Local Model:TSelected = New TSelected
		Model.X = X
		Model.Y = Y
		Model.StartingTime = Game.Time
		
		Local Sprite:LTSprite = New LTSprite
		Sprite.SetAsTile( Game.Level, X, Y )
		Game.Objects.AddLast( Sprite )
		Sprite.AttachModel( Model )
		
		Game.Level.SetTile( X, Y, 0 )
		Return Sprite
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Angle:Double = ( Game.Time - StartingTime ) * 360.0 / Period
		Shape.Visualizer.SetVisualizerScale( 1.0 + Sin( Angle ) * Bump, 1.0 + Cos( Angle ) * Bump )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.Level.SetTile( X, Y, LTSprite( Shape ).Frame )
		Game.Objects.Remove( Shape )
	End Method
End Type