'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGameSprite Extends LTSprite
  Field FadingStartTime:Float
  
  
  
  Method Destroy()
    FadingStartTime = Game.ProjectTime
    'debugstop
    Game.Objects.Remove( Self )
    Game.CollisionMap.RemoveSprite( Self )
    Game.DestructingObjects.AddLast( Self )
  End Method
  
  
  
  Method Fading()
    Local FadingTime:Float = 1.0 + FadingStartTime - Game.ProjectTime
    If FadingTime >= 0.0 Then
      Visualizer.Alpha = FadingTime
    Else
      Game.DestructingObjects.Remove( Self )
    End If
  End Method
End Type





Type TBall Extends TGameSprite
  Field LastShotTime:Float
  Field ShotRate:Float = 0.5
  
  
  
  Const Acceleration:Float = 20.0
  Const AccelerationLimit:Float = 4.0
  Const Gravity:Float = 10.0
  Const JumpingPower:Float = -9.2
  Const HorizontalBounce:Float = 0.6
  Const VerticalBounce:Float = 0.3
  Const BulletSpeed:Float = 8.0
  
  
  
  Method New()
    Shape = L_Circle
  End Method
  
  
  
  Method Bounce( DX:Float, DY:Float )
    If DY > Abs( DX ) Then
      SetDY( -GetDY() * VerticalBounce )
      If KeyDown( Key_Up ) Then SetDY( JumpingPower )
    ElseIf DY < -Abs( DX ) Then
      SetDY( -GetDY() * VerticalBounce )
    Else
      SetDX( -GetDX() * HorizontalBounce )
    End If
  End Method
  
  
  
  Method Act()
    If KeyDown( Key_Left ) Then
      AlterDX( -L_DeltaTime * Acceleration )
      Visualizer.XScale = -1.0
    ElseIf KeyDown( Key_Right ) Then
      AlterDX( L_DeltaTime * Acceleration )
      Visualizer.XScale = 1.0
    Else
      If Abs( GetDX() ) < 0.5 Then SetDX( 0 )
    End If
    
    If KeyDown( Key_Space ) And LastShotTime + ShotRate < Game.ProjectTime Then
      Local Direction:Float = Visualizer.XScale
      
      LastShotTime = Game.ProjectTime
      Local Bullet:TBullet = New TBullet
      Bullet.SetDiameter( 0.5 )
      Bullet.SetCoords( X + 0.5 * Direction, Y )
      Bullet.SetDX( BulletSpeed * Direction )
      Bullet.Shape = L_Circle
      
      Local BulletVisualizer:LTImageVisualizer = New LTImageVisualizer
      BulletVisualizer.SetVisualizerScale( 3.0 * Direction, 3.0 )
      BulletVisualizer.Image = Game.BulletImage
      BulletVisualizer.Rotating = False
      Bullet.Visualizer = BulletVisualizer
      
      Game.Bullets.AddLast( Bullet )
    End If
    
    SetDX( L_LimitFloat( GetDX(), -5.0, 5.0 ) )
    AlterDY( L_DeltaTime * Gravity )
    
    'debugstop
    MoveForward()
    'Game.CollisionMap.CollisionsWithSprite( Self )
    CollisionsWith( Game.TileMap )
  End Method
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite )
    'debugstop
    WedgeOffWith( Sprite, 0.0, 1.0 )
    
    Bounce( Sprite.X - X, Sprite.Y - Y )
  End Method
  
  
  
  Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
    Local Template:LTSprite = TileMap.GetTileTemplate( TileX, TileY )
    Local Block:TCollectableBlock = TCollectableBlock( Template )
    If Block Then
      Select Block.BlockType
        Case TCollectableBlock.Key
          Game.Score :+ 250
          Game.KeyCollected = True
        Case TCollectableBlock.Bomb
          Game.Score :+ 100
        Case TCollectableBlock.Badge
          Game.Score :+ 50
        Case TCollectableBlock.Diamond
          Game.Score :+ 100
        Case TCollectableBlock.Score
          Game.Score :+ 500
      End Select
      TileMap.FrameMap.Value[ TileX, TileY ] = 0
    Else
      If TExitBlock( Template ) And Game.KeyCollected Then End
      'debugstop
      PushFromTile( TileMap, TileX, TileY )

      Local Sprite:LTSprite = TileMap.GetTile( TileX, TileY )
      Bounce( Sprite.X - X, Sprite.Y - Y )
    End If
  End Method
End Type





Type TBullet Extends LTSprite
  Method Act()
    MoveForward()
    Game.CollisionMap.CollisionsWithSprite( Self )
    Game.TileMap.CollisionsWithSprite( Self )
  End Method
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite )
    If TBlock( Sprite ) Then
      Destroy()
    ElseIf TEnemy( Sprite ) Then
      Destroy()
      If Not TEnemy( Sprite ).BulletProof Then
        Sprite.Destroy()
        Game.Score :+ 10
      End If
    End If
  End Method
  
  
  
  Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
    Destroy()
  End Method
  
  
  
  Method Destroy()
    Game.Bullets.Remove( Self )
  End Method
End Type