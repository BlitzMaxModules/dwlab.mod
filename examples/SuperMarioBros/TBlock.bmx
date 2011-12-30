'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TCoin.bmx"
Include "TBricks.bmx"

Type TBlock Extends LTVectorSprite
	Const Gravity:Double = 8.0
	Const Impulse:Double = 1.5

	Field LowestY:Double
	Field TileX:Int, TileY:Int, TileNum:Int
	
	
	
	Function FromTile( TileX:Int, TileY:Int, TileNum:Int )
		Local Block:TBlock = New TBlock
		Block.SetAsTile( Game.TileMap, TileX, TileY )
		Game.TileMap.SetTile( TileX, TileY, 53 )
		Block.TileX = TileX
		Block.TileY = TileY
		Block.LowestY = Block.Y
		Block.DY = -Impulse
		Block.Frame = TTiles.SolidBlock
		Select TileNum
			Case TTiles.QuestionBlock
				TCoin.FromTile( TileX, TileY )
			Case TTiles.CoinsBlock
				TCoin.FromTile( TileX, TileY )
				Game.Level.AttachModel( TTileChange.Create( TileX, TileY ) )
				Block.Frame = TileNum 
			Case TTiles.MushroomBlock
				If Mario.FindModel( "TBig" ) Then
					TFireFlower.FromTile( TileX, TileY )
				Else
					TMushroom.FromTile( TileX, TileY )
				End If
			Case TTiles.Mushroom1UPBlock
				TOneUpMushroom.FromTile( TileX, TileY )
			Case TTiles.StarmanBlock
				TStarMan.FromTile( TileX, TileY )
			Case TTiles.Bricks, TTiles.ShadyBricks
				Block.Frame = TileNum 
		End Select

		Game.Bump.Play()
		Game.Level.AddLast( Block )
	End Function
	
	
	
	Method Act()
		DY :+ Game.PerSecond( Gravity )
		MoveForward()
		If Y >= LowestY And DY > 0 Then
			Game.Tilemap.SetTile( TileX, TileY, Frame )
			Game.Level.Remove( Self )
		End If
		CollisionsWithSpriteMap( Game.MovingObjects, New TBlockHit )
	End Method
End Type



Type TBlockHit Extends LTSpriteCollisionHandler
	Method HandleCollision( Sprite1:LTSprite, Sprite2:LTSprite )
		Local Sprite:LTVectorSprite = LTVectorSprite( Sprite1 )
		If Sprite.DY < 0.0 Then
			Local Bonus:TBonus = TBonus( Sprite2 )
			If Bonus Then
				Bonus.DY = -TBonus.Impulse
				Bonus.DX = Abs( Bonus.DX ) * Sgn( Bonus.X - Sprite.X )
			ElseIf TEnemy( Sprite2 ) Then
				TEnemy( Sprite2 ).AttachModel( New TKicked )
			End If
		End If
	End Method
End Type




Type TTileChange Extends LTBehaviorModel
	Const Period:Double = 8.0	

	Field TileX:Int, TileY:Int
	Field StartingTime:Double
	
	
	
	Function Create:TTileChange( TileX:Int, TileY:Int )
		Local TileChange:TTileChange = New TTileChange
		TileChange.TileX = TileX
		TileChange.TileY = TileY
		Return TileChange
	End Function
	
	
	
	Method Activate( Shape:LTShape )
		StartingTime = Game.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Game.Time >= StartingTime + Period Then
			If Game.Tilemap.GetTile( TileX, TileY ) <> 53 Then
				Game.Tilemap.SetTile( TileX, TileY, TTiles.SolidBlock )
				Remove( Shape )
			End If
		End If
	End Method
End Type