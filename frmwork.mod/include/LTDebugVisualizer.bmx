'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Global variable for debug visualizer.
End Rem
Global L_DebugVisualizer:LTDebugVisualizer = New LTDebugVisualizer

Global L_CollisionColors:LTColor[] = [ LTColor.FromHex( "FF007F", 0.5 ), LTColor.FromHex( "007FFF", 0.5 ), ..
		LTColor.FromHex( "00FF7F", 0.5 ), LTColor.FromHex( "7F00FF", 0.5 ), LTColor.FromHex( "7FFF00", 0.5 ), ..
		LTColor.FromHex( "FF7F00", 0.5 ), LTColor.FromHex( "FFFFFF", 0.5 ), LTColor.FromHex( "000000", 0.5 ) ]
Global L_MaxCollisionColor:Int = L_CollisionColors.Length - 1

Rem
bbdoc: This visualizer can draw collision shape, vector and name of the shape with this shape itself.
about: See also #WedgeOffWithSprite example
End Rem
Type LTDebugVisualizer Extends LTVisualizer
	Field ShowCollisionShapes:Int = True
	Field ShowVectors:Int = True
	Field ShowNames:Int = True
	Field AlphaOfInvisible:Double = 0.5
	
	

	Method DrawUsingSprite( Sprite:LTSprite, SpriteShape:LTSprite = Null )
		If Not SpriteShape Then SpriteShape = Sprite
		
		If Sprite.Visible Then
			Sprite.Visualizer.DrawUsingSprite( Sprite, SpriteShape )
		Else
			Local OldAlpha:Double = Sprite.Visualizer.Alpha
			Sprite.Visualizer.Alpha :* AlphaOfInvisible
			Sprite.Visible = True
			
			Sprite.Visualizer.DrawUsingSprite( Sprite )
			
			Sprite.Visualizer.Alpha = OldAlpha
			Sprite.Visible = False
		End If

		Local SX1:Double, SY1:Double, SWidth:Double, SHeight:Double
		L_CurrentCamera.FieldToScreen( SpriteShape.X, SpriteShape.Y, SX1, SY1 )
		L_CurrentCamera.SizeFieldToScreen( SpriteShape.Width, SpriteShape.Height, SWidth, SHeight )
		
		L_CollisionColors[ Sprite.CollisionLayer & L_MaxCollisionColor ].ApplyColor()
		
		If ShowCollisionShapes Then	DrawSpriteShape( SpriteShape )
		
		If ShowVectors Then
			Local Size:Double = Max( SWidth, SHeight )
			If Size Then
				Local SX2:Double = SX1 + Cos( Sprite.Angle ) * Size
				Local SY2:Double = SY1 + Sin( Sprite.Angle ) * Size
				DrawLine( SX1, SY1, SX2, SY2 )
				For Local D:Double = -135 To 135 Step 270
					DrawLine( SX2, SY2, SX2 + 5.0 * Cos( Sprite.Angle + D ), SY2 + 5.0 * Sin( Sprite.Angle + D ) )
				Next
			End If
		End If
		
		ResetColor()
			
		If ShowNames Then
			SetColor( 0, 0, 0 )
			Local Title:String = Sprite.GetTitle()
			Local TextWidth2:Int = Len( Title ) * 4
			For Local DY:Int = -1 To 1
				For Local DX:Int = -( DY = 0 ) To Abs( DY = 0 ) Step 2
					DrawText( Title, SX1 + DX - TextWidth2, SY1 + DY - 16 )
				Next
			Next
			ResetColor()
			DrawText( Title, SX1 - TextWidth2, SY1 - 16 )
		End If
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap, Shapes:TList = Null )
		TileMap.Visualizer.DrawUsingTileMap( TileMap, Shapes )
		If ShowCollisionShapes Then Super.DrawUsingTileMap( TileMap, Shapes )
	End Method
	
	
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, Width:Double, Height:Double, TileX:Int, TileY:Int )
		Local Shape:LTShape = TileMap.GetTileCollisionShape( TileMap.WrapX( TileX ), TileMap.WrapY( TileY ) )
		If Not Shape Then Return
		
		SetScale( 1.0, 1.0 )
		Local Sprite:LTSprite = LTSprite( Shape )
		If Sprite Then
			DrawCollisionSprite( TileMap, X, Y, Sprite )
		Else
			For Sprite = Eachin LTLayer( Shape )
				DrawCollisionSprite( TileMap, X, Y, Sprite )
			Next
		End If
	End Method
	
	
	
	Method DrawCollisionSprite( TileMap:LTTileMap, X:Double, Y:Double, Sprite:LTSprite )
		L_CollisionColors[ Sprite.CollisionLayer & L_MaxCollisionColor ].ApplyColor()
	
		Local TileWidth:Double = TileMap.GetTileWidth()
		Local TileHeight:Double = TileMap.GetTileHeight()
		
		If L_CurrentCamera.Isometric Then
			Local ShapeX:Double = X + ( Sprite.X - 0.5 ) * TileWidth
			Local ShapeY:Double = Y + ( Sprite.Y - 0.5 ) * TileHeight
			Local ShapeWidth:Double = Sprite.Width * TileWidth
			Local ShapeHeight:Double = Sprite.Height * TileHeight
			Select Sprite.ShapeType
				Case LTSprite.Pivot
					Local SX:Double, SY:Double
					L_CurrentCamera.FieldToScreen( ShapeX, ShapeY, SX, SY )
					DrawOval( SX - 2, SY - 2, 5, 5 )
				Case LTSprite.Circle
					DrawIsoOval( ShapeX, ShapeY, ShapeWidth, ShapeHeight )
				Case LTSprite.Rectangle
					DrawIsoRectangle( ShapeX, ShapeY, ShapeWidth, ShapeHeight )
			End Select		
		Else
			Local SX:Double, SY:Double
			L_CurrentCamera.FieldToScreen( X + ( Sprite.X - 0.5 ) * TileWidth, Y + ( Sprite.Y - 0.5 ) * TileHeight, SX, SY )
			
			Local SWidth:Double, SHeight:Double
			L_CurrentCamera.SizeFieldToScreen( Sprite.Width * TileWidth, Sprite.Height * TileHeight, SWidth, SHeight )
			
			Select Sprite.ShapeType
				Case LTSprite.Pivot
					DrawOval( SX - 2, Y - 2, 5, 5 )
				Case LTSprite.Circle
					DrawOval( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
				Case LTSprite.Rectangle
					DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
			End Select
		End If
	End Method
	
	
	
	Method DrawSpriteMapTile( SpriteMap:LTSpriteMap, X:Double, Y:Double )
		SetScale( 1.0, 1.0 )
		For Local Sprite:LTSprite = Eachin SpriteMap.Lists[ Int( Floor( X / SpriteMap.CellWidth ) ) & SpriteMap.XMask, ..
				Int( Floor( Y / SpriteMap.CellHeight ) ) & SpriteMap.YMask ]
			L_CollisionColors[ Sprite.CollisionLayer & L_MaxCollisionColor ].ApplyColor()
			DrawSpriteShape( Sprite )
		Next
	End Method
End Type