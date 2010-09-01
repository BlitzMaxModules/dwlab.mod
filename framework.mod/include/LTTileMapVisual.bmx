'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTExtendedTileMapVisual.bmx"

Type LTTileMapVisual Extends LTImageVisual
	Field TileMap:LTIntMap
	Field Wrapped:Int
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		?debug
		L_Assert( TileMap <> Null, "There's no TileMap set in TilemapVisual" )
		L_Assert( Image <> Null, "Image for TilemapVisual is not set" )
		?
	
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SXSize:Float, SYSize:Float
		Local CellXSize:Float = Rectangle.XSize / TileMap.XQuantity
		Local CellYSize:Float = Rectangle.YSize / TileMap.YQuantity
		L_CurrentCamera.SizeFieldToScreen( CellXSize, CellYSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Image.BMaxImage ), SYSize / ImageHeight( Image.BMaxImage ) )
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X - 0.5 * Rectangle.XSize, Rectangle.Y - 0.5 * Rectangle.YSize, SX, SY )

		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.XSize
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.YSize
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.XSize + SXSize * 0.5
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.YSize + SYSize * 0.5
		
		Local StartXFrame:Int = Int( ( L_CurrentCamera.X - Rectangle.X - 0.5 * ( L_CurrentCamera.XSize - Rectangle.XSize ) ) / CellXSize )
		Local StartYFrame:Int = Int( ( L_CurrentCamera.Y - Rectangle.Y - 0.5 * ( L_CurrentCamera.YSize - Rectangle.YSize ) ) / CellYSize )
		Local StartX:Float = SX + SXSize * ( Int( ( X1 - SX ) / SXSize ) ) + SXSize * 0.5
		Local StartY:Float = SY + SYSize * ( Int( ( Y1 - SY ) / SYSize ) ) + SYSize * 0.5
		
		If Not Wrapped Then
			If StartXFrame < 0 Then 
				StartX :- StartXFrame * SXSize
				StartXFrame = 0
			End If
			Local EndX:Float = StartX + SXSize * ( TileMap.XQuantity - StartXFrame )
			If  EndX < X2  Then X2 = EndX
			
			If StartYFrame < 0 Then 
				StartY :- StartYFrame * SYSize
				StartYFrame = 0
			End If
			Local EndY:Float = StartY + SYSize * ( TileMap.YQuantity - StartYFrame )
			If  EndY < Y2  Then Y2 = EndY
		End If
		
		Local YY:Float = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Float = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				DrawTile( XX, YY, L_Wrap( XFrame, TileMap.XQuantity ), L_Wrap( YFrame, TileMap.YQuantity ) )
				XX = XX + SXSize
				XFrame :+ 1
			Wend
			YY = YY + SYSize
			YFrame :+ 1
		Wend
		
		SetColor( 255, 255, 255 )
		SetScale( 1.0, 1.0 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawTile( X:Float, Y:Float, TileX:Int, TileY:Int )
			Drawimage( Image.BMaxImage, X, Y, TileMap.Value[ TileX, TileY ] )
	End Method
End Type