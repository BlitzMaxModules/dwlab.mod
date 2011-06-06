'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'


Type LTBitmapFont Extends LTObject
	Const AlignToRight:Int = 0
	Const AlignToTop:Int = 0
	Const AlignToCenter:Int = 1
	Const AlignToLeft:Int = 2
	Const AlignToBottom:Int = 2

	Field LetterLength:Int[]
	Field FromNum:Int
	Field ToNum:Int
	Field BMaxImage:TImage
	
	
	
	Method Print( Text:String, X:Float, Y:Float, FontHeightInUnits:Float, HorizontalAlignment:Int = AlignToRight, VerticalAlignment:Int = AlignToTop )
		Local Scale:Float = L_CurrentCamera.YK * FontHeightInUnits / Height()
	
		Select HorizontalAlignment
			Case AlignToCenter
				X :- 0.5 * Width( Text ) * Scale
			Case AlignToRight
				X :- Width( Text ) * Scale
		End Select
		
		Select VerticalAlignment
			Case AlignToCenter
				Y :- 0.5 * Height() * Scale
			Case AlignToBottom
				Y :- Height() * Scale
		End Select
		
		SetScale Scale, Scale
		For Local N:Int = 0 Until Len( Text )
			?debug
			If Text[ N ] < FromNum Or Text[ N ] > ToNum Then L_Error( "String contains letter that is out of font range" )
			?
			
			DrawImage( BMaxImage, X, Y, Text[ N ] - FromNum )
			X :+ Scale * LetterLength[ Text[ N ] - FromNum ]
		Next
		SetScale 1.0, 1.0
	End Method
	
	
	
	Method PrintInShape( Text:String, Shape:LTShape, FontHeightInUnits:Float, HorizontalAlignment:Int = AlignToRight, VerticalAlignment:Int = AlignToTop )
		Local X:Float, Y:Float
		
		Select HorizontalAlignment
			Case AlignToLeft
				X = Shape.LeftX()
			Case AlignToCenter
				X = Shape.X
			Case AlignToRight
				X = Shape.RightX()
		End Select
		
		Select VerticalAlignment
			Case AlignToTop
				Y = Shape.TopY()
			Case AlignToCenter
				Y = Shape.Y
			Case AlignToRight
				Y = Shape.BottomY()
		End Select
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( X, Y, SX, SY )
		
		Print( Text, SX, SY, FontHeightInUnits, HorizontalAlignment, VerticalAlignment )
	End Method
	

		
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


	
	Function FromFile:LTBitmapFont( FileName:String, FromNum:Int = 32, ToNum:Int = 255, SymbolsPerRow:Int = 16, VariableLength:Int = False )
		Local Font:LTBitmapFont = New LTBitmapFont
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