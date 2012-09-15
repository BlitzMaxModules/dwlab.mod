'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Transfers hex string value to Int.
End Rem
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





Rem
bbdoc: Draws empty rectangle.
about: See also: #DrawMARect
End Rem
Function L_DrawEmptyRect( X:Double, Y:Double, Width:Double, Height:Double )
	Width :- 1
	Height :- 1
	DrawLine( X, Y, X + Width, Y )
	DrawLine( X, Y, X, Y + Height )
	DrawLine( X + Width, Y, X + Width, Y + Height )
	DrawLine( X, Y + Height, X + Width, Y + Height )
End Function





Rem
bbdoc: Deletes list.
End Rem
Function L_DeleteList( List:TList )
	List.Clear()
	List._head._pred = Null
	List._head._succ = Null
End Function




	
Rem
bbdoc: Trims trailing zeroes of Double value and cuts all digits after given quantity (off by default) after point.
End Rem
Function L_TrimDouble:String ( Val:Double, DigitsAfterDot:Int = -1 )
	Local StrVal:String, N:Int
	If DigitsAfterDot >=0 Then
		StrVal = String( Val ) + "00000000000000"
		N = StrVal.Find( "." ) + 1 + DigitsAfterDot
	Else
		StrVal = String( Val )
		N = StrVal.Length
	End If 
	
	Repeat
		N :- 1
		Select StrVal[ N ]
			Case Asc( "0" )
			Case Asc( "." )
				Return StrVal[ ..N ]
			Default
				Return StrVal[ ..N + 1 ]
		End Select
	Forever
End Function





Rem
bbdoc: Adds zeroes to Int value to make resulting string length equal to given.
returns: String with zeroes equal to Int value.
End Rem
Function L_FirstZeroes:String( Value:Int, TotalDigits:Int )
	Local StringValue:String = Value
	Local Length:Int = Len( StringValue )
	If Length < TotalDigits Then
		Return L_Symbols( "0", TotalDigits - Length ) + StringValue
	Else
		Return StringValue
	End If
End Function





Rem
bbdoc: Returns string made from given string repeated given number of times.
returns: String consisting of repeated given string.
End Rem
Function L_Symbols:String( Symbol:String, Times:Int )
	Local Symbols:String = ""
	For Local N:Int = 1 To Times
		Symbols :+ Symbol
	Next
	Return Symbols
End Function





Rem
bbdoc: Limits Double value with inerval defined by two Double values.
returns: Limited Double value.
about:
<ul>
<li> If Value is less than FromValue then function returns FromValue.
<li> If Value is more than ToValue then function returns ToValue.
<li> Otherwise function returns Value.
</ul>

See also: #L_LimitInt
End Rem
Function L_LimitDouble:Double( Value:Double, FromValue:Double, ToValue:Double )
	?debug
	 If FromValue > ToValue Then L_Error( "FromValue must be less than ToValue" )
	?
	If Value < FromValue Then
		Return FromValue
	Elseif Value > ToValue
		Return ToValue
	Else
		Return Value
	End If
End Function





Rem
bbdoc: Limits Int value with inerval defined by two Int values.
returns: Limited Int value.
about:
<ul>
<li> If Value is less than FromValue then function returns FromValue.
<li> If Value is more than ToValue then function returns ToValue.
<li> Otherwise function returns Value.
</ul>

See also: #L_LimitDouble, #L_IntInLimits
End Rem
Function L_LimitInt:Int( Value:Int, FromValue:Int, ToValue:Int )
	?debug
	If FromValue > ToValue Then L_Error( "FromValue must be less than ToValue" )
	?
	If Value < FromValue Then
		Return FromValue
	Elseif Value > ToValue
		Return ToValue
	Else
		Return Value
	End If
End Function





Rem
bbdoc: Checks if given value is the power of 2.
returns: True is given value is power of 2 otherwise False.
about: See also: #L_ToPowerOf2
End Rem
Function L_IsPowerOf2:Int( Value:Int )
	If Value + ( Value - 1 ) = Value ~ ( Value - 1 ) Then Return True
End Function





Rem
bbdoc: Wraps Int value using given size.
returns: Wrapped Int value.
about: Function returns Value which will be kept in 0...Size - 1 interval.

See also: #L_WrapInt2, #L_WrapDouble
End Rem
Function L_WrapInt:Int( Value:Int, Size:Int )
	Return Value - Size * Floor( 1.0 * Value / Size )
End Function





Rem
bbdoc: Wraps Int value using given interval defined by two given Int values.
returns: Wrapped Int value.
about: Function returns Value which will be kept in FromValue...ToValue - 1 interval.

See also: #L_WrapInt, #L_WrapDouble
End Rem
Function L_WrapInt2:Int( Value:Int, FromValue:Int, ToValue:Int )
	Local Size:Int = ToValue - FromValue
	Return Value - Floor( 1.0 * ( Value - FromValue ) / Size ) * Size
End Function





Rem
bbdoc: Wraps Double value using given size.
returns: Wrapped Double value.
about: Function returns Value which will be kept in 0...Size interval excluding Size.

See also: #L_WrapInt
End Rem
Function L_WrapDouble:Double( Value:Double, Size:Double )
	Return Value - Size * Floor( Value / Size )
End Function





Rem
bbdoc: Searches for the file with given filename and one of extensions.
returns: Filename of found file or empty string if file is not found.
about: Filename without extension will be also checked.
End Rem
Function L_TryExtensions:String( Filename:String, Extensions:String[] )
	If FileType( Filename ) = 1 Then Return Filename
	
	For Local Extension:String = Eachin Extensions
		Local NewFilename:String = Filename + "." + Extension
		If FileType( NewFilename ) = 1 Then Return NewFilename
	Next
End Function
	
	
	


Rem
bbdoc: Clears pixmap with given color and alpha values.
End Rem
Function L_ClearPixmap( Pixmap:TPixmap, Red:Double = 0.0, Green:Double = 0.0, Blue:Double = 0.0, Alpha:Double = 1.0 )
	Local Col:Int = Int( 255.0 * Red ) + Int( 255.0 * Green ) Shl 8 + Int( 255.0 * Blue ) Shl 16 + Int( 255.0 * Alpha ) Shl 16
	Pixmap.ClearPixels( Col )
End Function





Rem
bbdoc: Rounds double value to nearest integer.
returns: Rounded value.
about: Faster than Int().
End Rem
Function L_Round:Int( Value:Double )
	Return Int( Value + 0.5:Double * Sgn( Value ) )
End Function




Function L_Distance:Double( DX:Double, DY:Double )
	Return Sqr( DX * DX + DY * DY )
End Function




Function L_Distance2:Double( DX:Double, DY:Double )
	Return DX * DX + DY * DY
End Function





Function L_Cathetus:Double( AB:Double, BC:Double )
	Return Sqr( AB * AB - BC * BC )
End Function





Rem
bbdoc: Converts full path to path relative to current directory.
End Rem
Function L_ChopFilename:String( Filename:String )
	Local Dir:String = CurrentDir()
	Local Slash:String = "/"
	?Win32
	Slash = "\"
	Dir = Dir.Replace( "/", "\" )
	Filename = Filename.Replace( "/", "\" )
	?
	Dir :+ Slash
	For Local N:Int = 0 Until Len( Dir )
		If N => Len( Filename ) Then Return Filename
		If Dir[ N ] <> Filename[ N ] Then
			If N = 0 Then Return Filename
			Local SlashPos:Int = N - 1
			Filename = Filename[ N.. ]
			Repeat
				SlashPos = Dir.Find( Slash, SlashPos + 1 )
				If SlashPos = -1 Then Exit
				Filename = ".." + Slash + Filename
			Forever
			Return Filename
		End If
	Next
	Return Filename[ Len( Dir ).. ]
End Function





Rem
bbdoc: Adds Int value to Int array.
See also: #L_RemoveItemFromintArray
End Rem
Function L_AddItemToIntArray( Array:Int[] Var, Item:Int )
	Local Quantity:Int = Array.Dimensions()[ 0 ]
	Local NewArray:Int[] = New Int[ Quantity + 1 ]
	For Local N:Int = 0 Until Quantity
		NewArray[ N ] = Array[ N ]
	Next
	NewArray[ Quantity ] = Item
	Array = NewArray
End Function





Rem
bbdoc: Removes item with given index from Int array.
See also: #L_AddItemToIntArray
End Rem
Function L_RemoveItemFromIntArray( Array:Int[] Var, Index:Int )
	Local Quantity:Int = Array.Dimensions()[ 0 ]
	If Quantity = 1 Then
		Array = Null
	Else
		Local NewArray:Int[] = New Int[ Quantity - 1 ]
		For Local N:Int = 0 Until Quantity
			If N < Index Then
				NewArray[ N ] = Array[ N ]
			ElseIf N > Index Then
				NewArray[ N - 1 ] = Array[ N ]
			End If
		Next
		Array = NewArray
	End If
End Function





Rem
bbdoc: Checks if Int value is in the interval between FromValue and ToValue.
returns: True if Value is in FromValue...ToValue interval.
about: See also: #L_LimitInt
End Rem
Function L_IntInLimits:Int( Value:Int, FromValue:Int, ToValue:Int )
	If Value >= FromValue And Value <= ToValue Then Return True
End Function





Rem
bbdoc: Checks if Double value is in the interval between FromValue and ToValue.
returns: True if Value is in FromValue...ToValue interval.
about: See also: #L_IntInLimits
End Rem
Function L_DoubleInLimits:Double( Value:Double, FromValue:Double, ToValue:Double)
	If Value >= FromValue And Value <= ToValue Then Return True
End Function




Rem
bbdoc: Returns TypeID for given class name.
returns: TypeID for given class name.
about: If class is not found then error will occur.
End Rem
Function L_GetTypeID:TTypeId( TypeName:String )
	If Not TypeName Then Return Null
	Local TypeID:TTypeId = TTypeID.ForName( TypeName )
	
	?debug
	If Not TypeID Then L_Error( "Type name ~q" + TypeName + "~q not found" )
	?
	
	Return TypeID
End Function





Rem
bbdoc: Returns nearest power of 2.
returns: Lowest power of 2 which is more than or equal to Value.
about: See also: #L_IsPowerOf2
End Rem
Global L_Log2:Double = Log( 2 )

Function L_ToPowerOf2:Int( Value:Int )
	Return 2 ^ Ceil( Log( Value ) / L_Log2 )
End Function





Function L_GetEscribedRectangle( LeftMargin:Double, RightMargin:Double, TopMargin:Double, BottomMargin:Double, ..
		MinX:Double Var, MinY:Double Var, MaxX:Double Var, MaxY:Double Var )
	Local X00:Double, Y00:Double, X01:Double, Y01:Double
	Local X10:Double, Y10:Double, X11:Double, Y11:Double
	Local Viewport:LTShape = L_CurrentCamera.Viewport
	L_CurrentCamera.ScreenToField( Viewport.LeftX(), Viewport.TopY(), X00, Y00 )
	L_CurrentCamera.ScreenToField( Viewport.RightX(), Viewport.TopY(), X10, Y10 )
	L_CurrentCamera.ScreenToField( Viewport.LeftX(), Viewport.BottomY(), X01, Y01 )
	L_CurrentCamera.ScreenToField( Viewport.RightX(), Viewport.BottomY(), X11, Y11 )
	MinX = Min( Min( X00 - LeftMargin, X10 + RightMargin ), Min( X01 - LeftMargin, X11 + RightMargin ) )
	MinY = Min( Min( Y00 - TopMargin, Y10 - TopMargin ), Min( Y01 + BottomMargin, Y11 + BottomMargin ) )
	MaxX = Max( Max( X00 - LeftMargin, X10 + RightMargin ), Max( X01 - LeftMargin, X11 + RightMargin ) )
	MaxY = Max( Max( Y00 - TopMargin, Y10 - TopMargin ), Max( Y01 + BottomMargin, Y11 + BottomMargin ) )
End Function





Function L_UTF8ToASCII:String( CharNum:Int )
	Local AdditionalBytes:Int = 0
	Local Mask:Int = 0
	Local Code:String = ""
	If CharNum < $00000080 Then
		Return Chr( CharNum )
	ElseIf CharNum < $00000800 Then
		AdditionalBytes = 1
		Mask = %11000000
	ElseIf CharNum < $00000800 Then
		AdditionalBytes = 2
		Mask = %11100000
	ElseIf CharNum < $00010000 Then
		AdditionalBytes = 3
		Mask = %11110000
	ElseIf CharNum < $00200000 Then
		AdditionalBytes = 4
		Mask = %11111000
	ElseIf CharNum < $04000000 Then
		AdditionalBytes = 5
		Mask = %11111100
	Else 
		AdditionalBytes = 6
		Mask = %11111110
	End If
	For Local N:Int = 1 To AdditionalBytes
		Code = Chr( %10000000 | ( CharNum & %111111 ) ) + Code
		CharNum = CharNum Shr 6
	Next
	Return Chr( Mask | CharNum ) + Code
End Function





Function L_UTF8LineToASCII:String( Line:String )
	Local NewLine:String = ""
	For Local M:Int = 0 Until Line.Length
		NewLine :+ L_UTF8ToASCII( Line[ M ] )
	Next
	Return NewLine
End Function





Function L_ASCIIToUTF8:String( Text:String, Pos:Int Var )
	Local Header:Int = Text[ Pos ]
	If Header < 128 Then Return Chr( Header )
	
	Local Code:Int = 0
	Local HeaderShift:Int = 0
	Header = Header & %01111111
	Local BitMask:Int = %01000000
	Repeat
		If Not( Header & BitMask ) Then Exit
		Header = Header ~ BitMask
		Pos :+ 1
		Code = ( Code Shl 6 ) + Text[ Pos ] & %111111
		BitMask = BitMask Shr 1
		HeaderShift :+ 6
	Forever
	Return Chr( ( Header Shl HeaderShift ) + Code )
End Function





Function L_ASCIILineToUTF8:String( Line:String )
	Local NewLine:String = ""
	Local Pos:Int = 0
	While Pos < Line.Length
		NewLine :+ L_ASCIIToUTF8( Line, Pos )
		Pos :+ 1
	WEnd
	Return NewLine
End Function





Function L_PrintText( Text:String, X:Double, Y:Double, HorizontalAlign:Int = LTAlign.ToCenter, VerticalAlign:Int = LTAlign.ToCenter, Contour:Int = False )
	Local SX:Double, SY:Double
	L_CurrentCamera.FieldToScreen( X, Y, SX, SY )

	Local Width:Double = TextWidth( Text )
	Local Height:Double = TextHeight( Text )
	
	Select HorizontalAlign
		Case LTAlign.ToCenter
			SX :- 0.5 * Width
		Case LTAlign.ToRight
			SX :- Width
	End Select
	
	Select VerticalAlign
		Case LTAlign.ToCenter
			SY :- 0.5 * Height
		Case LTAlign.ToBottom
			SY :- Height
	End Select
	
	If Contour Then
		L_DrawTextWithContour( Text, SX, SY )
	Else
		DrawText( Text, SX, SY )
	End If
End Function





Function L_DrawTextWithContour( Text:String, SX:Int, SY:Int )
	SetColor( 0, 0, 0 )
	For Local DY:Int = -1 To 1
		For Local DX:Int = Abs( DY ) - 1 To 1 - Abs( DY )
			DrawText( Text, SX + DX, SY + DY )
		Next
	Next
	LTVisualizer.ResetColor()
	DrawText( Text, SX, SY )
End Function





Function L_VersionToInt:Int( Version:String, TotalChunks:Int = 4 )
	Local Versions:String[] = Version.Split( "." )
	Local IntVersion:Int = 0
	For Local N:Int = 0 Until TotalChunks
		IntVersion = IntVersion * 100
		If N < Versions.Length Then IntVersion :+ Versions[ N ].ToInt()
	Next
	Return IntVersion
End Function





Global L_Log80:Double = Log( 80 )

Function L_GetChunkLength:Int( Quantity:Int )
	Return Max( 1, Ceil( Log( Quantity ) / L_Log80 ) )
End Function





Function L_Encode:String( Value:Int, ChunkLength:Int )
	Local Chunk:String = ""
	For Local N:Int = 1 To ChunkLength
		Chunk = Chr( 48 + ( Value Mod 80 ) ) + Chunk
		Value = Floor( Value / 80 )
	Next
	Return Chunk
End Function





Function L_Decode:Int( Chunk:String )
	Local Value:Int = 0
	For Local N:Int = 0 Until Chunk.Length
		Value = Value * 80 + Chunk[ N ] - 48
	Next
	Return Value
End Function