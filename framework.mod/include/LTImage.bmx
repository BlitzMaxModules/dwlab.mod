' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTImage Extends LTVisual
	Field Handle:TImage
	
	
	
	Function FromFile:LTImage( Filename:String, XCells:Int = 0, YCells:Int = 0 )
		Local Image:LTImage = New LTImage
		If XCells Then
			Pixmap:TPixmap = LoadPixmap( Filename )
			Image.Handle = LoadAnimImage( Pixmap, Pixmap.Width() / XCells, Pixmap.Height() / YCells, 0, XCells * YCells )
		Else
			Image.Handle = LoadImage( Filename )
		End If
		Return Image
	End Function
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		SetScale VisualScale, VisualScale
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Pivot.X, Pivot.Y, SX, SY )
		DrawImage( Handle, SX, SY, Frame )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
		SetScale 1.0, 1.0
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
		
		Local SX:Float, SY:Float, SDist:Float
		L_CurrentCamera.FieldToScreen( Circle.X, Circle.Y, SX, SY )
		SDist = L_CurrentCamera.DistFieldToScreen( Circle.Diameter )
		SetScale( VisualScale * SDist / ImageWidth( Handle ), VisualScale * SDist / ImageHeight( Handle ) )
		DrawImage( Handle, SX, SY )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
		SetScale 1.0, 1.0
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize, Rectangle.YSize, SXSize, SYSize )
		SetScale( VisualScale * SXSize / ImageWidth( Handle ), VisualScale * SYSize / ImageHeight( Handle ) )
		DrawImage( Handle, SX, SY )
		
		SetColor 255, 255, 255
		SetAlpha 1.0
		SetScale 1.0, 1.0
	End Method
End Type