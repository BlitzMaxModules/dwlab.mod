Type TTrigger Extends LTVectorSprite
   Method Act()
       If CollidesWithSprite( L_CurrentCamera ) Then
           Local Group:String = GetParameter( "group" )
           For Local Sprite:LTVectorSprite = Eachin Game.MovingObjects
               If Sprite.GetParameter( "group" ) = Group Then Sprite.Active = True
           Next
           Game.Level.Remove( Self )
       End If
   End Method
End Type