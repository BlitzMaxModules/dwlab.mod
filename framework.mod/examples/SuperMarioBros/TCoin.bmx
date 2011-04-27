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
	Field LowestY:Float


	
	Function FromTile( TileX:Int, TileY:Int )
		Game.CoinSound.Play()
		Local Coin:TCoin = New TCoin
		Coin.SetAsTile( Game.Tilemap, TileX, TileY )
		Coin.LowestY = Coin.Y
		Coin.Width :* 0.5
		Coin.Height :* 0.5
		Coin.DY = -10.0
		Coin.Visualizer = Game.Coin
		Coin.Frame = 0
		Game.MainLayer.AddLast( Coin )
	End Function
	
	
	
	Method Act()
		Animate( Game, 0.1 )
		DY :+ 16.0 * L_DeltaTime
		MoveForward()
		If Y > LowestY Then Game.DestroySprite( Self )
	End Method
End Type