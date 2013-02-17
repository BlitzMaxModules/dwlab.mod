Type TGravity Extends LTBehaviorModel
   Method ApplyTo( Shape:LTShape )
       LTVectorSprite( Shape ).DY :+ Game.PerSecond( Game.Gravity )
   End Method
End Type