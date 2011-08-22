Type TSelected Extends LTBehaviorModel
	Field StartingTime:Double
	Field Sprite:LTSprite = New LTSprite
	
	Method Create( X:Int, Y:Int )
		StartingTime = Game.Time
		Sprite.SetAsTile( Game.Level, X, Y )
	End Method
	
	Method ApplyTo( Shape:LTShape )
		
	End Method
End Type