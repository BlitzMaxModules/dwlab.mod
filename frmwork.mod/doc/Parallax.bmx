SuperStrict

Framework brl.basic
Import brl.pngloader
Import dwlab.frmwork

Global Game:TGame = New TGame
Game.Execute()

Type TGame Extends LTProject
  Field Ground:LTTileMap
  Field Grid:LTTileMap
  Field Clouds:LTTileMap
  
  Method Init()
    L_InitGraphics( 512, 512, 64 )
    
    Local Layer:LTLayer = LoadLayer( LTLayer( LTWorld.FromFile( "parallax.lw" ).FindShapeWithType( "LTLayer" ) ) )
  
    Ground = LTTileMap( Layer.FindShape( "Ground" ) )
    Grid = LTTileMap( Layer.FindShape( "Grid" ) )
    Clouds = LTTileMap( Layer.FindShape( "Clouds" ) )
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
	DrawText( "Move camera with arrow keys", 0, 0 )
  End Method
End Type