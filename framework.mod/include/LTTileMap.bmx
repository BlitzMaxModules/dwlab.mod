'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTExtendedTileMap.bmx"

Type LTTileMap Extends LTImageVisual
	Field TileNum:LTIntMap
	Field Wrapped:Int
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local XQuantity:Int = TileNum.GetXQuantity()
		Local YQuantity:Int = TileNum.GetYQuantity()
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X - 0.5 * Rectangle.XSize, Rectangle.Y - 0.5 * Rectangle.YSize, SX, SY )

		Local SXSize:Float, SYSize:Float
		Local CellXSize:Float = Rectangle.XSize / XQuantity
		Local CellYSize:Float = Rectangle.YSize / YQuantity
		L_CurrentCamera.SizeFieldToScreen( CellXSize, CellYSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Image.BMaxImage ), SYSize / ImageHeight( Image.BMaxImage ) )
		
		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.XSize
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.YSize
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.XSize
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.YSize
		
		Local StartXFrame:Int = Floor( ( L_CurrentCamera.X - Rectangle.X - 0.5 * ( L_CurrentCamera.XSize - Rectangle.XSize ) ) / CellXSize )
		Local StartYFrame:Int = Floor( ( L_CurrentCamera.Y - Rectangle.Y - 0.5 * ( L_CurrentCamera.YSize - Rectangle.YSize ) ) / CellYSize )
		Local StartX:Float = SX + SXSize * ( 0.5 + Floor( ( X1 - SX ) / SXSize ) )
		Local StartY:Float = SY + SYSize * ( 0.5 + Floor( ( Y1 - SY ) / SYSize ) )
		
		If Not Wrapped Then
			If StartXFrame < 0 Then 
				StartX :- StartXFrame * SXSize
				StartXFrame = 0
			End If
			Local EndX:Float = StartX + SXSize * ( XQuantity - StartXFrame )
			If  EndX < X2  Then X2 = EndX
			
			If StartYFrame < 0 Then 
				StartY :- StartYFrame * SYSize
				StartYFrame = 0
			End If
			Local EndY:Float = StartY + SYSize * ( YQuantity - StartYFrame )
			If  EndY < Y2  Then Y2 = EndY
		End If
		
		Local YY:Float = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Float = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				DrawTile( XX, YY, L_Wrap( XFrame, XQuantity ), L_Wrap( YFrame, YQuantity ) )
				XX = XX + SXSize
				XFrame :+ 1
			Wend
			YY = YY + SYSize
			YFrame :+ 1
		Wend
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawTile( X:Float, Y:Float, TileX:Int, TileY:Int )
			Drawimage( Image.BMaxImage, X, Y, TileNum.Value[ TileX, TileY ] )
	End Method
End Type