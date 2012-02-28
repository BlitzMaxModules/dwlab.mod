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
	Method HandleCollision( Sprite:LTSprite, TileMap:LTTileMap, TileX:Int, TileY:Int )
		Game.SelectedTileX = TileX
		Game.SelectedTileY = TileY
		Local TileNum:Int = TileMap.GetTile( TileX, TileY )
		Local BallNum:Int = Profile.Balls.GetTile( TileX, TileY )
		Local ModifierNum:Int = Profile.Modifiers.GetTile( TileX, TileY )
		'If KeyHit( Key_E ) Then TExplosion.Create( TileX, TileY )
		If Game.LeftMouse.WasPressed() Then
			'DebugStop
			If Game.Selected Then Game.Selected.Remove( Null )
			If TileNum = Profile.Void Then Return
			If BallNum = Profile.NoBall
				If Not Game.Selected Then Return
				TMoveAlongPath.Create( Game.PathFinder.FindPath( Game.Selected.X, Game.Selected.Y, TileX, TileY ), TileX, TileY )
			Else
				If TileNum = Profile.Glue Or TileNum = Profile.ColdGlue Then
					If Profile.SoundOn Then L_PlaySound( Game.WrongTurnSound )
					Return
				End If
				Game.Selected = TSelected.Create( TileX, TileY )
				L_PlaySound( Game.SelectSound )
			End If
		ElseIf Game.RightMouse.WasPressed() 
			if BallNum = Profile.Bomb Then
				For Local DY:Int = - 1 To 1
					For Local DX:Int = -1 To 1
						Local XDX:Int = TileX + DX
						Local YDY:Int = TileY + DY
						If XDX > 0 And YDY > 0 And XDX < Profile.Balls.XQuantity - 1 And YDY < Profile.Balls.YQuantity - 1 Then
							TExplosion.Create( XDX, YDY )
						End If
					Next
				Next
			ElseIf ModifierNum = Profile.AnyColor Then
				Local Project:TColorSelection = New TColorSelection
				Project.TileX = TileX
				Project.TileY = TileY
				Game.SwitchTo( Project )
			Else If Game.Selected And Profile.Swap Then
				If BallNum = Profile.NoBall Then Return
				If TileNum = Profile.Glue Or TileNum = Profile.ColdGlue Then 
					If Profile.SoundOn Then L_PlaySound( Game.WrongTurnSound )
					Return
				End If
				If Game.Selected Then Game.Selected.Remove( Null )
				If Abs( Game.Selected.X - TileX ) + Abs( Game.Selected.Y - TileY ) = 1 Then
					TMoveBall.Create( Game.Selected.X, Game.Selected.Y, TileX - Game.Selected.X, TileY - Game.Selected.Y, False )
					TMoveBall.Create( TileX, TileY, Game.Selected.X - TileX, Game.Selected.Y - TileY, True )
					Profile.Balls.SwapTiles( TileX, TileY, Game.Selected.X, Game.Selected.Y )
					Profile.Modifiers.SwapTiles( TileX, TileY, Game.Selected.X, Game.Selected.Y )
					If Profile.SoundOn Then L_PlaySound( Game.SwapSound )
				Else
					If Profile.SoundOn Then L_PlaySound( Game.WrongTurnSound )
				End If
			End If
		End If
	End Method
End Type



Type TColorSelection Extends LTProject
	Field TileX:Int, TileY:Int
	Field Balls:LTLayer = New LTLayer
	
	Method Init()
		Local BallNum:Int = Profile.Balls.GetTile( TileX, TileY )
		For Local N:Int = 1 To 7
			Local Sprite:LTSprite = LTSprite.FromShape( , , , , LTSprite.Circle )
			Sprite.SetAsTile( Profile.Balls, TileX, TileY )
			Sprite.SetDiameter( 0.0 )
			Sprite.Frame = N
			Sprite.AttachModel( LTResizingModel.Create( 0.3, 1.0 ) )
			If N <> BallNum Then
				Local Angle:Double = 60.0 * ( N - ( N > BallNum ) - 1 )
				Sprite.AttachModel( LTTimedMovementModel.Create( 0.3, Sprite.X + Cos( Angle ), Sprite.Y + Sin( Angle ) ) )
			End If
			Balls.AddLast( Sprite )
		Next
	End Method

	Method Logic()
		If Game.RightMouse.WasPressed() Or Profile.BossKey.WasPressed() Then Exiting = True
		If Game.LeftMouse.WasPressed() Then
			Local Ball:LTSprite = Balls.LayerFirstSpriteCollision( L_Cursor )
			If Ball Then
				Profile.Balls.SetTile( TileX, TileY, Ball.Frame )
				Exiting = True
			End If
		End If
		Balls.Act()
	End Method

	Method Render()
		Game.FullRender()
		L_CurrentCamera.Darken( 0.3 )
		Balls.Draw()
	End Method
End Type