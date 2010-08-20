' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTImage Extends LTVisual
	Field Handle:TImage
	
	
	
	Function FromFile:LTImage( Filename:String )
		Image:LTImage = New LTImage
		Image.Handle = LoadImage( Filename )
		Return Image
	End Function
	
	
	
	Method UseWith( Model:LTModel )
		Model.DrawUsing( Self )
	End Method
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		DrawImage( Handle, SX, SY )
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
		Local OldScaleX:Float, OldScaleY:Float
		GetScale( OldScaleX, OldScaleY )
	
		Local SX:Float, SY:Float, SDist:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		SDist = L_CurrentCamera.DistFieldToScreen( Circle.Diameter )
		SetScale( SDist / ImageWidth( Handle ), SDist / ImageHeight( Handle ) )
		DrawImage( Handle, SX, SY )
		
		SetScale( OldScaleX, OldScaleY )
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		Local OldScaleX:Float, OldScaleY:Float
		GetScale( OldScaleX, OldScaleY )
	
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Rectangle.X, Rectangle.Y, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Rectangle.XSize, Rectangle.YSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Handle ), SYSize / ImageHeight( Handle ) )
		DrawImage( Handle, SX, SY )
		
		SetScale( OldScaleX, OldScaleY )
	End Method
End Type