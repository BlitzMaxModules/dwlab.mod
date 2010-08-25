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





Function L_Limit:Float( Value:Float, FromValue:Float, ToValue:Float )
	?debug
	L_Assert( FromValue < ToValue, "FromValue must be less tan ToValue" )
	?
	If Value < FromValue Then
		Return FromValue
	Elseif Value > ToValue
		Return ToValue
	Else
		Return Value
	End If
End Function