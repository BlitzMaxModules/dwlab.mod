'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
  Const MazeSize:Int = 128
  Const ZombieProbability:Double = 0.1
  
  Field World:LTWorld
  Field Walls:LTTileMap
  Field Floor:LTTileMap
  Field Objects:LTSpriteMap
  Field Zombies:Int
  Field ActingRegion:TActingRegion = New TActingRegion
  
  
  
  Method Init()
    L_InitGraphics()
    World = LTWorld.FromFile( "template.lw" )
    L_CurrentCamera = World.Camera
    L_CurrentCamera.SetSize( 16, 16 )
    L_CurrentCamera.SetCoords( MazeSize, MazeSize )
    L_CurrentCamera.Update()
    
    Floor = LTTileMap( World.FindShape( "LTTileMap,Floor" ) )
    Walls = LTTileMap( World.FindShape( "LTTileMap,Walls" ) )
    Walls.SetResolution( MazeSize, MazeSize )
    ( New TMazeGenerator ).Execute( Walls )
    Walls.Stretch( 2, 2 )
    Walls.Enframe()
    Walls.SetCoords( MazeSize, MazeSize )
    Walls.SetSize( 2.0 * MazeSize, 2.0 * MazeSize )
    
    Floor.SetResolution( 2 * MazeSize, 2 * MazeSize )
    Floor.SetCoords( MazeSize, MazeSize )
    Floor.SetSize( 2.0 * MazeSize, 2.0 * MazeSize )
    
    Objects = LTSpriteMap( World.FindShapeWithType( "LTSpriteMap" ) )
    Objects.SetResolution( MazeSize * 2, MazeSize * 2 )
    Objects.PivotMode = True
    
    Local ZombieSprite:LTSprite =  LTSprite( World.FindShape( "TZombie" ) )
    For Local Y:Int = 0 Until Walls.YQuantity
      PleaseWait()
      For Local X:Int = 0 Until Walls.XQuantity
        If Walls.Value[ X, Y ] = 1 Then Floor.Value[ X, Y ] = 1
        If Walls.Value[ X, Y ] = 1 Then
          Walls.Value[ X, Y ] = 0
          If Rnd() < ZombieProbability Then
            Local Zombie:TZombie = New TZombie
            ZombieSprite.CopyTo( Zombie )
            Zombie.X = 0.5 + X
            Zombie.Y = 0.5 + Y
            Zombie.Frame = Rand( 0, 63 )
            Zombie.Init()
            Objects.InsertSprite( Zombie )
            Zombies :+ 1
          End If
        End If
      Next
    Next
    
    ActingRegion.ShapeType = LTSprite.Rectangle
    ActingRegion.SetSize( 2.0 * L_CurrentCamera.Width, 2.0 * L_CurrentCamera.Height )
  End Method
  
  
  
  Method Logic()
    L_CurrentCamera.MoveUsingArrows( 16.0 )
    ActingRegion.JumpTo( L_CurrentCamera )
    ActingRegion.CollisionsWithSpriteMap( Objects )
    If KeyHit( Key_Escape ) Then End
  End Method
  
  
  
  Method Render()
    World.Draw()
    ShowDebugInfo()
    DrawText( "Zombies: " + Zombies, 0, 96 )
  End Method
End Type
