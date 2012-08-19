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
bbdoc: DoubleMap is basicaly a heightmap.
about: It is 2d array of Double values which are in 0.0...1.0 interval.
End Rem
Type LTDoubleMap Extends LTMap
	Rem
	bbdoc: Constant for filling red color channel in pixmap.
	about: See also: #PasteToImage, #PasteToPixmap
	End Rem
	Const Red:Int = 0

	Rem
	bbdoc: Constant for filling green color channel in pixmap.
	about: See also: #PasteToImage, #PasteToPixmap
	End Rem
	Const Green:Int = 1

	Rem
	bbdoc: Constant for filling blue color channel in pixmap.
	about: See also: #PasteToImage, #PasteToPixmap
	End Rem
	Const Blue:Int = 2

	Rem
	bbdoc: Constant for filling alpha channel in pixmap (transparency).
	about: See also: #PasteToImage, #PasteToPixmap
	End Rem
	Const Alpha:Int = 3

	Rem
	bbdoc: Constant for filling all color channels in pixmap (resulting color will be from black to white).
	about: See also: #PasteToImage, #PasteToPixmap
	End Rem
	Const RGB:Int = 4
	

	Rem
	bbdoc: Constant for overwriting source heightmap values by destination heightmap values.
	about: See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum, #Paste
	End Rem
	Const Overwrite:Int = 0

	Rem
	bbdoc: Constant for adding source heightmap values to destination heightmap values.
	about: See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum, #Paste, #Limit
	End Rem
	Const Add:Int = 1

	Rem
	bbdoc: Constant for multiplying source heightmap values by destination heightmap values.
	about: See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum, #Paste
	End Rem
	Const Multiply:Int = 2

	Rem
	bbdoc: Constant for selecting maximum value between source heightmap values and destination heightmap values.
	about: See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum, #Paste
	End Rem
	Const Maximum:Int = 3

	Rem
	bbdoc: Constant for selecting minimum value between source heightmap values and destination heightmap values.
	about: See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum, #Paste
	End Rem
	Const Minimum:Int = 4

	Rem
	bbdoc: 2D array of heightmap values.
	End Rem
	Field Value:Double[ , ] = New Double[ 1, 1 ]
	
	' ==================== Creating ===================
	
	Rem
	bbdoc: Creates double map using given resolution.
	returns: Created double map.
	about: See also: #Paste example
	End Rem
	Function Create:LTDoubleMap( XQuantity:Int, YQuantity:Int )
		Local DoubleMap:LTDoubleMap = New LTDoubleMap
		DoubleMap.SetResolution( XQuantity, YQuantity )
		Return DoubleMap
	End Function

	' ==================== Parameters ====================
	
	Method SetResolution( NewXQuantity:Int, NewYQuantity:Int )
		Super.SetResolution( NewXQuantity, NewYQuantity )
		Value = New Double[ NewXQuantity, NewYQuantity ]
	End Method
	
	' ==================== Manipulations ====================	
	
	Rem
	bbdoc: Converts heightmap to new image with single frame.
	returns: New image.
	about: By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	
	See also: #ToNewPixmap, #PasteToImage, #PasteToPixmap, #Paste example
	End Rem
	Method ToNewImage:LTImage( Channel:Int = RGB )
		Local Image:LTImage = New LTImage
		Image.BMaxImage = CreateImage( XQuantity, YQuantity )
		MidHandleImage( Image.BMaxImage )
		
		Local Pixmap:TPixmap = LockImage( Image.BMaxImage )
		Pixmap.ClearPixels( $FF000000 )
		PasteToPixmap( Pixmap, 0, 0, Channel )
		
		UnlockImage( Image.BMaxImage )
		Return Image
	End Method
	
	
	
	Rem
	bbdoc: Converts heightmap to new pixmap.
	returns: New pixmap.
	about: By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	
	See also: #ToNewImage, #PasteToImage, #PasteToPixmap, #PerlinNoise example
	End Rem
	Method ToNewPixmap:TPixmap( Channel:Int = RGB )
		Local Pixmap:TPixmap = CreatePixmap( XQuantity, YQuantity, PF_RGBA8888 )
		Pixmap.ClearPixels( $FF000000 )
		PasteToPixmap( Pixmap, 0, 0, Channel )
		Return Pixmap
	End Method
	
	
	
	Rem
	bbdoc: Pastes heightmap to existing image frame with given shift.
	about: By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	
	See also: #ToNewImage, #ToNewPixmap, #PasteToPixmap, #Paste example
	End Rem
	Method PasteToImage( Image:LTImage, XShift:Int = 0, YShift:Int = 0, Frame:Int = 0, Channel:Int = RGB )
		PasteToPixmap( LockImage( Image.BMaxImage, Frame ), XShift, YShift, Channel )
		UnlockImage( Image.BMaxImage )
	End Method
	
	
	
	Rem
	bbdoc: Pastes heightmap to existing pixmap with given shift.
	about: By default every color channel will be filled by heightmap values, but you can specify another channel filling mode.
	
	See also: #ToNewImage, #ToNewPixmap, #PasteToImage
	End Rem
	Method PasteToPixmap( Pixmap:TPixmap, XShift:Int = 0, YShift:Int = 0, Channel:Int = RGB )
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
					Case RGB
						WritePixel( Pixmap, XX, YY, ( Col * $010101 ) | ( Pixel & $FF000000 )  )
					Case Alpha
						WritePixel( Pixmap, XX, YY, ( Col Shl 24 ) | ( Pixel & $00FFFFFF )  )
					Case Blue
						WritePixel( Pixmap, XX, YY, Col | ( Pixel & $FFFFFF00 )  )
					Case Green
						WritePixel( Pixmap, XX, YY, ( Col Shl 8 ) | ( Pixel & $FFFF00FF )  )
					Case Red
						WritePixel( Pixmap, XX, YY, ( Col Shl 16 ) | ( Pixel & $FF00FFFF )  )
				End Select
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Pastes one heightmap over another.
	about: You can change coordinate shift and pasting mode.
	All parts of source heightmap which will be outside destination pixmap will be wrapped around destination pixmap.
	
	See also: #Overwrite, #Add, #Multiply, #Maximum, #Minimum
	End Rem
	Method Paste( SourceMap:LTDoubleMap, X:Int = 0, Y:Int = 0, Mode:Int = Overwrite )
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
					Case Overwrite
						Value[ XX, YY ] = SourceMap.Value[ X0, Y0 ]
					Case Add
						Value[ XX, YY ] = Value[ XX, YY ] + SourceMap.Value[ X0, Y0 ]
					Case Multiply
						Value[ XX, YY ] = Value[ XX, YY ] * SourceMap.Value[ X0, Y0 ]
					Case Maximum
						Value[ XX, YY ] = Max( Value[ XX, YY ], SourceMap.Value[ X0, Y0 ] )
					Case Minimum
						Value[ XX, YY ] = Min( Value[ XX, YY ], SourceMap.Value[ X0, Y0 ] )
				End Select
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Extracts slice of heightmap to the tilemap.
	about: Areas of Tilemap with corresponding heightmap values between VFrom and VTo will be filled with TileNum tile index.
	Tilemap and heightmap must have same resolution.
	
	about: See also: #Enframe example
	End Rem
	Method ExtractTo( TileMap:LTIntMap, VFrom:Double, VTo:Double, TileNum:Int )
		?debug
		If TileMap.XQuantity <> XQuantity Or TileMap.YQuantity <> YQuantity Then L_Error( "Sizes of source heightmap and resulting tilemap are different." )
		?
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				If Value[ X, Y ] >= VFrom And Value[ X, Y ] < VTo Then TileMap.Value[ X, Y ]  = TileNum; 
			Next
		Next
	End Method

		
	
	Rem
	bbdoc: Blurs the heightmap with simple 3x3 filter.
	about: See also: #PerlinNoise, #DrawCircle example
	End Rem
	Method Blur()
		Local NewArray:Double[ XQuantity, YQuantity ]
		
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				Local Sum:Double = 0
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

	
	
	Rem
	bbdoc: Fills heightmap with perlin noise.
	about: See also: #Blur, #Enframe example
	End Rem
	Method PerlinNoise( StartingXFrequency:Int, StartingYFrequency:Double, StartingAmplitude:Double, DAmplitude:Double, LayersQuantity:Int )
		Local XFrequency:Int = StartingXFrequency
		Local YFrequency:Int = StartingYFrequency
		Local Amplitude:Double = StartingAmplitude
		
		For Local X:Double = 0.0 Until XQuantity
			For Local Y:Double = 0.0 Until YQuantity
				Value[ X, Y ] = 0.5
			Next
		Next
		
		For Local N:Int = 1 To LayersQuantity
			Local Array:Double[ , ] = New Double[ XFrequency, YFrequency ]
			
			For Local AX:Int = 0 Until XFrequency
				For Local AY:Int = 0 Until YFrequency
					Array[ AX, AY ] = Rnd( -Amplitude, Amplitude )
				Next
			Next
			
			Local FXMask:Int = XFrequency - 1
			Local FYMask:Int = YFrequency - 1
			
			Local KX:Double = 1.0 * XFrequency / XQuantity
			Local KY:Double = 1.0 * YFrequency / YQuantity
			
			For Local X:Double = 0.0 Until XQuantity
				For Local Y:Double = 0.0 Until YQuantity
					Local XK:Double = X * KX
					Local YK:Double = Y * KY
					Local ArrayX:Int = Floor( XK )
					Local ArrayY:Int = Floor( YK )
					
					XK = ( 1.0 - Cos( 180.0 * ( XK - ArrayX ) ) ) * 0.5
					YK = ( 1.0 - Cos( 180.0 * ( YK - ArrayY ) ) ) * 0.5
					
					Local Z00:Double = Array[ ArrayX, ArrayY ] 
					Local Z10:Double = Array[ ( ArrayX + 1 ) & FXMask, ArrayY ] 
					Local Z01:Double = Array[ ArrayX, ( ArrayY + 1 ) & FYMask ] 
					Local Z11:Double = Array[ ( ArrayX + 1 ) & FXMask, ( ArrayY + 1 ) & FYMask ] 
					
					Local Z0:Double = Z00 + ( Z10 - Z00 ) * XK
					Local Z1:Double = Z01 + ( Z11 - Z01 ) * XK
					
					Value[ X, Y ] = Value[ X, Y ] + Z0 + ( Z1 - Z0 ) * YK
				Next
			Next
			
			XFrequency = 2 * XFrequency
			YFrequency = 2 * YFrequency
			Amplitude = Amplitude * DAmplitude
		Next
		
		Limit()
	End Method
	
	
	
	Const CircleBound:Double = 0.707107
	
	Rem
	bbdoc: Draws anti-aliased circle on the heightmap.
	about: Parts of circle which will be ouside the heightmap, will be wrapped around.
	
	See also: #Paste example
	End Rem
	Method DrawCircle( XCenter:Double, YCenter:Double, Radius:Double, Color:Double = 1.0 )
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
				
				Local Dist:Double = Radius - Sqr( ( X - XCenter ) * ( X - XCenter ) + ( Y - YCenter ) * ( Y - YCenter ) )
				
				If Dist > CircleBound Then
					Value[ XX, YY ] = Color
				ElseIf Dist < -CircleBound Then
				Else
					Local Dist00:Double = Radius - Sqr( ( X - 0.5 - XCenter ) * ( X - 0.5 - XCenter ) + ( Y - 0.5 - YCenter ) * ( Y - 0.5 - YCenter ) )
					Local Dist01:Double = Radius - Sqr( ( X - 0.5 - XCenter ) * ( X - 0.5 - XCenter ) + ( Y + 0.5 - YCenter ) * ( Y + 0.5 - YCenter ) )
					Local Dist10:Double = Radius - Sqr( ( X + 0.5 - XCenter ) * ( X + 0.5 - XCenter ) + ( Y - 0.5 - YCenter ) * ( Y - 0.5 - YCenter ) )
					Local Dist11:Double = Radius - Sqr( ( X + 0.5 - XCenter ) * ( X + 0.5 - XCenter ) + ( Y + 0.5 - YCenter ) * ( Y + 0.5 - YCenter ) )
					Local K:Double = L_LimitDouble( 0.125 / CircleBound * ( Dist00 + Dist01 + Dist10 + Dist11 ) + 0.5, 0.0, 1.0 )
					Value[ XX, YY ] = Value[ XX, YY ] * ( 1 - K ) + K * Color
				End If
			Next
		Next
	End Method
	
	
	
	Rem
	bbdoc: Limits the heightmap values by standard interval.
	returns:  
	about: This method will force heighmap values to be in 0.0...1.0 interval.
	Use this method after applying unsafe operations on heightmap, for example adding another heightmap to it.
	
	See also: #Paste example
	End Rem
	Method Limit()
		For Local X:Int = 0 Until XQuantity
			For Local Y:Int = 0 Until YQuantity
				If Value[ X, Y ] < 0.0 Then Value[ X, Y ] = 0.0
				If Value[ X, Y ] > 1.0 Then Value[ X, Y ] = 1.0
			Next
		Next
	End Method
End Type