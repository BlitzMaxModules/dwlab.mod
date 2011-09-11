'
' Parallax - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Framework brl.basic

Import brl.pngloader

Import dwlab.frmwork

Global Game:TGame = New TGame
Game.Execute()

Type TGame Extends LTProject
  Field Clouds:LTSprite
  Field Grid:LTTileMap
  Field Ground:LTTileMap
  
  
  
  Method Init()
    L_InitGraphics( 512, 512 )
    
    Local Layer:LTLayer = LoadLayer( LTLayer( LTWorld.FromFile( "world.lw" ).FindShapeWithType( "LTLayer" ) ) )
  
    Local CloudsMap:LTDoubleMap = New LTDoubleMap
    CloudsMap.SetResolution( 512, 512 )
    CloudsMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
    Clouds = LTSprite( Layer.FindShape( "Clouds" ) )
    Clouds.SetSize( 96.0, 96.0 )
    Clouds.Visualizer.Image = CloudsMap.ToNewImage()
    
    Grid = LTTileMap( Layer.FindShape( "Grid" ) )
    Grid.SetSize( 64.0, 64.0 )
    
    Ground = LTTileMap( Layer.FindShape( "Ground" ) )
    Ground.SetSize( 48.0, 48.0 )
  End Method
  
  
  
  Method Logic()
    L_CurrentCamera.MoveUsingArrows( 8.0 )
    L_CurrentCamera.LimitWith( Grid )
    Ground.Parallax( Grid )
    Clouds.Parallax( Grid )
    If KeyHit( Key_Escape ) Then End
  End Method
  
  
  
  Method Render()
    Ground.Draw()
    Grid.Draw()
    Clouds.Draw()
  End Method
End Type