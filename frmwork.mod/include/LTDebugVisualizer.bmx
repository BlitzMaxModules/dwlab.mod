'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTDebugVisualizer Extends LTVisualizer
	Field ShowCollisionShapes:Int = True
	Field ShowVectors:Int = True
	Field ShowNames:Int = True
	
	

	Method DrawUsingSprite( Sprite:LTSprite )
		Sprite.Visualizer.DrawUsingSprite( Sprite )
		
		ApplyColor()

		Local SX1:Float, SY1:Float, SWidth:Float, SHeight:Float, Angle:Float
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
			Local Size:Float = Max( SWidth, SHeight )
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
				Local SX2:Float = SX1 + Cos( Angle ) * Size
				Local SY2:Float = SY1 + Sin( Angle ) * Size
				DrawLine( SX1, SY1, SX2, SY2 )
				For Local D:Float = -135 To 135 Step 270
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
	End Method
End Type





Global L_DebugVisualizer:LTDebugVisualizer = New LTDebugVisualizer
L_DebugVisualizer.SetColorFromRGB( 1.0, 0.0, 1.0 )
L_DebugVisualizer.Alpha = 0.5