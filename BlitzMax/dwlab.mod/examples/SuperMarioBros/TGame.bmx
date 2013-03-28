Type TGame Extends LTProject
	Const Gravity:Double = 32.0
	
    Field Score:Int
    Field Lives:Int = 3
    Field Coins:Int
    Field TimeLeft:Int
   
	Field World:LTWorld ' this field will store our world created in editor
	Field Level:LTLayer ' this field will store layer loaded from the world
	Field Tilemap:LTTileMap
	Field MovingObjects:LTSpriteMap
   
   Method Init()
       L_InitGraphics( 960, 720, 48.0 ) ' initialization of graphics engine with 960x720 resolution and 48 pixels per one unit (tile will be stretched to 48x48 pixels)
       World = LTWorld.FromFile( "world.lw" ) ' loading the world into memory
	   L_Music.Preload( "media\music1intro.ogg", "intro1" )
	   L_Music.Preload( "media\music1.ogg", "1" )
	   L_Music.Preload( "media\MarioDie.ogg", "dying" )
	   InitLevel()
   End Method
   
   Method InitLevel()
	   Level = LoadLayer( LTLayer( World.FindShapeWithType( "LTLayer" ) ) ) ' loading level from the world
	   MovingObjects = LTSpriteMap( Level.FindShapeWithType( "LTSpriteMap" ) )
       Level.Init() ' initializing level objects
	   L_Music.ClearMusic()
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