'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TBricks Extends LTVectorSprite
	Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
		Game.TileMap.SetTile( TileX, TileY, 0 )
		For Local Y:Int = -1 To 1 Step 2
			For Local X:Int = -1 To 1 Step 2
				Local Bricks:TBricks = New TBricks
				Bricks.SetAsTile( Game.TileMap, TileX, TileY )
				Bricks.X :+ 0.25 * X
				Bricks.Y :+ 0.25 * Y
				Bricks.Width :* 0.5
				Bricks.Height :* 0.5
				Bricks.DX = 3.0 * X
				Bricks.DY = 3.0 * ( Y - 3.0 )
				Bricks.Visualizer = LTImageVisualizer.FromImage( Game.Bricks )
				If TileNum = 27 Then Bricks.Frame = 1
				Game.MainLayer.AddLast( Bricks )
			Next
		Next
	End Function

	

	Method Act()
		LTImageVisualizer( Visualizer ).Angle :+ DX * 180.0 * L_DeltaTime
		DY :+ 32.0 * L_DeltaTime
		MoveForward()
		If Not TopY() > Game.Tilemap.BottomY() Then Game.MainLayer.Remove( Self )
	End Method
End Type