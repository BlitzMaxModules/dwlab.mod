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
	Const RotationSpeed:Double = 180.0

	
	
	Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
		If TileNum = TTiles.ShadyBricks Then 
			Game.TileMap.SetTile( TileX, TileY, TTiles.DarkEmptyBlock )
		Else
			Game.TileMap.SetTile( TileX, TileY, TTiles.EmptyBlock )
		End If
		For Local Y:Int = -1 To 1 Step 2
			For Local X:Int = -1 To 1 Step 2
				Local Bricks:TBricks = New TBricks
				Bricks.SetAsTile( Game.TileMap, TileX, TileY )
				Bricks.SetCoords( Bricks.X + 0.25 * X, Bricks.Y + 0.25 * Y )
				Bricks.SetSize( Bricks.Width * 0.5, Bricks.Height * 0.5 )
				Bricks.DX = 3.0 * X
				Bricks.DY = 3.0 * ( Y - 3.0 )
				Bricks.Visualizer = LTImageVisualizer.FromImage( Game.Bricks )
				If TileNum = TTiles.ShadyBricks Then Bricks.Frame = 1
				Bricks.AttachModel( New TGravity )
				Bricks.AttachModel( New TRemoveIfOutside )
				Game.Level.AddLast( Bricks )
			Next
		Next
		Game.BreakBlock.Play()
	End Function

	

	Method Act()
		Super.Act()
		LTImageVisualizer( Visualizer ).Angle :+ DX * Game.PerSecond( RotationSpeed )
		MoveForward()
	End Method
End Type