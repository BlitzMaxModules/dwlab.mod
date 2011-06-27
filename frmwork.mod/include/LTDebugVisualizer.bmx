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
bbdoc: Global variable for debug vesualizer.
End Rem
Global L_DebugVisualizer:LTDebugVisualizer = New LTDebugVisualizer
L_DebugVisualizer.SetColorFromRGB( 1.0, 0.0, 1.0 )
L_DebugVisualizer.Alpha = 0.5

Rem
bbdoc: This visualizer can draw collision shape, vector and name of the shape with this shape itself.
End Rem
Type LTDebugVisualizer Extends LTVisualizer
	Field ShowCollisionShapes:Int = True
	Field ShowVectors:Int = True
	Field ShowNames:Int = True
	
	

	Method DrawUsingSprite( Sprite:LTSprite )
		Sprite.Visualizer.DrawUsingSprite( Sprite )
		
		ApplyColor()

		Local SX1:Double, SY1:Double, SWidth:Double, SHeight:Double, Angle:Double
		L_CurrentCamera.FieldToScreen( Sprite.X, Sprite.Y, SX1, SY1 )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
		
		If ShowCollisionShapes Then
			Select Sprite.ShapeType
				Case LTSprite.Pivot
					DrawOval( SX1 - 2, SY1 - 2, 5, 5 )
				Case LTSprite.Circle
					DrawOval( SX1 - 0.5 * SWidth, SY1 - 0.5 * SHeight, SWidth, SHeight )
				Case LTSprite.Rectangle
					DrawRect( SX1 - 0.5 * SWidth, SY1 - 0.5 * SHeight, SWidth, SHeight )
			End Select
		End If
		
		If ShowVectors Then
			Local Size:Double = Max( SWidth, SHeight )
			Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
			If AngularSprite Then
				Angle = AngularSprite.Angle
			Else
				Local VectorSprite:LTVectorSprite = LTVectorSprite( Sprite )
				If VectorSprite Then
					Angle = ATan2( VectorSprite.DY, VectorSprite.DX )
				Else
					Size = 0
				End If
			End If
			
			If Size Then
				Local SX2:Double = SX1 + Cos( Angle ) * Size
				Local SY2:Double = SY1 + Sin( Angle ) * Size
				DrawLine( SX1, SY1, SX2, SY2 )
				For Local D:Double = -135 To 135 Step 270
					DrawLine( SX2, SY2, SX2 + 5.0 * Cos( Angle + D ), SY2 + 5.0 * Sin( Angle + D ) )
				Next
			End If
		End If
		
		ResetColor()
		
		If ShowNames Then
			SetColor( 0, 0, 0 )
			Local TextWidth2:Int = Len( Sprite.Name ) * 4
			For Local DY:Int = -1 To 1
				For Local DX:Int = -( DY = 0 ) To Abs( DY = 0 ) Step 2
					DrawText( Sprite.Name, SX1 + DX - TextWidth2, SY1 + DY - 16 )
				Next
			Next
			ResetColor()
			DrawText( Sprite.Name, SX1 - TextWidth2, SY1 - 16 )
		End If
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
		TileMap.Visualizer.DrawUsingTileMap( TileMap )
		Super.DrawUsingTileMap( TileMap )
	End Method
	
	
	
	Method DrawTile( TileMap:LTTileMap, X:Double, Y:Double, TileX:Int, TileY:Int )
		If Not ShowCollisionShapes Then Return
		Local Shape:LTShape = TileMap.GetTileCollisionShape( TileX, TileY )
		If Not Shape Then Return
		SetScale( 1.0, 1.0 )
		Local Sprite:LTSprite = LTSprite( Shape )
		If Sprite Then
			DrawCollisionSprite( TileMap, X, Y, Sprite )
		Else
			For Sprite = Eachin LTGroup( Shape )
				DrawCollisionSprite( TileMap, X, Y, Sprite )
			Next
		End If
	End Method
	
	
	
	Method DrawCollisionSprite( TileMap:LTTileMap, X:Double, Y:Double, Sprite:LTSprite )
		Local TileWidth:Double, TileHeight:Double
		L_CurrentCamera.SizeFieldToScreen( TileMap.GetTileWidth(), TileMap.GetTileHeight(), TileWidth, TileHeight )
		
		Local ShapeX:Double = X + TileWidth * ( Sprite.X - 0.5 )
		Local ShapeY:Double = Y + TileHeight * ( Sprite.Y - 0.5 )
		Local ShapeWidth:Double = TileWidth * Sprite.Width
		Local ShapeHeight:Double = TileHeight * Sprite.Height
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				DrawOval( ShapeX - 2, ShapeY - 2, 5, 5 )
			Case LTSprite.Circle
				DrawOval( ShapeX - 0.5 * ShapeWidth, ShapeY - 0.5 * ShapeHeight, ShapeWidth, ShapeHeight )
			Case LTSprite.Rectangle
				DrawRect( ShapeX - 0.5 * ShapeWidth, ShapeY - 0.5 * ShapeHeight, ShapeWidth, ShapeHeight )
		End Select
	End Method
End Type