'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTAlign.bmx"

Rem
bbdoc: Bitmap font class.
End Rem
Type LTBitmapFont Extends LTObject
	Field LetterLength:Int[]
	Field FromNum:Int
	Field ToNum:Int
	Field BMaxImage:TImage
	
	
	
	Rem
	bbdoc: Prints text using bitmap font.
	about: You should specify text, coordinates, font height and alignment.
	
	See also: #LTAlign, #PrintInShape
	End Rem
	Method Print( Text:String, X:Double, Y:Double, FontHeightInUnits:Double, HorizontalAlignment:Int = LTAlign.ToLeft, VerticalAlignment:Int = LTAlign.ToTop )
		Local SX:Double, SY:Double
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		Local Scale:Double = L_CurrentCamera.K * FontHeightInUnits / Height()
	
		Select HorizontalAlignment
			Case LTAlign.ToCenter
				SX :- 0.5 * Width( Text ) * Scale
			Case LTAlign.ToRight
				SX :- Width( Text ) * Scale
		End Select
		
		Select VerticalAlignment
			Case LTAlign.ToCenter
				SY :- 0.5 * Height() * Scale
			Case LTAlign.ToBottom
				SY :- Height() * Scale
		End Select
		
		SetScale Scale, Scale
		For Local N:Int = 0 Until Len( Text )
			?debug
			If Text[ N ] < FromNum Or Text[ N ] > ToNum Then L_Error( "String contains letter that is out of font range" )
			?
			
			DrawImage( BMaxImage, SX, SY, Text[ N ] - FromNum )
			SX :+ Scale * LetterLength[ Text[ N ] - FromNum ]
		Next
		SetScale 1.0, 1.0
	End Method
	
	
	
	Rem
	bbdoc: Prints text inside given shape using bitmap font.
	about: You should specify text, shape and alignment.
	
	See also: #LTAlign, #Print
	End Rem
	Method PrintInShape( Text:String, Shape:LTShape, FontHeightInUnits:Double, HorizontalAlignment:Int = LTAlign.ToLeft, VerticalAlignment:Int = LTAlign.ToTop )
		Local X:Double, Y:Double
		
		Select HorizontalAlignment
			Case LTAlign.ToLeft
				X = Shape.LeftX()
			Case LTAlign.ToCenter
				X = Shape.X
			Case LTAlign.ToRight
				X = Shape.RightX()
		End Select
		
		Select VerticalAlignment
			Case LTAlign.ToTop
				Y = Shape.TopY()
			Case LTAlign.ToCenter
				Y = Shape.Y
			Case LTAlign.ToRight
				Y = Shape.BottomY()
		End Select
		
		Print( Text, X, Y, FontHeightInUnits, HorizontalAlignment, VerticalAlignment )
	End Method
	

		
	Rem
	bbdoc: Returns text width in pixels.
	returns: Text width in pixels for current bitmap font.
	End Rem
	Method Width:Int( Text:String )
		Local X:Int = 0
		For Local N:Int = 0 Until Len( Text )
			?debug
			If Text[ N ] < FromNum Or Text[ N ] > ToNum Then L_Error( "String contains letter that is out of font range" )
			?
		
			X :+ LetterLength[ Text[ N ] - FromNum ]
		Next
		If X Mod 2 Then X :+ 1
		Return X
	End Method


	
	Method Height:Int()
		Return ImageHeight( BMaxImage )
	End Method


	
	Rem
	bbdoc: Creates bitmap font from file.
	returns: New bitmap font.
	about: You should specify image with letters file name, interval of symbols which are in the image, letter images per row.
	VariableLength flag should be set to true if you want to use letters with variable lengths and have file with letter lengths with ".lfn"
	extension and same name as image file.
	End Rem
	Function FromFile:LTBitmapFont( FileName:String, FromNum:Int = 32, ToNum:Int = 255, SymbolsPerRow:Int = 16, VariableLength:Int = False )
		Local Font:LTBitmapFont = New LTBitmapFont
		Font.FromNum = FromNum
		Font.ToNum = ToNum
		
		Local Pixmap:TPixmap = LoadPixmap( L_Incbin + Filename )
		Local SymbolsQuantity:Int = Font.ToNum - Font.FromNum + 1
		Local SymbolWidth:Int = PixmapWidth( Pixmap ) / SymbolsPerRow
		'debugstop
		Font.BMaxImage = LoadAnimImage( Pixmap, SymbolWidth, PixmapHeight( Pixmap ) * SymbolsPerRow / SymbolsQuantity, 0, SymbolsQuantity )
		
		Font.LetterLength = New Int[ SymbolsQuantity ]
		If VariableLength Then
			Local File:TStream = ReadFile( L_Incbin + StripExt( FileName ) + ".lfn" )
			For Local N:Int = 0 Until SymbolsQuantity
				?debug
				If Eof( File ) Then L_Error( "Not enough symbol length lines in file for font " + FileName )
				?
				Font.LetterLength[ N ] = ReadLine( File )[ 2.. ].ToInt()
			Next
		Else
			For Local N:Int = 0 Until SymbolsQuantity
				Font.LetterLength[ N ] = SymbolWidth
			Next
		End If
		
		Return Font
	End Function
End Type