'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBlock Extends LTSprite
End Type





Type TMovingBlock Extends TBlock
  Field BlockType:Int
  
  
  
  Const MovingBlock:Int = 0
  Const FallingBlock:Int = 1
  
  
  
  Function Create:TMovingBlock( X:Double, Y:Double, FrameNum:Int, DY:Double )
    Local Block:TMovingBlock = New TMovingBlock
    Block.SetCoords( X, Y )
    Block.SetDY( DY )
    Block.Frame = FrameNum
    Block.Visualizer = Game.FlashingVisualizer
    Game.SpriteMap.InsertSprite( Block )
    Game.Objects.AddLast( Block )
  End Function
  
  
  
  Method Act()
    MoveForward()
    Game.SpriteMap.CollisionsWithSprite( Self )
    Game.TileMap.CollisionsWithSprite( Self )
  End Method
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite )
    If TGameSprite( Sprite ) Then
      'debugstop
      Sprite.Destroy()
    Else
      PushFrom( Sprite )
      If BlockType = MovingBlock Then SetDY( -GetDY() )
    End If
  End Method
  
  
  
  Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
    PushFromTile( TileMap, TileX, TileY )
    If BlockType = MovingBlock Then SetDY( -GetDY() )
  End Method
End Type





Type TExitBlock Extends TBlock
End Type





Type THazardousBlock Extends TBlock
  Method New()
    Visualizer = Game.FlashingVisualizer
  End Method
  
  
  
  Method HandleCollision( Shape:LTShape )
    If TGameSprite( Shape ) Then Shape.Destroy()
  End Method
End Type





Type TCollectableBlock Extends TBlock
  Field BlockType:Int
  
  
  
  Const Key:Int = 0 ' 250pts
  Const Bomb:Int = 1 ' 100pts
  Const Badge:Int = 2 ' 50pts
  Const Diamond:Int = 3 ' 100pts
  Const Score:Int = 4 ' 500pts
  Const Nothing:Int = 5
End Type