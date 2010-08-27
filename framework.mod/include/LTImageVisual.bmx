'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTImage.bmx"

Type LTImageVisual Extends LTVisual
	Field Image:LTImage
	Field Rotating:Int = True
	
	
	
	Function FromFile:LTImageVisual( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		Local ImageVisual:LTImageVisual = New LTImageVisual
		ImageVisual.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return ImageVisual
	End Function
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		
		If Rotating Then SetRotation( Pivot.Model.GetAngle() )
		If Scaling Then
			Local SXSize:Float, SYSize:Float
			L_CurrentCamera.SizeFieldToScreen( XScale, YScale, SXSize, SYSize ) 
			SetScale( SXSize, SYSize )
		End If
		
		DrawImage( Image.BMaxImage, SX, SY, Pivot.Frame )
		
		If Scaling Then SetScale 1.0, 1.0
		If Rotating Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Circle.X, Circle.Y, SX, SY )
		
		If Rotating Then SetRotation( Circle.Model.GetAngle() )
		If Scaling Then
			Local SDist:Float = L_CurrentCamera.DistFieldToScreen( Circle.Diameter )
			SetScale( XScale * SDist / ImageWidth( Image.BMaxImage ), YScale * SDist / ImageHeight( Image.BMaxImage ) )
		End If
		
		DrawImage( Image.BMaxImage, SX, SY, Circle.Frame )

		If Scaling Then	SetScale 1.0, 1.0
		If Rotating Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		
		If Rotating Then SetRotation( Rectangle.Model.GetAngle() )
		If Scaling Then
			L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize, Rectangle.YSize, SXSize, SYSize )
			SetScale( XScale * SXSize / ImageWidth( Image.BMaxImage ), YScale * SYSize / ImageHeight( Image.BMaxImage ) )
		End If
		
		DrawImage( Image.BMaxImage, SX, SY, Rectangle.Frame )
		
		If Scaling Then	SetScale 1.0, 1.0
		If Rotating Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
		Local HX:Int = Image.BMaxImage.Handle_x
		Local HY:Int = Image.BMaxImage.Handle_y
		SetImageHandle Image.BMaxImage, 0, 0
		
		Local XQuantity:Int = TileMap.GetXQuantity()
		Local YQuantity:Int = TileMap.GetYQuantity()
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.XSize, TileMap.Y - 0.5 * TileMap.YSize, SX, SY )

		Local SXSize:Float, SYSize:Float
		Local CellXSize:Float = TileMap.XSize / XQuantity
		Local CellYSize:Float = TileMap.YSize / YQuantity
		L_CurrentCamera.SizeFieldToScreen( CellXSize, CellYSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Image.BMaxImage ), SYSize / ImageHeight( Image.BMaxImage ) )
		
		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.XSize
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.YSize
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.XSize
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.YSize
		
		Local StartXFrame:Int = Floor( ( L_CurrentCamera.X - TileMap.X - 0.5 * ( L_CurrentCamera.XSize - TileMap.XSize ) ) / CellXSize )
		Local StartYFrame:Int = Floor( ( L_CurrentCamera.Y - TileMap.Y - 0.5 * ( L_CurrentCamera.YSize - TileMap.YSize ) ) / CellYSize )
		Local StartX:Float = SX + SXSize * Floor( ( X1 - SX ) / SXSize )
		Local StartY:Float = SY + SYSize * Floor( ( Y1 - SY ) / SYSize )
		'Debugstop
		Local XMask:Int = TileMap.GetXMask()
		Local YMask:Int = TileMap.GetYMask()
		
		Local YY:Float = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Float = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				Drawimage( Image.BMaxImage, XX, YY, TileMap.Frame[ XFrame & XMask, YFrame & YMask ] )
				XX = XX + SXSize
				XFrame :+ 1
			Wend
			YY = YY + SYSize
			YFrame :+ 1
		Wend
		
		SetImageHandle( Image.BMaxImage, HX, HY )
	End Method
End Type