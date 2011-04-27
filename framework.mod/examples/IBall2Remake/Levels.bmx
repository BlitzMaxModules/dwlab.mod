'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function GenerateLevels()
  Game.Init()
  
  Local Num:Int = 1
  
  Local Filename:String = "levels\" + L_FirstZeroes( Num, 2 ) + ".xml"
  L_LoadFromFile( Filename )
  
  Game.CollisionMap = New LTCollisionMap
  Game.CollisionMap.SetResolution( 8, 8 )
  Game.CollisionMap.SetMapScale( 2.0, 2.0 )

  Select Num
    Case 1
      TEnemy.Create( 3.0, 2.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
      TEnemy.Create( 3.0, 5.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
      TEnemy.Create( 9.0, 6.0, TEnemy.Ufo, -2.0, 1.0, "00FF00" )
      TEnemy.Create( 9.0, 9.0, TEnemy.Ufo, -2.0, -1.0, "00FF00" )
      TMovingBlock.Create( 7.0, 4.0, 48, -1.0 )
      TEnemyGenerator.Create( 6.0, 0.0, -1, 1, TEnemy.Reel, "FFFF00" )
      
      Game.Ball.SetCoords( 0, 4.0 )
      Game.LevelTime = 90
  End Select
  Game.Objects.AddLast( Game.Ball )
    
  Game.SaveToFile( Filename )
  
  End
End Function