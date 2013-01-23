Type TGame Extends LTProject
   Field World:LTWorld ' this field will store our world created in editor
   Field Level:LTLayer ' this field will store layer loaded from the world
   
   Method Init()
       L_InitGraphics( 960, 720, 48.0 ) ' initialization of graphics engine with 960x720 resolution and 48 pixels per one unit (tile will be stretched to 48x48 pixels)
       World = LTWorld.FromFile( "world.lw" ) ' loading the world into memory
       LoadAndInitLayer( Level, LTLayer( World.FindShapeWithType( "LTLayer" ) ) ) ' loading layer (shape with class "LTLayer") from the world to work with it
	   L_Music.Preload( "media\music1intro.ogg", "intro1" )
	   L_Music.Preload( "media\music1.ogg", "1" )
	   L_Music.Add( "intro1" )
	   L_Music.Add( "1", True )
	   L_Music.Start()
   End Method
   
   Method Logic()
       Level.Act()
       If KeyHit( Key_Escape ) Then End ' exit after pressing Escape
	   L_Music.Manage()
   End Method
   
   Method Render()
       Level.Draw() ' drawing loaded layer
   End Method
End Type