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

Type LTFont Extends LTObject
	Field LetterLength:Int[ 224 ]
	Field ImagePointer:TImage
	
	
	
	Method Print( Text:String, X:Float, Y:Float, HorizontalAlignment:Int, VerticalAlignment:Int  )
		Select HorizontalAlignment
			Case L_AlignToCenter
				X :- 0.5 * XSize( Text )
			Case L_AlignToLeft
				X :- XSize( Text )
		End Select
		
		Select HorizontalAlignment
			Case L_AlignToCenter
				Y :- 0.5 * YSize()
			Case L_AlignToLeft
				Y :- YSize()
		End Select
		
		For Local N:Int = 0 Until Len( Text )
			DrawImage( ImagePointer, X, Y, Text[ N ] - 32 )
			X :+ LetterLength[ Text[ N ] - 32 ]
		Next
	End Method
	

		
	Method XSize:Int( Text:String )
		Local X:Int = 0
		For Local N:Int = 0 Until Len( Text )
			X :+ LetterLength[ Text[ N ] - 32 ]
		Next
		If X Mod 2 Then X :+ 1
		Return X
	End Method


	
	Method YSize:Int()
		Return ImageHeight( ImagePointer )
	End Method


	
	Function FromFile:LTFont( FileName:String )
		Local Font:LTFont = New LTFont
		
		Local Image:TImage = LoadImage( Filename )
		Font.ImagePointer = LoadAnimImage( Image, ImageWidth( Image ) / 16, ImageHeight( Image ) / 14, 0, 224 )
	
		Font.LetterLength = New Int[ 224 ]
		Local File:TStream = ReadFile( StripExt( FileName ) + ".lfn" )
		For Local N:Int = 0 To 223
			If Eof( File ) Then Exit
			Font.LetterLength[ N ] = Mid$( ReadLine( File ), 3 ).ToInt()
		Next
		
		Return Font
	End Function
End Type