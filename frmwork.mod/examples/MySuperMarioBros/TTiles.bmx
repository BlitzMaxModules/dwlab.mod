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
	
	
	
	Method Init()
		Local AnimatedVisualizer:LTAnimatedTilemapVisualizer = New LTAnimatedTilemapVisualizer
		AnimatedVisualizer.TileNum = New Int[ TilesQuantity ]
		AnimatedVisualizer.Image = Visualizer.GetImage()
		For Local N:Int = 0 Until TilesQuantity
			Select N
				Case 11
					AnimatedVisualizer.TileNum[ N ] = 9
				Case 13
					AnimatedVisualizer.TileNum[ N ] = 0
				Case 17, 18
					AnimatedVisualizer.TileNum[ N ] = 10
				Default
					AnimatedVisualizer.TileNum[ N ] = N
			End Select
		Next
		Visualizer = AnimatedVisualizer
	End Method
	
	
	
	Method Act()
		Local AnimatedVisualizer:LTAnimatedTilemapVisualizer = LTAnimatedTilemapVisualizer( Visualizer )
		Local Fading:Int = Max( ( Floor( Game.Time / FadingSpeed ) Mod ( FadingPeriod + 4 ) ) - FadingPeriod, 0 )
		If Fading = 3 Then Fading = 1
		AnimatedVisualizer.TileNum[ 9 ] = 9 + ( Fading > 0 ) * ( 39 + Fading )
		AnimatedVisualizer.TileNum[ 11 ] = AnimatedVisualizer.TileNum[ 9 ]
		AnimatedVisualizer.TileNum[ 40 ] = 40 + ( Fading > 0 ) * ( 10 + Fading )
	End Method
End Type