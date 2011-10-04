'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TCursor Extends LTSprite
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int = 0 )
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		Local BallNum:Int = Game.Balls.GetTile( TileX, TileY )
		'If KeyHit( Key_E ) Then TExplosion.Create( TileX, TileY )
		If MouseHit( 1 ) Then
			'DebugStop
			If Game.Selected Then Game.Selected.Remove( Null )
			If TileNum = Game.Void Then Return
			If BallNum = Game.NoBall
				If Not Game.Selected Then Return
				TMoveAlongPath.Create( Game.PathFinder.FindPath( Game.Selected.X, Game.Selected.Y, TileX, TileY ) )
			Else
				Game.Selected = TSelected.Create( TileX, TileY )
				Game.SelectSound.Play()
			End If
		ElseIf MouseHit( 2 ) And Game.Selected Then
			If Game.Selected Then Game.Selected.Remove( Null )
			If Abs( Game.Selected.X - TileX ) + Abs( Game.Selected.Y - TileY ) = 1 Then
				TMoveBall.Create( Game.Selected.X, Game.Selected.Y, TileX - Game.Selected.X, TileY - Game.Selected.Y, False )
				TMoveBall.Create( TileX, TileY, Game.Selected.X - TileX, Game.Selected.Y - TileY, True )
				Game.SwapSound.Play()
			End If
		End If
	End Method
End Type