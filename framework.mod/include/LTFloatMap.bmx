'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Const L_Red:Int = 0
Const L_Green:Int = 1
Const L_Blue:Int = 2
Const L_Alpha:Int = 3
Const L_RGB:Int = 4

Const L_Overwrite:Int = 0
Const L_Add:Int = 1
Const L_Multiply:Int = 2
Const L_Max:Int = 3
Const L_Min:Int = 4


Type LTFloatMap Extends LTMap
	Field Value:Float[ , ] = New Float[ 1, 1 ]

	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		Super.SetResolution( NewXQuantity, NewYQuantity )
		Value = New Float[ NewXQuantity, NewYQuantity ]
	End Method
	
	' ==================== Manipulations ====================	
	
	Method ToNewImage:LTImage( Channel:Int = L_RGB )
		Local Image:LTImage = New LTImage
		Image.BMaxImage = CreateImage( XQuantity, YQuantity )
		
		ToPixmap( LockImage( Image.BMaxImage ), 0, 0, Channel )
		
		UnlockImage( Image.BMaxImage )
		Return Image
	End Method
	
	
	
	Method ToNewPixmap:TPixmap( Channel:Int = L_RGB )
		Local Pixmap:TPixmap = CreatePixmap( XQuantity, YQuantity, PF_RGBA8888 )
		Pixmap.ClearPixels( $FFFFFFFF )
		ToPixmap( Pixmap, 0, 0, Channel )
		Return Pixmap
	End Method
	
	
	
	Method ToImage( Image:LTImage, XShift:Int = 0, YShift:Int = 0, Frame:Int = 0, Channel:Int = L_RGB )
		ToPixmap( LockImage( Image.BMaxImage, Frame ), XShift, YShift, Channel )
		UnlockImage( Image.BMaxImage )
	End Method
	
	
	
	Method ToPixmap:TPixmap( Pixmap:TPixmap, XShift:Int = 0, YShift:Int = 0, Channel:Int = L_RGB )
		For Local Y:Int = 0 Until YQuantity
			For Local X:Int = 0 Until XQuantity
				Local Col:Int = Int( 255.0 * Value[ X, Y ] + 0.5 )
				
				Local XX:Int, YY:Int
				If Masked Then
					XX = ( X + XShift ) & XMask
					YY = ( Y + YShift ) & YMask
				Else
					XX = WrapX( X + XShift )
					YY = WrapY( Y + YShift )
				End If
				
				Local Pixel:Int = ReadPixel( Pixmap, XX, YY )
				
				Select Channel
					Case L_RGB
						WritePixel( Pixmap, XX, YY, ( Col * $010101 ) | ( Pixel & $FF000000 )  )
					Case L_Alpha
						WritePixel( Pixmap, XX, YY, ( Col Shl 24 ) | ( Pixel & $00FFFFFF )  )
					Case L_Red
						WritePixel( Pixmap, XX, YY, Col | ( Pixel & $FFFFFF00 )  )
					Case L_Green
						WritePixel( Pixmap, XX, YY, ( Col Shl 8 ) | ( Pixel & $FFFF00FF )  )
					Case L_Blue
						WritePixel( Pixmap, XX, YY, ( Col Shl 16 ) | ( Pixel & $FF00FFFF )  )
				End Select
			Next
		Next
	End Method
	
	
	
	Method Paste( SourceMap:LTFloatMap, X:Int, Y:Int, Mode:Int = L_Overwrite )
		For Local Y0:Int = 0 Until SourceMap.YQuantity
			For Local X0:Int = 0 Until SourceMap.XQuantity
				Local XX:Int, YY:Int
				
				If Masked Then
					XX = ( X + X0 ) & XMask
					YY = ( Y + Y0 ) & YMask
				Else
					XX = WrapX( X + XX )
					YY = WrapY( Y + YY )
				End If
				
			Select Mode
					Case L_Overwrite
						Value[ XX, YY ] = SourceMap.Value[ X0, Y0 ]
					Case L_Add
						Value[ XX, YY ] = Value[ XX, YY ] + SourceMap.Value[ X0, Y0 ]
					Case L_Multiply
						Value[ XX, YY ] = Value[ XX, YY ] * SourceMap.Value[ X0, Y0 ]
					Case L_Max
						Value[ XX, YY ] = Max( Value[ XX, YY ], SourceMap.Value[ X0, Y0 ] )
					Case L_Min
						Value[ XX, YY ] = Min( Value[ XX, YY ], SourceMap.Value[ X0, Y0 ] )
				End Select
			Next
		Next
	End Method
	
	
	
	Method ExtractTo( TileMap:LTIntMap, VFrom:Float, VTo:Float, TileNum:Int )
		?debug
		L_Assert( TileMap.XQuantity = XQuantity And TileMap.YQuantity = YQuantity, "Sizes of source heightmap and resulting tilemap are different." )
		?
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				If Value[ X, Y ] >= VFrom And Value[ X, Y ] < VTo Then TileMap.Value[ X, Y ]  = TileNum; 
			Next
		Next
	End Method

		
	
	Method Blur()
		Local NewArray:Float[ XQuantity, YQuantity ]
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				Local Sum:Float = 0
				For Local XX:Int = -1 To 1
					For Local YY:Int = -1 To 1
						If Masked Then
							Sum :+ Value[ ( X + XX ) & XMask, ( Y + YY ) & YMask ]
						Else
							Sum :+ Value[ WrapX( X ), WrapY( Y ) ]
						End If
					Next
				Next
				NewArray[ X, Y ] = ( Sum + Value[ X, Y ] * 7.0 ) / 16.0
			Next
		Next
		Value = NewArray
	End Method

	
	
	Method PerlinNoise( StartingXFrequency:Int, StartingYFrequency:Float, StartingAmplitude:Float, DAmplitude:Float, LayersQuantity:Int )
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
			
			Local FXMask:Int = XFrequency - 1
			Local FYMask:Int = YFrequency - 1
			
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
					
					Local Z00:Float = Array[ ArrayX, ArrayY ] 
					Local Z10:Float = Array[ ( ArrayX + 1 ) & FXMask, ArrayY ] 
					Local Z01:Float = Array[ ArrayX, ( ArrayY + 1 ) & FYMask ] 
					Local Z11:Float = Array[ ( ArrayX + 1 ) & FXMask, ( ArrayY + 1 ) & FYMask ] 
					
					Local Z0:Float = Z00 + ( Z10 - Z00 ) * XK
					Local Z1:Float = Z01 + ( Z11 - Z01 ) * XK
					
					Value[ X, Y ] = Value[ X, Y ] + Z0 + ( Z1 - Z0 ) * YK
				Next
			Next
			
			XFrequency = 2 * XFrequency
			YFrequency = 2 * YFrequency
			Amplitude = Amplitude * DAmplitude
		Next
		
		Limit()
	End Method
	
	
	
	Const CircleBound:Float = 0.707107
	
	Method DrawCircle( XCenter:Float, YCenter:Float, Radius:Float, Color:Float = 1.0 )
		For Local Y:Int = Floor( YCenter - Radius ) To Ceil( YCenter + Radius )
			For Local X:Int = Floor( XCenter - Radius ) To Ceil( XCenter + Radius )
				Local XX:Int, YY:Int
				If Masked Then
					XX = X & XMask
					YY = Y & YMask
				Else
					XX = WrapX( X )
					YY = WrapY( Y )
				End If
				
				Local Dist:Float = Radius - Sqr( ( X - XCenter ) * ( X - XCenter ) + ( Y - YCenter ) * ( Y - YCenter ) )
				
				If Dist > CircleBound Then
					Value[ XX, YY ] = Color
				ElseIf Dist < -CircleBound Then
				Else
					Local Dist00:Float = Radius - Sqr( ( X - 0.5 - XCenter ) * ( X - 0.5 - XCenter ) + ( Y - 0.5 - YCenter ) * ( Y - 0.5 - YCenter ) )
					Local Dist01:Float = Radius - Sqr( ( X - 0.5 - XCenter ) * ( X - 0.5 - XCenter ) + ( Y + 0.5 - YCenter ) * ( Y + 0.5 - YCenter ) )
					Local Dist10:Float = Radius - Sqr( ( X + 0.5 - XCenter ) * ( X + 0.5 - XCenter ) + ( Y - 0.5 - YCenter ) * ( Y - 0.5 - YCenter ) )
					Local Dist11:Float = Radius - Sqr( ( X + 0.5 - XCenter ) * ( X + 0.5 - XCenter ) + ( Y + 0.5 - YCenter ) * ( Y + 0.5 - YCenter ) )
					Local K:Float = L_LimitFloat( 0.125 / CircleBound * ( Dist00 + Dist01 + Dist10 + Dist11 ) + 0.5, 0.0, 1.0 )
					Value[ XX, YY ] = Value[ XX, YY ] * ( 1 - K ) + K * Color
				End If
			Next
		Next
	End Method
	
	
	
	Method Limit()
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				If Value[ X, Y ] < 0.0 Then Value[ X, Y ] = 0.0
				If Value[ X, Y ] > 1.0 Then Value[ X, Y ] = 1.0
			Next
		Next
	End Method
End Type