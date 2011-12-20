SuperStrict

Framework brl.basic
Import brl.pngloader
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Incbin "parallax.lw"
Incbin "water_and_snow.png"
Incbin "grid.png"
Incbin "clouds.png"

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
  Field Ground:LTTileMap
  Field Grid:LTTileMap
  Field Clouds:LTTileMap
  
  Method Init()
    L_InitGraphics( 512, 512, 64 )
    
	L_SetIncbin( True )
    Local Layer:LTLayer = LoadLayer( LTLayer( LTWorld.FromFile( "parallax.lw" ).FindShapeWithType( "LTLayer" ) ) )
	L_SetIncbin( False )
  
    Ground = LTTileMap( Layer.FindShape( "Ground" ) )
    Grid = LTTileMap( Layer.FindShape( "Grid" ) )
    Clouds = LTTileMap( Layer.FindShape( "Clouds" ) )
  End Method
  
  Method Logic()
    L_CurrentCamera.MoveUsingArrows( 8.0 )
    L_CurrentCamera.LimitWith( Grid )
    Ground.Parallax( Grid )
    Clouds.Parallax( Grid )
    If KeyHit( Key_Escape ) Then Exiting = True
  End Method
  
  Method Render()
    Ground.Draw()
    Grid.Draw()
    Clouds.Draw()
	DrawText( "Move camera with arrow keys", 0, 0 )
	L_PrintText( "Parallax example", 0, 12, LTAlign.ToCenter, LTAlign.ToBottom )
  End Method
End Type