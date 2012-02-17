'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TTileSelectionHandler Extends LTSpriteAndTileCollisionHandler
	Field LeftMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 1 ), "Click" )
	Field RightMouse:LTButtonAction = LTButtonAction.Create( LTMouseButton.Create( 2 ), "Swap" )

	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Game.SelectedTileX = TileX
		Game.SelectedTileY = TileY
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		Local BallNum:Int = Profile.Balls.GetTile( TileX, TileY )
		'If KeyHit( Key_E ) Then TExplosion.Create( TileX, TileY )
		If LeftMouse.WasPressed() Then
			'DebugStop
			If Game.Selected Then Game.Selected.Remove( Null )
			If TileNum = Profile.Void Then Return
			If BallNum = Profile.NoBall
				If Not Game.Selected Then Return
				TMoveAlongPath.Create( Game.PathFinder.FindPath( Game.Selected.X, Game.Selected.Y, TileX, TileY ), TileX, TileY )
			Else
				If TileNum = Profile.Glue Or TileNum = Profile.ColdGlue Then Return
				Game.Selected = TSelected.Create( TileX, TileY )
				L_PlaySound( Game.SelectSound )
			End If
		ElseIf RightMouse.WasPressed() And Game.Selected And Profile.Swap Then
			If BallNum = Profile.NoBall Then Return
			If TileNum = Profile.Glue Or TileNum = Profile.ColdGlue Then Return
			If Game.Selected Then Game.Selected.Remove( Null )
			If Abs( Game.Selected.X - TileX ) + Abs( Game.Selected.Y - TileY ) = 1 Then
				Local Z:Int = Profile.Balls.GetTile( TileX, TileY )
				Profile.Balls.SetTile( TileX, TileY, Profile.Balls.GetTile( Game.Selected.X, Game.Selected.Y ) )
				Profile.Balls.SetTile( Game.Selected.X, Game.Selected.Y, Z )
				
				TMoveBall.Create( Game.Selected.X, Game.Selected.Y, TileX - Game.Selected.X, TileY - Game.Selected.Y, False )
				TMoveBall.Create( TileX, TileY, Game.Selected.X - TileX, Game.Selected.Y - TileY, True )
				L_PlaySound( Game.SwapSound )
			End If
		End If
	End Method
End Type