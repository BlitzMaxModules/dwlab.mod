'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TFireball.bmx"

Type TMario Extends LTVectorSprite
  Const FramesInRow:Int = 9
  Const HopStrength:Double = -4.0

  Const Standing:Int = 0
  Const Jumping:Int = 4
  Const Sliding:Int = 5
  Const Firing:Int = 6
  Const Dying:Int = 6
  Const Sitting:Int = 7
  Const SlidingDown:Int = 8
  
  Field OnLand:Int
  Field Combo:Int = TScore.s100
  Field FrameShift:Int
  


  Method Init()
    AttachModel( New TCollisions )
    AttachModel( New TGravity )
    AttachModel( New TMoving )
    AttachModel( New TJumping )
  End Method
  
  
  
  Method Draw()
    Super.Draw()

  End Method
  
  
  
  Method HandleCollisionWithSprite( Sprite:LTSprite, CollisionType:Int )
    If TBonus( Sprite ) Then
      Game.MovingObjects.RemoveSprite( Sprite )
      TBonus( Sprite ).Collect()
    Else If TEnemy( Sprite ) Then
      If FindModel( "TInvulnerable" ) Then
        Sprite.AttachModel( New TKicked )
      ElseIf BottomY() < Sprite.Y Then
        If DY > 0.0 Then
          TEnemy( Sprite ).Stomp()
          TScore.FromSprite( Sprite, Combo )
          If Combo < TScore.s400 Then Combo :+ 1
          DY = HopStrength
        End If
      Else
        Damage()
      End If
    End If
  End Method
  
  
  
  Method Damage()
    If Not FindModel( "TInvisible" ) Then
      If FindModel( "TBig" ) Then
        If Not FindModel( "TShrinking" ) Then AttachModel( New TShrinking )
      Else
        AttachModel( TDying.Create( False ) )
      End If
    End If    
  End Method
  
  
  
  Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
    Local TileNum:Int = TileMap.GetTile( TileX, TileY )
    If TileNum = TTIles.Coin Then
      TileMap.SetTile( TileX, TileY, TTiles.DarkEmptyBlock )
      Game.Coins :+ 1
      Game.CoinFlip.Play()
    Else
      PushFromTile( TileMap, TileX, TileY )
      If CollisionType = Vertical Then
        If DY >= 0 Then
          OnLand = True
          Combo = TScore.s100
        Else
          Select TileNum
            Case TTiles.QuestionBlock, TTiles.MushroomBlock, TTiles.Mushroom1UPBlock, TTiles.CoinsBlock, TTiles.StarmanBlock
              TBlock.FromTile( TileX, TileY, TileNum )
            Case TTiles.Bricks, TTiles.ShadyBricks
              Local Model:LTBehaviorModel = FindModel( "TBig" )
              If Model Then
                Model.HandleCollisionWithTile( Self, TileMap, TileX, TileY, CollisionType )
              Else
                TBlock.FromTile( TileX, TileY, TileNum )
              End If
          End Select
        End If
        DY = 0
      Else
        DX = 0
      End If
    End If    
  End Method
  
  

  Method Act()
    OnLand = False
    Super.Act()
    
    Frame = ( Frame Mod FramesInRow ) + FrameShift * FramesInRow

    LimitHorizontallyWith( Game.Level.Bounds )
    
    L_CurrentCamera.JumpTo( Self )
    L_CurrentCamera.LimitWith( Game.Level.Bounds )
    
    If TopY() > Game.Tilemap.BottomY() And Not FindModel( "TDying" ) Then AttachModel( TDying.Create( True ) )
  End Method
End Type





Type TMoving Extends LTBehaviorModel
  Const Acceleration:Double = 20.0
  Const AnimationSpeed:Double = 1.5
  Const MaxWalkingSpeed:Double = 7.0
  Const MaxRunningSpeed:Double = 20.0
  Const Friction:Double = 40.0
  
  Field Frame:Double
  
  
  
  Method ApplyTo( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    Local Direction:Double = Sgn( Mario.DX )
    Local Force:Double = 0.0
    If KeyDown( Key_Left ) Then Force = -1.0
    If KeyDown( Key_Right ) Then Force = 1.0
    If Force = 0.0 Then
      If Mario.OnLand Then Mario.Frame = TMario.Standing
      Frame = 0.0
    Else
      Mario.SetFacing( Force )
    End If
    
    If Force <> Direction And Direction <> 0.0 Then
      Frame = 0.0
      If Force <> 0.0 And Mario.OnLand Then Mario.Frame = TMario.Sliding
      If Abs( Mario.DX ) < Game.PerSecond( Friction ) Then
        Mario.DX = 0
      Else
        Mario.DX :- Sgn( Mario.DX ) * Game.PerSecond( Friction )
      End If
    ElseIf Force <> 0.0 Then
      Local MaxSpeed:Double = MaxWalkingSpeed
      If KeyDown( Key_S ) Then MaxSpeed = MaxRunningSpeed
      if Abs( Mario.DX ) < MaxSpeed Then Mario.DX :+ Sgn( Force ) * Game.PerSecond( Acceleration )
      If Mario.OnLand Then
        Frame :+ Game.PerSecond( Mario.DX ) * AnimationSpeed
        Mario.Frame = Floor( Frame - Floor( Frame / 3.0 ) * 3.0 ) + 1
      End If
    End If
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    TMario( Shape ).DX = 0.0
  End Method
End Type





Type TJumping Extends LTBehaviorModel
  Const Strength:Double = -17.0
  
  
  
  Method ApplyTo( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    If KeyDown( Key_A ) And Mario.OnLand Then
      Mario.DY = Strength
      Mario.Frame = TMario.Jumping
      Game.Jump.Play()
    End If
  End Method
End Type





Type TDying Extends LTBehaviorModel
  Const Period:Double = 3.5
  
  Field Chasm:Int
  Field StartingTime:Double

  

  Function Create:TDying( Chasm:Int )
    Local Dying:TDying = New TDying
    Dying.Chasm = Chasm
    Return Dying
  End Function

  
  
  Method Activate( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    TCollisions( Mario.FindModel( "TCollisions" ) ).SetCollisions( False, False )
    Mario.DeactivateModel( "TMoving" )
    Mario.DeactivateModel( "TJumping" )
    Mario.DX = 0.0
    If Not Chasm Then
      Mario.DY = TJumping.Strength
      Mario.Frame = TMario.Dying
    End If
    
    Game.MusicChannel.Stop()
    Game.MusicChannel = Game.MarioDie.Play()
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    If Game.Time > StartingTime + Period Then
      Game.Lives :- 1
      If Game.Lives = 0 Then
        Game.MusicChannel = Game.GameOver.Play()
        While Game.MusicChannel.Playing()
        Wend
        Game.Lives = 3
      End If
      Game.InitLevel()
    End If
  End Method
End Type





Type TGrowing Extends LTBehaviorModel
  Const Speed:Double = 0.08
  Const Phases:Int = 10
  
  Field StartingTime:Double

  

  Method Init( Shape:LTShape )
    Shape.DeactivateAllModels()
    Game.Level.Active = False
    Local Sprite:LTSprite = LTSprite( Shape )
    Sprite.AlterCoords( 0.0, -0.5 )
    Sprite.SetHeight( 2.0 )
    Sprite.Visualizer.SetImage( Game.Growth )
    Sprite.Frame = 0
    PlaySound( Game.Powerup )
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    LTSprite( Shape ).Animate( Game, Speed, , , StartingTime, True )
    If Game.Time > StartingTime + Phases * Speed Then Remove( Shape )
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Shape.ActivateAllModels()
    Game.Level.Active = True
    Shape.Visualizer.SetImage( Game.SuperMario )
    Shape.AttachModel( New TBig )
  End Method
End Type





Type TBig Extends LTBehaviorModel
  Method HandleCollisionWithTile( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
    Local TileNum:Int = TileMap.GetTile( TileX, TileY )
    If TileNum = TTiles.Bricks Or TileNum = TTiles.ShadyBricks Then TBricks.FromTile( TileX, TileY, TileNum )
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    If KeyDown( Key_Down ) Then If Not Shape.FindModel( "TSitting" ) Then Shape.AttachModel( New TSitting )
  End Method
End Type





Type TShrinking Extends TGrowing
  Method Init( Shape:LTShape )
    Shape.RemoveModel( "TFireable" )
    Shape.DeactivateAllModels()
    Game.Level.Active = False
    Local Sprite:LTSprite = LTSprite( Shape )
    Sprite.Visualizer.SetImage( Game.Growth )
    Sprite.Frame = 0
    PlaySound( Game.Pipe )
    StartingTime = Game.Time
    Shape.AttachModel( New TInvisible )
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    LTSprite( Shape ).Animate( Game, Speed, , , StartingTime - 2.0 * Speed, True )
    If Game.Time > StartingTime + Phases * Speed Then Remove( Shape )
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Shape.RemoveModel( "TSitting" )
    Shape.ActivateAllModels()
    Game.Level.Active = True
    Shape.SetHeight( 1.0 )
    Shape.AlterCoords( 0.0, 0.5 )
    Shape.Visualizer.SetImage( Game.SmallMario )
    Shape.RemoveModel( "TBig" )
  End Method
End Type





Type TInvisible Extends LTBehaviorModel
  Const Period:Double = 2.0
  Const BlinkingSpeed:Double = 0.05

  Field StartingTime:Double
  
  
  
  Method Activate( Shape:LTShape )
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    Shape.Visible = Floor( Game.Time / BlinkingSpeed ) Mod 2
    If Game.Time > StartingTime + Period Then Remove( Shape )
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Shape.Visible = True
  End Method
End Type





Type TSitting Extends LTBehaviorModel
  Method Activate( Shape:LTShape )
    Shape.SetHeight( 1.4 )
    Shape.AlterCoords( 0, 0.3 )
    Shape.Visualizer.DY = -0.3 / 2.0
    Shape.Visualizer.YScale = 2.0 / 1.4
    Shape.DeactivateModel( "TMoving" )
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    LTSprite( Shape ).Frame = TMario.Sitting
    If Not KeyDown( Key_Down ) Then Remove( Shape )
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Shape.AlterCoords( 0, -0.3 )
    Shape.SetHeight( 2.0 )
    Shape.Visualizer.DY = 0.0
    Shape.Visualizer.YScale = 1.0
    Shape.ActivateModel( "TMoving" )
  End Method
End Type





Type TFlashing Extends LTBehaviorModel
  Const AnimationSpeed:Double = 0.05
  Const Period:Double = 0.8
  
  Field StartingTime:Double

  
  
  Method Init( Shape:LTShape )
    Shape.DeactivateAllModels()
    Game.Level.Active = False
    PlaySound( Game.Powerup )
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    Mario.FrameShift = 2 + ( Floor( Game.Time / AnimationSpeed ) Mod 3 )
    If Game.Time > StartingTime + Period Then Remove( Shape )
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Shape.ActivateAllModels()
    Game.Level.Active = True
    If Not Shape.FindModel( "TFireable" ) Then Shape.AttachModel( New TFireable )
  End Method
End Type





Type TInvulnerable Extends LTBehaviorModel
  Const AnimationSpeed:Double = 0.05
  Const Period:Double = 13.0
  Const FadingAnimationSpeed:Double = 0.1
  Const FadingPeriod:Double = 2.0
  
  Field StartingTime:Double
  Field Fading:Int

  
  
  Method Activate( Shape:LTShape )
    Game.MusicChannel.Stop()
    Game.MusicChannel = Game.Invulnerability.Play()
    StartingTime = Game.Time
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    If Game.Time < StartingTime + Period Then
      Mario.FrameShift = 1 + ( Floor( Game.Time / AnimationSpeed ) Mod 3 )
    ElseIf Game.Time < StartingTime + Period + FadingPeriod Then
      If Not Fading Then
        Game.StartMusic()
        Fading = True
      End If
      Mario.FrameShift = 1 + ( Floor( Game.Time / FadingAnimationSpeed ) Mod 3 )
    Else
      Remove( Shape )
    End If
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    TMario( Shape ).FrameShift = 0
  End Method
End Type





Type TFireable Extends LTBehaviorModel
  Field StartingTime:Double 
  Field OldFrame:Int = -1
  Field Period:Double = 0.25
  Field AnimationPeriod:Double = 0.1
  
  
  
  Method ApplyTo( Shape:LTShape )
    Local Mario:TMario = TMario( Shape )
    Mario.FrameShift = 4
    If Game.Time >= StartingTime + Period Then
      If KeyDown( Key_S ) Then
        StartingTime = Game.Time
        OldFrame = Mario.Frame
        Mario.Frame = TMario.Firing
        TFireball.Fire()
      End If
    ElseIf Game.Time >= StartingTime + AnimationPeriod Then
      If OldFrame >= 0 Then
        Mario.Frame = OldFrame
        OldFrame = -1
      End If
    Else
      Mario.Frame = TMario.Firing
    End If
  End Method
  
  
  
  Method Deactivate( Shape:LTShape )
    Game.Mario.FrameShift = 0
  End Method
End Type





Type TFinalSequence Extends LTBehaviorModel
  Const MarioSpeed:Double = 4.0
  Const FlagSpeed:Double = 8.0
  Const WalkingSpeed:Double = 5.0
  Const WalkingAnimationSpeed:Double = 0.15
  Const CastleFlagSpeed:Double = 0.8
  Const TotalFireworks:Int = 5
  Const ExplodingSpeed:Double = 0.2
  Const TimeToScoreSpeed:Double = 0.02
  
  Const Sliding:Int = 0
  Const Walking:Int = 1
  Const Exiting:Int = 2
  Const RaisingFlag:Int = 3
  Const Fireworks:Int = 4
  
  Field Phase:Int = Sliding
  Field AnimationStartingTime:Double
  Field Pole:LTShape = Game.Level.FindShapeWithType( "TPole" )
  Field Flag:LTShape = Game.Level.FindShape( "Flag" )
  Field FinalExit:LTShape = Game.Level.FindShape( "FinalExit" )
  Field CastleFlagSpace:LTShape = Game.Level.FindShape( "CastleFlagSpace" )
  Field CastleFlag:LTSprite
  Field Firework:LTSprite
  Field FireworksLeft:Int = TotalFireworks
  Field FireworkExplodingTime:Double
  Field LastTimeToScoreSwap:Double
  
  
  
  Method Activate( Shape:LTShape )
    Shape.DeactivateModel( "TCollisions" )
    Shape.DeactivateModel( "TGravity" )
    Shape.DeactivateModel( "TMoving" )
    Shape.DeactivateModel( "TJumping" )
    Shape.DeactivateModel( "TSitting" )
    Game.Level.Active = False
    Game.Mario.X = Pole.X - 0.3 * Game.Mario.GetFacing()
    Game.Mario.Frame = TMario.SlidingDown
    Game.MusicChannel.SetVolume( 0.0 )
    Game.FlagPole.Play()
    TScore.FromSprite( Game.Mario, L_LimitInt( ( Pole.BottomY() - Game.Mario.BottomY() ) / Pole.Height * 11, TScore.s100, TScore.s8000 ) )
  End Method
  
  
  
  Method ApplyTo( Shape:LTShape )
    Select Phase
      Case Sliding
        If Game.Mario.BottomY() < Pole.BottomY() Then Game.Mario.Move( 0.0, MarioSpeed )
        If Flag.BottomY() < Pole.BottomY() Then
          Flag.Move( 0.0, FlagSpeed )
        ElseIf Game.Mario.BottomY() >= Pole.BottomY() Then
          NextPhase( Shape )
        End If
      Case Walking
        Game.Mario.DX = WalkingSpeed
        If Game.Mario.OnLand Then
          Game.Mario.Animate( Game, WalkingAnimationSpeed, 3, 1, AnimationStartingTime )
        Else
          AnimationStartingTime = Game.Time
        End If
        If Game.Mario.X >= FinalExit.X Then NextPhase( Shape )
      Case Exiting
        Game.Mario.DX = WalkingSpeed
        If Game.Mario.LeftX() >= FinalExit.RightX() Then NextPhase( Shape )
      Case RaisingFlag
        CastleFlag.Move( 0, -CastleFlagSpeed )
        If CastleFlagSpace.Y >= CastleFlag.Y Then NextPhase( Shape )
      Case Fireworks
        If Game.Time >= FireworkExplodingTime + ExplodingSpeed * 3 Then
          If FireworksLeft = 0 Then
            Game.Level.Remove( Firework )
            NextPhase( Shape )
          Else
            Firework.SetCoords( CastleFlag.X + Rnd( -5.0, 5.0 ), CastleFlag.Y - Rnd( 5.0 ) )
            Game.Fireworks.Play()
            FireworkExplodingTime = Game.Time
            FireworksLeft :- 1
          End If
        Else
          Firework.Animate( Game, ExplodingSpeed, , , FireworkExplodingTime )
        End If
    End Select
    If Phase >= Walking And Game.TimeLeft > 0 And Game.Time > LastTimeToScoreSwap + TimeToScoreSpeed Then
      Game.TimeLeft :- 1
      Game.Score :+ 50
      LastTimeToScoreSwap = Game.Time
    End If
  End Method
  
  
  
  Method NextPhase( Shape:LTShape )
    Phase :+ 1
    Select Phase
      Case Walking
        Shape.ActivateModel( "TCollisions" )
        Shape.ActivateModel( "TGravity" )
        Game.Mario.SetFacing( LTSprite.RightFacing )
        Game.Mario.Frame = TMario.Jumping
        Game.StageClear.Play()
      Case Exiting
        Game.Mario.LimitByWindowShape( FinalExit )
      Case RaisingFlag
        Game.Mario.Visible = False
        Game.Mario.DX = 0.0
        CastleFlag = New LTSprite
        Game.Level.AddLast( CastleFlag )
        CastleFlag.SetCoords( CastleFlagSpace.X, CastleFlagSpace.Y + 1.0 )
        CastleFlag.SetSize( 1.0, 1.0 )
        CastleFlag.Visualizer = Game.FlagOnCastle
        CastleFlag.LimitByWindowShape( CastleFlagSpace )
        Game.Level.AddLast( CastleFlag )
      Case Fireworks
        Firework = New LTSprite
        Firework.SetSize( 1.0, 1.0 )
        Firework.Visualizer = Game.Explosion
        Game.Level.AddLast( Firework )
    End Select
  End Method
End Type