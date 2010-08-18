' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Type LTVisual Extends LTObject
	Field NextVisual:LTVisual
	
	
	
	Method UseWith( Actor:LTActor )
	End Method
	
	
	
	Method DrawWithPoint( X:Float, Y:Float )
	End Method
	
	
	
	Method DrawWithCircle( X:Float, Y:Float, Diameter:Float )
	End Method
	
	
	
	Method DrawWithRectangle( X:Float, Y:Float, XSize:Float, YSize:Float )
	End Method
End Type





Type LTImage Extends LTVisual
	Field Handle:TImage
	
	
	
	Function FromFile:LTImage( Filename:String )
		Image:LTImage = New LTImage
		Image.Handle = LoadImage( Filename )
		Return Image
	End Function
	
	
	
	Method UseWith( Actor:LTActor )
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( Actor
		DrawImage( Handle, 
	End Method
	
	
	
	Method DrawWithPoint( Pivot:LTPivot )
	End Method
	
	
	
	Method DrawWithCircle( Pivot:LTPivot, Circle:LTCircle )
	End Method
	
	
	
	Method DrawWithRectangle( Pivot:LTPivot, Rectangle:LTRectangle )
	End Method
End Type





Type LTUseColor Extends LTVisual
	Field Color:LTColor = New LTColor
	
	
	
	Method UseWith( Actor:LTActor )
		Local OldR:Int, OldG:Int, OldB:Int
		GetColor( OldR, OldG, OldB )
		Color.Set()
		NextVisual.UseWith( Actor )
		SetColor( OldR, OldG, OldB )
	End Method
End Type





Type LTUseAlpha Extends LTVisual
	
End Type




Type LTColor Extends LTObject
	Field R:Float
	Field G:Float
	Field B:Float
	
	
	
	Method Set()
		SetColor( 255.0 * R, 255.0 * G, 255.0 * B )
	End Method
	
	
	
	Function FromHex:LTColor( S:String )
		Local Color:LTColor = New LTColor
		Color.R = 1.0 * HexToInt( S[ 0..2 ] ) / 255.0
		Color.G = 1.0 * HexToInt( S[ 2..4 ] ) / 255.0
		Color.B = 1.0 * HexToInt( S[ 4..6 ] ) / 255.0
		Return Color
	End Function
	
	
	
	Function HexToInt:Int( HexString:String )
		Local Value:Int = 0
		HexString = HexString.ToUpper().Trim()
		For Local N:Int = 0 Until Len( HexString )
			If HexString[ N ] <= Asc( "9" ) Then
				Value = Value * 16 + ( HexString[ N ] - Asc( "0" ) )
			Else
				Value = Value * 16 + ( HexString[ N ] - Asc( "A" ) + 10 )
			End If
		Next
		Return Value
	End Function
End Type