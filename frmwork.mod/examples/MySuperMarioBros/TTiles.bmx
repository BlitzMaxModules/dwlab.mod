'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TTiles Extends LTTileMap
	Const FadingSpeed:Float = 0.15
	Const FadingPeriod:Int = 5
	
	Const EmptyBlock:Int = 0
	Const QuestionBlock:Int = 9
	Const Bricks:Int = 10
	Const MushroomBlock:Int = 11
	Const Mushroom1UPBlock:Int = 13
	Const CoinsBlock:Int = 17
	Const StarmanBlock:Int = 18
	Const ShadyBricks:Int = 37
	Const Coin:Int = 40
	
	
	
	Method Init()
		Game.TileMap = Self
		Local AnimatedVisualizer:LTAnimatedTilemapVisualizer = New LTAnimatedTilemapVisualizer
		AnimatedVisualizer.TileNum = New Int[ TilesQuantity ]
		AnimatedVisualizer.Image = Visualizer.GetImage()
		TileShape = New LTShape[ TilesQuantity ]
		For Local N:Int = 0 Until TilesQuantity
			AnimatedVisualizer.TileNum[ N ] = N
			
			If L_IntInLimits( N, 9, 13 ) Or L_IntInLimits( N, 15, 18 ) Or N = 23 Or N = 24 Or N >= 36 Then
				Rem
				If N = 40 Or N = 51 Or N = 52 Then
					Local Coin:TCoin = New TCoin
					For Local N:Int = 0 To 1
						Local Sprite:LTSprite = New LTSprite
						Sprite.SetCoords( 0.5, 0.5 + ( -2.0 + 4.0 * N ) / 16.0 )
						Sprite.SetSize( 10.0 / 16.0, 10.0 / 16.0 )
						Sprite.ShapeType = LTSprite.Circle
						Coin.AddLast( Sprite )
					Next
					TileShape[ N ] = Coin
				Else
				EndRem
				
				Local Sprite:LTSprite = New LTSprite
				Sprite.SetCoords( 0.5, 0.5 )
				Sprite.ShapeType = LTSprite.Rectangle
				TileShape[ N ] = Sprite
			End If
		Next
		AnimatedVisualizer.TileNum[ MushroomBlock ] = QuestionBlock
		AnimatedVisualizer.TileNum[ Mushroom1UPBlock ] = EmptyBlock
		AnimatedVisualizer.TileNum[ CoinsBlock ] = Bricks
		AnimatedVisualizer.TileNum[ StarmanBlock ] = Bricks
		Visualizer = AnimatedVisualizer
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