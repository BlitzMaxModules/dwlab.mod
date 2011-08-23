Type TPopUpBall Extends LTBehaviorModel
	Const Period:Double = 0.15
	Const StartingAngle:Double = 45
	Const EndingAngle:Double = 120
	
	Field X:Int, Y:Int
	Field StartingTime:Double
	
	Function Create:TPopUpBall( X:Int, Y:Int, TileNum:Int )
		Local Model:TPopUpBall = New TPopUpBall
		Model.X = X
		Model.Y = Y
		Model.StartingTime = Game.Time
		
		Local Sprite:LTSprite = New LTSprite
		Sprite.SetAsTile( Game.Level, X, Y )
		Sprite.Visualizer.SetVisualizerScales( 0.0 )
		Sprite.Frame = TileNum
		Sprite.AttachModel( Model )
		
		Game.Objects.AddLast( Sprite )
		Game.Busy = True
	End Function
	
	Method ApplyTo( Shape:LTShape )
		Local Angle:Double = StartingAngle + ( Game.Time - StartingTime ) * ( EndingAngle - StartingAngle ) / Period
		Shape.Visualizer.SetVisualizerScales( Sin( Angle ) / Sin( EndingAngle ) )
		If Game.Time > StartingTime + Period Then Remove( Shape )
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.Level.SetTile( X, Y, LTSprite( Shape ).Frame )
		Game.Objects.Remove( Shape )
		Game.Busy = False
	End Method
End Type