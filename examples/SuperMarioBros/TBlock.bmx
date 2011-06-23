'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TCoin.bmx"
Include "TBricks.bmx"

Type TBlock Extends LTVectorSprite
  Const Gravity:Double = 8.0
  Const Impulse:Double = 1.5
  Const BonusImpulse:Double = 8.0

  Field LowestY:Double
  Field TileX:Int, TileY:Int, TileNum:Int
  
  
  
  Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
    Local Block:TBlock = New TBlock
    Block.SetAsTile( Game.TileMap, TileX, TileY )
    Game.TileMap.SetTile( TileX, TileY, 53 )
    Block.TileX = TileX
    Block.TileY = TileY
    Block.LowestY = Block.Y
    Block.DY = -Impulse
    Block.Frame = TTiles.SolidBlock
    Select TileNum
      Case TTiles.QuestionBlock
        TCoin.FromTile( TileX, TileY )
      Case TTiles.CoinsBlock
        TCoin.FromTile( TileX, TileY )
        Game.Level.AttachModel( TTileChange.Create( TileX, TileY ) )
        Block.Frame = TileNum 
      Case TTiles.MushroomBlock
        If Game.Mario.FindModel( "TBig" ) Then
          TFireFlower.FromTile( TileX, TileY )
        Else
          TMushroom.FromTile( TileX, TileY )
        End If
      Case TTiles.Mushroom1UPBlock
        TOneUpMushroom.FromTile( TileX, TileY )
      Case TTiles.StarmanBlock
        TStarMan.FromTile( TileX, TileY )
      Case TTiles.Bricks, TTiles.ShadyBricks
        Block.Frame = TileNum 
    End Select

    Game.Bump.Play()
    Game.Level.AddLast( Block )
  End Function
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
    If DY < 0.0 Then
      Local Bonus:TBonus = TBonus( Sprite )
      If Bonus Then
        Bonus.DY = -BonusImpulse
        Bonus.DX = Abs( Bonus.DX ) * Sgn( Bonus.X - X )
      ElseIf TEnemy( Sprite ) Then
        TEnemy( Sprite ).AttachModel( New TKicked )
      End If
    End If
  End Method
  
  
  
  Method Act()
    DY :+ Game.PerSecond( Gravity )
    MoveForward()
    If Y >= LowestY And DY > 0 Then
      Game.Tilemap.SetTile( TileX, TileY, Frame )
      Game.Level.Remove( Self )
    End If
    CollisionsWithCollisionMap( Game.MovingObjects, 0 )
  End Method
End Type





Type TTileChange Extends LTBehaviorModel
  Const Period:Double = 8.0  

  Field TileX:Int, TileY:Int
  Field StartingTime:Double
  
  
  
  Function Create:TTileChange( TileX:Int, TileY:Int )
    Local TileChange:TTileChange = New TTileChange
    TileChange.TileX = TileX
    TileChange.TileY = TileY
    Return TileChange
  End Function
  
  
  
  Method Activate( Shape:LTShape )
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    If Game.Time >= StartingTime + Period Then
      If Game.Tilemap.GetTile( TileX, TileY ) <> 53 Then
        Game.Tilemap.SetTile( TileX, TileY, TTiles.SolidBlock )
        Remove( Shape )
      End If
    End If
  End Method
End Type