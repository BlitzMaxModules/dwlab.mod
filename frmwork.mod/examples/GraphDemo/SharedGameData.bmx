'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

AppTitle = "Heilage: Ogres rivage v0.2.1"

Global Shared:TSharedGameData = New TSharedGameData

Type TSharedGameData Extends LTProject
  Field Graph:LTGraph = New LTGraph
  Field Player:LTSprite = New LTSprite
  Field PlayerVisualizer:LTImageVisualizer = New LTImageVisualizer
  Field PlayerPivot:LTSprite
  Field Background:LTSprite = New LTSprite
  Field BackgroundVisualizer:LTImageVisualizer = New LTImageVisualizer
  Field Path:LTPath = New LTPath
  Field Events:TMap = New TMap
  Field Font:LTFont
  
  
  
  Method Init()
    Player.SetVelocity( 2.0 )
    Player.SetSize( 72 / 25, 72 / 25 )
    Player.Shape = L_Rectangle
    
    PlayerVisualizer.Image = LTImage.FromFile( "media/footman.png", 5, 13 )
    PlayerVisualizer.Image.SetHandle( 0.5, 0.7 )
    'PlayerImages.NoScale = 1
    PlayerVisualizer.Rotating = False
    Player.Visualizer = PlayerVisualizer
    
    Background.Width = 32
    Background.Height = 24
    BackgroundVisualizer.Image = LTImage.FromFile( "media/world-map.jpg" )
    Background.Visualizer = BackgroundVisualizer
    
    Font = LTFont.FromFile( "media/font.png" )
  End Method
  
  
  
  Method Logic()
    If KeyHit( Key_Space ) And Editor.CurrentPivot Then
      If PlayerPivot Then
        Path = LTPath.Find( PlayerPivot, Editor.CurrentPivot, Graph )
      Else
        Player.JumpToSprite( Editor.CurrentPivot )
        PlayerPivot = Editor.CurrentPivot
      End If
    End If
    'Player.Turn( 45 )
    Local AngleFrame:Int = Floor( 0.5 + ( Player.GetAngle() - Floor( Player.GetAngle() / 360 ) * 360 ) / 45 )
    Player.Frame = Int( Mid$( "234321012", AngleFrame + 1, 1 ) )
    
    If AngleFrame >=3 And AngleFrame <= 5 Then
      Player.Width = -Abs( Player.Width )
    Else
      Player.Width = Abs( Player.Width )
    End If
    
    If PlayerPivot Then
      If Player.IsAtPositionOfSprite( PlayerPivot ) And Not Path.Pivots.IsEmpty() Then
        PlayerPivot = LTSprite( Path.Pivots.First() )
        Player.DirectToSprite( PlayerPivot )
        Path.Pivots.RemoveFirst()
      Else
        Player.MoveTowardsSprite( PlayerPivot )
      End If
      If Not Player.IsAtPositionOfSprite( PlayerPivot ) Then Player.Frame :+ ( Floor( Editor.ProjectTime * 5 ) Mod 5 ) * 5
    End If
  End Method
  
  
  
  Method Render()
    Background.Draw()
    Player.Draw()   
  End Method
End Type





Type TGlobalMapEvent Extends LTSprite
  Field Probability:Float
  Field Caption:String
  
  
  
  Method DrawInfo( Pivot:LTSprite )
    Shared.Font.Print( Caption + " ( " + L_TrimFloat( Probability * 100.0 ) + "% )", Pivot.X + 5, Pivot.Y, L_AlignToRight, L_AlignToCenter )
  End Method
  
  
  
  Method Execute()
  End Method
  
  
  
  Method XMLIO( XMLObject:LTXMLObject )
    Super.XMLIO( XMLObject )
    XMLObject.ManageFloatAttribute( "probability", Probability )
    XMLObject.ManageStringAttribute( "caption", Caption )
  End Method
End Type