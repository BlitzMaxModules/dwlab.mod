'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Function L_HexToInt:Int( HexString:String )
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





Function L_DrawEmptyRect( X1:Float, Y1:Float, X2:Float, Y2:Float )
	DrawLine( X1, Y1, X2, Y1 )
	DrawLine( X1, Y1, X1, Y2 )
	DrawLine( X2, Y1, X2, Y2 )
	DrawLine( X1, Y2, X2, Y2 )
End Function





Function L_DeleteList( List:TList )
	List.Clear()
	List._head._pred = Null
	List._head._succ = Null
End Function




	
Function L_TrimFloat:String ( Val:Float )
	Local StrVal:String = Val:Float
	Local N:Int = StrVal.Find( "." ) + 3
	'If N < 3 then N = Len( StrVal )
	Repeat
		N = N - 1
		Select StrVal[ N ]
			Case 46 Return StrVal[ ..N ]
			Case 48
			Default
				Return StrVal[ ..N% + 1 ]
		End Select
	Forever
End Function





Function L_FirstZeroes:String( Value:Int, TotalSymbols:Int )
	Local StringValue:String = Value
	Local Length:Int = Len( StringValue )
	If Length < TotalSymbols Then
		Return L_Symbols( "0", TotalSymbols - Length ) + StringValue
	Else
		Return StringValue
	End If
End Function





Function L_Symbols:String( Symbol:String, Times:Int )
	Local Symbols:String = ""
	For Local N:Int = 1 To Times
		Symbols :+ Symbol
	Next
	Return Symbols
End Function





Function L_LimitFloat:Float( Value:Float, FromValue:Float, ToValue:Float )
	?debug
	L_Assert( FromValue <= ToValue, "FromValue must be less than ToValue" )
	?
	If Value < FromValue Then
		Return FromValue
	Elseif Value > ToValue
		Return ToValue
	Else
		Return Value
	End If
End Function





Function L_LimitInt:Int( Value:Int, FromValue:Int, ToValue:Int )
	?debug
	L_Assert( FromValue <= ToValue, "FromValue must be less than ToValue" )
	?
	If Value < FromValue Then
		Return FromValue
	Elseif Value > ToValue
		Return ToValue
	Else
		Return Value
	End If
End Function





Function L_IsPowerOf2:Int( Value:Int )
	If Value + ( Value - 1 ) = Value ~ ( Value - 1 ) Then Return True
End Function





Function L_WrapInt:Int( Value:Int, Size:Int )
	Return Value - Size * Floor( 1.0 * Value / Size )
End Function





Function L_WrapInt2:Int( Value:Int, FromValue:Int, ToValue:Int )
	Local Size:Int = ToValue - FromValue
	If Value >= ToValue Then Return Value - Floor( 1.0 * ( Value - FromValue ) / Size ) * Size
	Return Value
End Function





Function L_WrapFloat:Float( Value:Float, Size:Float )
	Return Value - Size * Floor( Value / Size )
End Function





Function L_TryExtensions:String( Filename:String, Extensions:String[] )
	If FileType( Filename ) = 1 Then Return Filename
	
	For Local Extension:String = Eachin Extensions
		Local NewFilename:String = Filename + "." + Extension
		If FileType( NewFilename ) = 1 Then Return NewFilename
	Next
End Function
	
	
	


Function L_ClearPixmap( Pixmap:TPixmap, Red:Float = 0.0, Green:Float = 0.0, Blue:Float = 0.0, Alpha:Float = 1.0 )
	Local Col:Int = Int( 255.0 * Red ) + Int( 255.0 * Green ) Shl 8 + Int( 255.0 * Blue ) Shl 16 + Int( 255.0 * Alpha ) Shl 16
	Pixmap.ClearPixels( Col )
End Function