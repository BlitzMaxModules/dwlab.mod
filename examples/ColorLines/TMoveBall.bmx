Type TMoveBall Extends LTBehaviorModel
	Const Period:Double = 0.3
	Const Bump:Double = 0.25
	
	Field X:Int, Y:Int, DX:Int, DY:Int
	Field StartingTime:Double
	Field CheckLines:Int
	
	Function Create( X:Int, Y:Int, DX:Int, DY:Int, CheckLines:Int )
		Local Model:TMoveBall = New TMoveBall
		Model.X = X
		Model.Y = Y
		Model.DX = DX
		Model.DY = DY
		Model.StartingTime = Game.Time
		Model.CheckLines = CheckLines
		Game.TileToSprite( Model, X, Y )
		Game.Busy = True
	End Function
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time > StartingTime + Period Then
			Deactivate( Shape )
		Else
			Shape.PositionOnTileMap( Game.Level, X, Y )
			Local K:Double = ( Game.Time - StartingTime ) / Period
			Shape.AlterCoords( DX * K + DY * Sin( K * 180 ) * Bump, DY * K + DX * Sin( K * 180 ) * Bump )
		End If
	End Method
	
	Method Deactivate( Shape:LTShape )
		Game.Level.SetTile( X + DX, Y + DY, LTSprite( Shape ).Frame )
		Game.Objects.Remove( Shape )
		If CheckLines Then TCheckLines.Execute()
		Game.Busy = False
		Game.Selected = Null
	End Method
End Type