'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Const L_AlignToRight:Int = 0, L_AlignToTop:Int = 0
Const L_AlignToCenter:Int = 1
Const L_AlignToLeft:Int = 2, L_AlignToBottom:Int = 0
Const L_Stretch:Int = 3

Type LTFont Extends LTObject
	Field LetterLength:Int[]
	Field FromNum:Int
	Field ToNum:Int
	Field BMaxImage:TImage
	Field XScale:Float = 1.0
	Field YScale:Float = 1.0
	
	
	
	Method SetFontScale( NewXScale:Float, NewYScale:Float )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	
	
	Method Print( Text:String, X:Float, Y:Float, HorizontalAlignment:Int = L_AlignToRight, VerticalAlignment:Int = L_AlignToTop )
		Select HorizontalAlignment
			Case L_AlignToCenter
				X :- 0.5 * Width( Text )
			Case L_AlignToLeft
				X :- Width( Text )
		End Select
		
		Select HorizontalAlignment
			Case L_AlignToCenter
				Y :- 0.5 * Height()
			Case L_AlignToLeft
				Y :- Height()
		End Select
		
		SetScale XScale, YScale
		For Local N:Int = 0 Until Len( Text )
			?debug
			If Text[ N ] < FromNum Or Text[ N ] > ToNum Then L_Error( "String contains letter that is out of font range" )
			?
			
			DrawImage( BMaxImage, X, Y, Text[ N ] - FromNum )
			X :+  XScale * LetterLength[ Text[ N ] - FromNum ]
		Next
		SetScale 1.0, 1.0
	End Method
	

		
	Method Width:Int( Text:String )
		Local X:Int = 0
		For Local N:Int = 0 Until Len( Text )
			?debug
			If Text[ N ] < FromNum Or Text[ N ] > ToNum Then L_Error( "String contains letter that is out of font range" )
			?
		
			X :+ XScale * LetterLength[ Text[ N ] - FromNum ]
		Next
		If X Mod 2 Then X :+ 1
		Return X
	End Method


	
	Method Height:Int()
		Return  YScale * ImageHeight( BMaxImage )
	End Method


	
	Function FromFile:LTFont( FileName:String, FromNum:Int = 32, ToNum:Int = 255, SymbolsPerRow:Int = 16, VariableLength:Int = False )
		Local Font:LTFont = New LTFont
		Font.FromNum = FromNum
		Font.ToNum = ToNum
		
		Local Pixmap:TPixmap = LoadPixmap( Filename )
		Local SymbolsQuantity:Int = Font.ToNum - Font.FromNum + 1
		Local SymbolWidth:Int = PixmapWidth( Pixmap ) / SymbolsPerRow
		'debugstop
		Font.BMaxImage = LoadAnimImage( Pixmap, SymbolWidth, PixmapHeight( Pixmap ) * SymbolsPerRow / SymbolsQuantity, 0, SymbolsQuantity )
		
		Font.LetterLength = New Int[ SymbolsQuantity ]
		If VariableLength Then
			Local File:TStream = ReadFile( StripExt( FileName ) + ".lfn" )
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