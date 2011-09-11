'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
  Const BallsPerTurn:Int = 3

  Field World:LTWorld
  Field Level:LTTileMap
  Field HUD:LTLayer
  Field Objects:LTLayer = New LTLayer
  Field Particles:LTLayer = New LTLayer
  
  Field Cursor:TCursor = New TCursor
  Field Selected:TSelected
  Field EmptyCells:TList = New TList
  Field TileMapPathFinder:LTTileMapPathFinder
  Field Busy:Int
  Field Score:Int
  Field HiScore:Int = 100
  Field Panel:LTSprite = New LTSprite
  Field GameOver:Int
  
  Field Font:LTBitmapFont

  Field SwapSound:TSound = TSound.Load( "incbin::swap.ogg", False )
  Field RushSound:TSound = TSound.Load( "incbin::rush.ogg", False )
  Field StopSound:TSound = TSound.Load( "incbin::stop.ogg", False )
  Field SelectSound:TSound = TSound.Load( "incbin::select.ogg", False )
  Field ExplosionSound:TSound = TSound.Load( "incbin::explosion.ogg", False )
  
  Method Init()
    World = LTWorld.FromFile( "levels.lw" )
    
    L_InitGraphics( 960, 704, 64.0 )
    
    Font = LTBitmapFont.FromFile( "font.png", 32, 127, 16, True )
    
    LoadLevel()
    
    Panel.SetSize( 7.0, 3.0 )
    Panel.Visualizer = LTRasterFrameVisualizer.FromPixmap( Level.TileSet.Image.BMaxImage.pixmaps[ 0 ] )
    
    LoadAndInitLayer( HUD, LTLayer( World.FindShape( "HUD" ) ) )
    
    Panel.JumpTo( L_CurrentCamera )
    
    ( New TIntro ).Execute()
    
    Cursor.ShapeType = LTSprite.Pivot
    Cursor.SetDiameter( 0.1 )   
    
    If FileType( "hiscore.txt" ) Then
      Local File:TStream = ReadFile( "hiscore.txt" )
      HiScore = ReadLine( File ).ToInt()
      CloseFile( File )
    End If
    
    CreateBalls()
  End Method
  
  Method LoadLevel()
    Local Layer:LTLayer = Null
    LoadAndInitLayer( Layer, LTLayer( World.FindShape( "1" ) ) )
    
    TileMapPathFinder = LTTileMapPathFinder.Create( Level, False )
  End Method
  
  Method Render()
    Level.Draw()
    Objects.Draw()
    Particles.Draw()
    HUD.Draw()
    If GameOver Then
      Panel.Draw()
      Font.Print( "GAME OVER", Panel.X, Panel.Y, 1.0, LTAlign.ToCenter, LTAlign.ToCenter )
    End If
  End Method
  
  Method Logic()
    Cursor.SetMouseCoords()
    If Not Busy Then Cursor.CollisionsWithTileMap( Level )
    
    If Score > HiScore Then HiScore = Score
    
    If KeyHit( Key_Escape ) Or AppTerminate() Then 
      Local File:TStream = WriteFile( "hiscore.txt" )
      WriteLine( File, HiScore )
      CloseFile( File )
      Exiting = True
    End If
    
    If GameOver Then
      If GetChar() Or MouseHit( 1 ) Then
        LoadLevel()
        CreateBalls()
        GameOver = False
        Busy = False
      End If
    End If
    
    Objects.Act()
    Particles.Act()
  End Method
  
  Method CreateBalls()
    RefreshEmptyCells()
    If EmptyCells.Count() < 3 Then
      GameOver = True
      Busy = True
      Return
    End If
    For Local N:Int = 0 Until BallsPerTurn
      Local Cell:TCell = TCell.PopFrom( EmptyCells )
      TPopUpBall.Create( Cell.X, Cell.Y, Rand( 1, 7 ) )
    Next
  End Method
  
  Method RefreshEmptyCells()
    EmptyCells.Clear()
    For Local Y:Int = 0 Until Level.YQuantity
      For Local X:Int = 0 Until Level.XQuantity
        If Level.Value[ X, Y ] = TVisualizer.Empty Then
          EmptyCells.AddLast( TCell.Create( X, Y ) )
        End If
      Next
    Next
  End Method
  
  Method TileToSprite:LTSprite( Model:LTBehaviorModel, X:Int, Y:Int )
    Local Sprite:LTSprite = New LTSprite
    Sprite.SetAsTile( Game.Level, X, Y )
    Game.Objects.AddLast( Sprite )
    Sprite.AttachModel( Model )
    Game.Level.SetTile( X, Y, TVisualizer.Empty )
    Return Sprite
  End Method
End Type

Type TCell
  Field X:Int, Y:Int
  
  Function Create:TCell( X:Int, Y:Int )
    Local Cell:TCell = New TCell
    Cell.X = X
    Cell.Y = Y
    Return Cell
  End Function
  
  Function PopFrom:TCell( List:TList )
    Local Num:Int = Rand( 0, List.Count() - 1 )
    Local Link:TLink = List.FirstLink()
    For Local N:Int = 1 To Num
      Link = Link.NextLink()
    Next
    Local Cell:TCell = TCell( Link.Value() )
    Link.Remove()
    Return Cell
  End Function
End Type