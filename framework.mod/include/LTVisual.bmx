' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Include "LTImage.bmx"
Include "LTFilledPrimitive.bmx"

Type LTVisual Extends LTObject Abstract
	Field R:Float = 1.0, G:Float = 1.0, B:Float = 1.0
	Field Alpha:Float = 1.0
	Field VisualScale:Float = 1.0
	Field Frame:Int = 0
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
	End Method
	
	
	
	Method SetColorFromHex( S:String )
		R = 1.0 * HexToInt( S[ 0..2 ] ) / 255.0
		G = 1.0 * HexToInt( S[ 2..4 ] ) / 255.0
		B = 1.0 * HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
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