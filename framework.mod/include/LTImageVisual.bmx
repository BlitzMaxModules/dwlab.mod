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
	
	
	
	Function FromFile:LTImageVisual( Filename:String, XCells:Int = 0, YCells:Int = 0 )
		Local ImageVisual:LTImageVisual = New LTImageVisual
		ImageVisual.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return ImageVisual
	End Function
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		
		If Rotating Then SetRotation( Pivot.Angle )
		If Scaling Then
			Local SDist:Float = L_CurrentCamera.DistFieldToScreen( 1.0 )
			SetScale( VisualScale * SDist, VisualScale * SDist )
		End If
		
		DrawImage( Image.Handle, SX, SY, Pivot.Frame )
		
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
		
		If Rotating Then SetRotation( Circle.Angle )
		If Scaling Then
			Local SDist:Float = L_CurrentCamera.DistFieldToScreen( Circle.Diameter )
			SetScale( VisualScale * SDist / ImageWidth( Image.Handle ), VisualScale * SDist / ImageHeight( Image.Handle ) )
		End If
		
		DrawImage( Image.Handle, SX, SY, Circle.Frame )

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
		
		If Rotating Then SetRotation( Rectangle.Angle )
		If Scaling Then
			L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize, Rectangle.YSize, SXSize, SYSize )
			SetScale( VisualScale * SXSize / ImageWidth( Image.Handle ), VisualScale * SYSize / ImageHeight( Image.Handle ) )
		End If
		
		DrawImage( Image.Handle, SX, SY, Rectangle.Frame )
		
		If Scaling Then	SetScale 1.0, 1.0
		If Rotating Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
		Local HX:Int = Image.Handle.Handle_x
		Local HY:Int = Image.Handle.Handle_y
		SetImageHandle Image.Handle, 0, 0
		
		Local XQuantity:Int = TileMap.GetXQuantity()
		Local YQuantity:Int = TileMap.GetYQuantity()
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.XSize, TileMap.Y - 0.5 * TileMap.YSize, SX, SY )

		Local SXSize:Float, SYSize:Float
		Local CellXSize:Float = TileMap.XSize / XQuantity
		Local CellYSize:Float = TileMap.YSize / YQuantity
		L_CurrentCamera.SizeFieldToScreen( CellXSize, CellYSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Image.Handle ), SYSize / ImageHeight( Image.Handle ) )
		
		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.XSize' ) * L_CurrentCamera.XK
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.YSize' ) * L_CurrentCamera.YK
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.XSize' * L_CurrentCamera.XK
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.YSize' * L_CurrentCamera.YK
		
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
				Drawimage( Image.Handle, XX, YY, TileMap.Frame[ XFrame & XMask, YFrame & YMask ] )
				XX = XX + SXSize
				XFrame :+ 1
			Wend
			YY = YY + SYSize
			YFrame :+ 1
		Wend
		
		SetImageHandle( Image.Handle, HX, HY )
	End Method
End Type