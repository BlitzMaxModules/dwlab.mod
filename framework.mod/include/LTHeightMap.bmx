'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTHeightMap Extends LTObject
	Field Value:Float[ , ] = New Float[ 1, 1 ]

	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		?debug
		L_Assert( NewXQuantity > 0, "HeightMap resoluton must be more than 0" )
		L_Assert( NewYQuantity > 0, "HeightMap resoluton must be more than 0" )
		?
		
		Value = New Float[ NewXQuantity, NewYQuantity ]
	End Method
	
	
	
	Method GetXQuantity:Int()
		Return Value.Dimensions()[ 0 ]
	End Method
	
	
	
	Method GetYQuantity:Int()
		Return Value.Dimensions()[ 1 ]
	End Method
	
	
	
	Method GetXMask:Int()
		If L_IsPowerOf2( GetXQuantity() ) Then Return GetXQuantity() - 1
	End Method
	
	
	
	Method GetYMask:Int()
		If L_IsPowerOf2( GetYQuantity() ) Then Return GetYQuantity() - 1
	End Method
	
	' ==================== Manipulations ====================	
	
	Method ToNewImage:LTImage()
		Local Image:LTImage = New LTImage
		Image.BMaxImage = CreateImage( GetXQuantity(), GetYQuantity() )
		
		ToPixmap( LockImage( Image.BMaxImage ) )
		
		UnlockImage( Image.BMaxImage )
		Return Image
	End Method
	
	
	
	Method ToImage( Image:LTImage, Frame:Int = 0 )
		?debug
		L_Assert( GetXQuantity() = ImageWidth( Image.BMaxImage ) And GetYQuantity() =  ImageHeight( Image.BMaxImage ), "Sizes of source heightmap and resulting image are different." )
		?
		
		ToPixmap( LockImage( Image.BMaxImage, Frame ) )
		UnlockImage( Image.BMaxImage )
	End Method
	
	
	
	Method ToPixmap( Pixmap:TPixmap )
		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				Local Col:Int = Floor( 255.0 * Value[ X, Y ] )
				WritePixel( Pixmap, X, Y, ( Col * $010101 ) | $FF000000 )
			Next
		Next
	End Method
	
	
	
	Method ExtractTo( TileMap:LTTileMap, VFrom:Float, VTo:Float, TileNum:Int )
		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		
		?debug
		L_Assert( TileMap.GetXQuantity() = XQuantity And TileMap.GetYQuantity() = YQuantity, "Sizes of source heightmap and resulting tilemap are different." )
		?
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				If Value[ X, Y ] >= VFrom And Value[ X, Y ] < VTo Then TileMap.Frame[ X, Y ]  = TileNum; 
			Next
		Next
	End Method

		
	
	Method Blur()
		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		Local XMask:Int = GetXMask()
		Local YMask:Int = GetYMask()
		Local Wrapped:Int = XMask And YMask
		
		Local NewArray:Float[ XQuantity, YQuantity ]
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				Local Sum:Float = 0
				For Local XX:Int = -1 To 1
					For Local YY:Int = -1 To 1
						If Wrapped Then
							Sum :+ Value[ ( X + XX ) & XMask, ( Y + YY ) & YMask ]
						Else
							Sum :+ Value[ L_Wrap( X + XX, XQuantity ), L_Wrap( Y + YY, YQuantity ) ]
						End If
					Next
				Next
				NewArray[ X, Y ] = ( Sum + Value[ X, Y ] * 7.0 ) / 16.0
			Next
		Next
		Value = NewArray
	End Method

	
	
	Method PerlinNoise( StartingXFrequency:Int, StartingYFrequency:Float, StartingAmplitude:Float, DAmplitude:Float, LayersQuantity:Int )
		Local XQuantity:Int = GetXQuantity()
		Local YQuantity:Int = GetYQuantity()
		
		Local XFrequency:Int = StartingXFrequency
		Local YFrequency:Int = StartingYFrequency
		Local Amplitude:Float = StartingAmplitude
		
		For Local X:Float = 0.0 Until XQuantity
			For Local Y:Float = 0.0 Until YQuantity
				Value[ X, Y ] = 0.5
			Next
		Next
		
		For Local N:Int = 1 To LayersQuantity
			Local Array:Float[ , ] = New Float[ XFrequency, YFrequency ]
			
			For Local AX:Int = 0 Until XFrequency
				For Local AY:Int = 0 Until YFrequency
					Array[ AX, AY ] = Rnd( -Amplitude, Amplitude )
				Next
			Next
			
			Local XMask:Int = XFrequency - 1
			Local YMask:Int = YFrequency - 1
			
			Local KX:Float = 1.0 * XFrequency / XQuantity
			Local KY:Float = 1.0 * YFrequency / YQuantity
			
			For Local X:Float = 0.0 Until XQuantity
				For Local Y:Float = 0.0 Until YQuantity
					Local XK:Float = X * KX
					Local YK:Float = Y * KY
					Local ArrayX:Int = Floor( XK )
					Local ArrayY:Int = Floor( YK )
					
					XK = ( 1.0 - Cos( 180.0 * ( XK - ArrayX ) ) ) * 0.5
					YK = ( 1.0 - Cos( 180.0 * ( YK - ArrayY ) ) ) * 0.5
					
					'If XK > 1.0 or YK > 1.0 Then DebugStop
					
					Local Z00:Float = Array[ ArrayX, ArrayY ] 
					Local Z10:Float = Array[ ( ArrayX + 1 ) & XMask, ArrayY ] 
					Local Z01:Float = Array[ ArrayX, ( ArrayY + 1 ) & YMask ] 
					Local Z11:Float = Array[ ( ArrayX + 1 ) & XMask, ( ArrayY + 1 ) & YMask ] 
					
					Local Z0:Float = Z00 + ( Z10 - Z00 ) * XK
					Local Z1:Float = Z01 + ( Z11 - Z01 ) * XK
					
					Value[ X, Y ] = Value[ X, Y ] + Z0 + ( Z1 - Z0 ) * YK
				Next
			Next
			
			XFrequency = 2 * XFrequency
			YFrequency = 2 * YFrequency
			Amplitude = Amplitude * DAmplitude
			
			Limit()
		Next
	End Method
	
	
	
	Method Limit()
		For Local X:Int = 0 Until GetXQuantity()
			For Local Y:Int = 0 Until GetYQuantity()
				If Value[ X, Y ] < 0.0 Then Value[ X, Y ] = 0.0
				If Value[ X, Y ] > 1.0 Then Value[ X, Y ] = 1.0
			Next
		Next
	End Method
End Type