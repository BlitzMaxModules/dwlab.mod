'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TEnemy Extends TGameSprite
  Field ChangeFacing:Int
  Field Bulletproof:Int
  
  
  
  Const Angel:Int = 0
  Const BallWithSquare:Int = 1
  Const BeachBall:Int = 2
  Const Mushroom:Int = 3
  Const Pacman:Int = 4
  Const Pad:Int = 5
  Const Reel:Int = 6
  Const Sandwitch:Int = 7
  Const Ufo:Int = 8
  
  
  
  Function Create:TEnemy( X:Double, Y:Double, EnemyType:Int, DX:Double, DY:Double, HexColor:String )
    Local Enemy:TEnemy = New TEnemy
    Enemy.SetCoords( X, Y )
    Enemy.SetDXDY( DX, DY )
    Enemy.SetDiameter( 0.95 )
    
    Local ImageVisualizer:LTImageVisualizer = New LTImageVisualizer
    ImageVisualizer.Image = Game.EnemyImage[ EnemyType ]
    ImageVisualizer.Rotating = False
    ImageVisualizer.SetColorFromHex( HexColor )
    Enemy.Visualizer = ImageVisualizer
    
    Select EnemyType
      Case Sandwitch, Pad
        Enemy.Shape = L_Rectangle
      Default
        Enemy.Shape = L_Circle
    End Select
    
    Select EnemyType
      Case Angel, Mushroom, Sandwitch
        Enemy.ChangeFacing = True
    End Select
    
    Game.CollisionMap.InsertSprite( Enemy )
    Game.Objects.AddLast( Enemy )
    Return Enemy
  End Function
  
  
  
  Method Bounce( DX:Double, DY:Double )
    If Abs( DY ) > Abs( DX ) Then
      SetDY( -GetDY() )
    Else
      SetDX( -GetDX() )
    End If
  End Method
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite )
    If TBall( Sprite ) Then
      Sprite.Destroy()
    Else
      WedgeOffWith( Sprite, 0.0, 1.0 )
      Bounce( X - Sprite.X, Y - Sprite.Y )
    End If
  End Method
  
  
  
  Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
    PushFromTile( TileMap, TileX, TileY )
    Local Sprite:LTSprite = TileMap.GetTile( TIleX, TileY )
    Bounce( X - Sprite.X, Y - Sprite.Y )
  End Method
  
  
  
  Method Act()
    'debugstop
    MoveForward()
    If ChangeFacing Then Visualizer.XScale = Sgn( GetDX() )
    Frame = L_WrapInt( Floor( X * 8.0 ), 4 )
    
    'CollisionsWith( Game.CollisionMap )
    CollisionsWith( Game.TileMap )
  End Method
  
  
  
  Method XMLIO( XMLObject:LTXMLObject )
    Super.XMLIO( XMLObject )
    
    XMLObject.ManageIntAttribute( "changefacing", ChangeFacing )
    XMLObject.ManageIntAttribute( "bulletproof", Bulletproof )
  End Method
End Type





Type TEnemyGenerator Extends LTSprite
  Field GenerationStartTime:Double
  Field NextEnemy:Double
  Field EnemyType:Int
  Field EnemyColor:String
  Field EnemyTemplate:LTSprite
  
  Const GenerationTime:Double = 1.5
  Const GenerationSpeed:Double = 72.0
  Const FromPeriod:Double = 1.0
  Const ToPeriod:Double = 20.0
  
  
  
  Function Create:TEnemyGenerator( X:Double, Y:Double, DX:Double, DY:Double, EnemyType:Int, EnemyColor:String )
    Local Generator:TEnemyGenerator = New TEnemyGenerator
    Generator.SetCoords( X, Y )
    Generator.SetDXDY( DX, DY )
    Generator.EnemyType = EnemyType
    Generator.EnemyColor = EnemyColor
    Generator.Visualizer = LTImageVisualizer.FromImage( Game.GeneratorImage )
    Game.Objects.AddLast( Generator )
    Return Generator
  End Function
  
  
  
  Method Act()
    If GenerationStartTime Then
      Frame = L_WrapInt2( Floor( ( Game.ProjectTime - GenerationStartTime ) * GenerationSpeed ), 18, 36 )
      If Game.ProjectTime > GenerationStartTime + GenerationTime Then
        Local Collision:Int = False
        For Local Sprite:LTSprite = Eachin Game.Objects
          If EnemyTemplate.CollidesWith( Sprite ) And Sprite <> Self Then
            Collision = True
            Exit
          End If
        Next
        
        If Not Collision Then
          TEnemy.Create( X, Y, EnemyType, GetDX(), GetDY(), EnemyColor )
          NextEnemy = Game.ProjectTime + Rnd( FromPeriod, ToPeriod )
          GenerationStartTime = 0
          Frame = 0
          EnemyTemplate.Visualizer.Alpha = 0.0
        Else
          EnemyTemplate.Visualizer.Alpha = 1.0
        End If
      Else
        EnemyTemplate.Visualizer.Alpha = 1.0 * ( Game.ProjectTime - GenerationStartTime ) / GenerationTime
      End If
    ElseIf NextEnemy < Game.ProjectTime Then
      GenerationStartTime = Game.ProjectTime
      EnemyTemplate = New LTSprite
      EnemyTemplate.Visualizer = LTImageVisualizer.FromImage( Game.EnemyImage[ EnemyType ] )
      EnemyTemplate.SetCoords( X, Y )
      EnemyTemplate.SetSize( 1.0, 1.0 )
      EnemyTemplate.Shape = L_Rectangle
      EnemyTemplate.Visualizer.SetColorFromHex( EnemyColor )
      EnemyTemplate.Visualizer.Alpha = 0.0
    End If
  End Method
  
  
  
  Method Draw()
    EnemyTemplate.Draw()
    Super.Draw()
  End Method
  
  
  
  Method XMLIO( XMLObject:LTXMLObject )
    Super.XMLIO( XMLObject )
    
    XMLObject.ManageIntAttribute( "enemy-type", EnemyType )
    XMLObject.ManageStringAttribute( "enemy-color", EnemyColor )
  End Method
End Type





Type LTFlashingVisualizer Extends LTImageVisualizer
  Method Act()
    Local Time:Double = L_WrapDouble( Game.ProjectTime, 3.0 )
    If Time < 1.0 Then
      Red = Time
      Green = 0.0
      Blue = 1.0 - Time
    ElseIf Time < 2.0 Then
      Red = 2.0 - Time
      Green = Time - 1.0
      Blue = 0.0
    Else
      Red = 0.0
      Green = 3.0 - Time
      Blue = Time - 2.0
    End If
  End Method
End Type