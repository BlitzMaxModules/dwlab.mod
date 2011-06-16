'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCoin Extends LTVectorSprite
	Const Gravity:Double = 16.0

	Field LowestY:Double


	
	Function FromTile( TileX:Int, TileY:Int )
		Game.CoinFlip.Play()
		Local Coin:TCoin = New TCoin
		Coin.SetAsTile( Game.Tilemap, TileX, TileY )
		Coin.LowestY = Coin.Y
		Coin.SetSize( 0.5, 0.5 )
		Coin.DY = -10.0
		Coin.Visualizer = Game.Coin
		Coin.Frame = 0
		Coin.LimitByWindow( Coin.X, Coin.Y - 3.5, 1.0, 6.0 )
		Game.Level.AddLast( Coin )
	End Function
	
	
	
	Method Act()
		Animate( Game, 0.1, 4 )
		DY :+ Game.PerSecond( Gravity )
		MoveForward()
		If Y > LowestY Then
			Game.Level.Remove( Self )
			TScore.FromSprite( Self, TScore.s200 )
			Game.Coins :+ 1
		End If
	End Method
End Type