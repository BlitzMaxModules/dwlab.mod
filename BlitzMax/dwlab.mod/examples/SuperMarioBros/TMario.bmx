Type TMario Extends LTVectorSprite
    Method Act()
        If KeyDown( Key_Left ) Then Move( -5.0, 0 )
       If KeyDown( Key_Right ) Then Move( 5.0, 0 )
     L_CurrentCamera.JumpTo( Self )
     L_CurrentCamera.LimitWith( Game.Level.Bounds )
	 LimitHorizontallyWith( Game.Level.Bounds )
   End Method
End Type