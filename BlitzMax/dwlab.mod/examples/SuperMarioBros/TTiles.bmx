Type TTiles Extends LTTileMap
   Const FadingSpeed:Double = 0.15
   Const FadingPeriod:Int = 5
   
   Const EmptyBlock:Int = 0
   Const QuestionBlock:Int = 9
   Const Bricks:Int = 10
   Const MushroomBlock:Int = 11
   Const Mushroom1UPBlock:Int = 13
   Const CoinsBlock:Int = 17
   Const StarmanBlock:Int = 18
   Const DarkEmptyBlock:Int = 35
   Const ShadyBricks:Int = 37
   Const Coin:Int = 40
   Const SolidBlock:Int = 48

   Method Init()
       Local AnimatedVisualizer:LTAnimatedTilemapVisualizer = New LTAnimatedTilemapVisualizer
       AnimatedVisualizer.TileNum = New Int[ TilesQuantity ]
     For Local N:Int = 0 Until TilesQuantity
           AnimatedVisualizer.TileNum[ N ] = N
       Next
       AnimatedVisualizer.TileNum[ MushroomBlock ] = QuestionBlock
       AnimatedVisualizer.TileNum[ Mushroom1UPBlock ] = EmptyBlock
       AnimatedVisualizer.TileNum[ CoinsBlock ] = Bricks
       AnimatedVisualizer.TileNum[ StarmanBlock ] = Bricks
     Visualizer = AnimatedVisualizer
	 Game.TileMap = Self
   End Method
   
   Method Act()
       Local AnimatedVisualizer:LTAnimatedTilemapVisualizer = LTAnimatedTilemapVisualizer( Visualizer )
       Local Fading:Int = Max( ( Floor( Game.Time / FadingSpeed ) Mod ( FadingPeriod + 4 ) ) - FadingPeriod, 0 )
       If Fading = 3 Then Fading = 1
        AnimatedVisualizer.TileNum[ QuestionBlock ] = 9 + ( Fading > 0 ) * ( 39 + Fading )
       AnimatedVisualizer.TileNum[ MushroomBlock ] = AnimatedVisualizer.TileNum[ QuestionBlock ]
       AnimatedVisualizer.TileNum[ Coin ] = 40 + ( Fading > 0 ) * ( 10 + Fading )
   End Method
End Type