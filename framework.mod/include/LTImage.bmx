' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTImage Extends LTVisual
	Field Handle:TImage
	Field NoRotate:Int
	Field NoScale:Int
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 0, YCells:Int = 0 )
		Local Image:LTImage = New LTImage
		If XCells Then
			Local Pixmap:TPixmap = LoadPixmap( Filename )
			Image.Handle = LoadAnimImage( Pixmap, Pixmap.Width / XCells, Pixmap.Height / YCells, 0, XCells * YCells )
		Else
			Image.Handle = LoadImage( Filename )
		End If
		Return Image
	End Function
	
	
	
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
		
		DrawImage( Handle, SX, SY, Pivot.Frame )
		
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
			SetScale( VisualScale * SDist / ImageWidth( Handle ), VisualScale * SDist / ImageHeight( Handle ) )
		End If
		
		DrawImage( Handle, SX, SY, Circle.Frame )
		
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
			SetScale( VisualScale * SXSize / ImageWidth( Handle ), VisualScale * SYSize / ImageHeight( Handle ) )
		End If
		
		DrawImage( Handle, SX, SY, Rectangle.Frame )
		
		If Not NoScale Then	SetScale 1.0, 1.0
		If Not NoRotate Then SetRotation 0.0
		
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method SetHandle( X:Float, Y:Float )
		SetImageHandle( Handle, X * ImageWidth( Handle ), Y * ImageHeight( Handle ) )
	End Method
End Type