'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTImageVisual Extends LTVisual
	Field Image:LTImage
	Field NoRotate:Int
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		
		If Not NoRotate Then SetRotation( Pivot.Angle )
		If Not NoScale Then
			Local SDist:Float = L_CurrentCamera.DistFieldToScreen( 1.0 )
			SetScale( VisualScale * SDist, VisualScale * SDist )
		End If
		
		DrawImage( Image.Handle, SX, SY, Pivot.Frame )
		
		If Not NoScale Then SetScale 1.0, 1.0
		If Not NoRotate Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Circle.X, Circle.Y, SX, SY )
		
		If Not NoRotate Then SetRotation( Circle.Angle )
		If Not NoScale Then
			Local SDist:Float = L_CurrentCamera.DistFieldToScreen( Circle.Diameter )
			SetScale( VisualScale * SDist / ImageWidth( Image.Handle ), VisualScale * SDist / ImageHeight( Image.Handle ) )
		End If
		
		DrawImage( Image.Handle, SX, SY, Circle.Frame )
		
		If Not NoScale Then	SetScale 1.0, 1.0
		If Not NoRotate Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
		SetScale 1.0, 1.0
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		
		If Not NoRotate Then SetRotation( Rectangle.Angle )
		If Not NoScale Then
			L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize, Rectangle.YSize, SXSize, SYSize )
			SetScale( VisualScale * SXSize / ImageWidth( Image.Handle ), VisualScale * SYSize / ImageHeight( Image.Handle ) )
		End If
		
		DrawImage( Image.Handle, SX, SY, Rectangle.Frame )
		
		If Not NoScale Then	SetScale 1.0, 1.0
		If Not NoRotate Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
End Type





Type LTImage Extends LTObject
	Field Handle:TImage
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 0, YCells:Int = 0 )
		Local Image:LTImage = New LTImage
		If XCells Then
			Local Pixmap:TPixmap = LoadPixmap( Filename )
			Image.Handle = LoadAnimImage( Pixmap, Pixmap.Width / XCells, Pixmap.Height / YCells, 0, XCells * YCells )
		Else
			Image.Handle = LoadImage( Filename )
		End If
		Image.SetHandle( 0.5, 0.5 )
		Return Image
	End Function
	
	
	
	Method SetHandle( X:Float, Y:Float )
		SetImageHandle( Handle, X * ImageWidth( Handle ), Y * ImageHeight( Handle ) )
	End Method
End Type