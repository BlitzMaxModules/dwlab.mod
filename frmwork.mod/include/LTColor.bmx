'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTVisualizer.bmx"

Type LTColor Extends LTObject
	Rem
	bbdoc: Red color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Red:Double = 1.0
	
	Rem
	bbdoc: Green color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Green:Double = 1.0
	
	Rem
	bbdoc: Blue color intensity for drawing.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ResetColor
	End Rem
	Field Blue:Double = 1.0
	
	Rem
	bbdoc: Alpha (transparency) value for drawing.
	about: #ApplyColor, #ResetColor
	End Rem
	Field Alpha:Double = 1.0

	' ==================== Creating ====================
	
	Rem
	bbdoc: Creates new color using given RGB components and transparency.
	returns: New color.
	about: See also: #FromHex
	End Rem
	Function FromRGB:LTColor( Red:Double, Green:Double, Blue:Double, Alpha:Double = 1.0 )
		Local Color:LTColor = New LTColor
		Color.SetColorFromRGB( Red, Green, Blue )
		Color.Alpha = Alpha
		Return Color
	End Function

	

	Rem
	bbdoc: Creates new color using given hexadecimal representation and transparency.
	returns: New color.
	about: See also: #FromRGB
	End Rem
	Function FromHex:LTColor( HexColor:String = "FFFFFF", Alpha:Double = 1.0 )
		Local Color:LTColor = New LTColor
		Color.SetColorFromHex( HexColor )
		Color.Alpha = Alpha
		Return Color
	End Function
	
	' ==================== Setting ====================
	
	Rem
	bbdoc: Applies color given in hex string to visualizer.
	about: See also: #SetColorFromRGB, #AlterColor, #ApplyColor, #ApplyClsColor, #ResetColor
	End Rem
	Method SetColorFromHex( S:String )
		Red = 1.0 * L_HexToInt( S[ 0..2 ] ) / 255.0
		Green = 1.0 * L_HexToInt( S[ 2..4 ] ) / 255.0
		Blue = 1.0 * L_HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
	Rem
	bbdoc: Applies color given in color intensities to visualizer.
	about: Every intensity should be in range from 0.0 to 1.0.
	
	See also: #SetColorFromHex, #AlterColor, #ApplyColor, #ApplyClsColor, #ResetColor
	End Rem
	Method SetColorFromRGB( NewRed:Double, NewGreen:Double, NewBlue:Double )
		?debug
		If NewRed < 0.0 Or NewRed > 1.0 Then L_Error( "Red component must be between 0.0 and 1.0 inclusive" )
		If NewGreen < 0.0 Or NewGreen > 1.0 Then L_Error( "Green component must be between 0.0 and 1.0 inclusive" )
		If NewBlue < 0.0 Or NewBlue > 1.0 Then L_Error( "Blue component must be between 0.0 and 1.0 inclusive" )
		?
		
		Red = NewRed
		Green = NewGreen
		Blue = NewBlue
	End Method
	
	
	
	Rem
	bbdoc: Sets random color.
	about: Each component is in [ 0.25, 1.0 ] range.
	End Rem
	Method SetRandomColor()
		SetColorFromRGB( Rnd( 0.25, 1 ), Rnd( 0.25, 1 ), Rnd( 0.25, 1 ) )
	End Method
	
	
	
	Rem
	bbdoc: Alters color randomly with given increments.
	about: Every color channel will be altered by random value in D1...D2 interval (value(s) can be negative).
	
	See also: #SetColorFromHex, #SetColorFromRGB, #ApplyColor, #ApplyClsColor, #ResetColor
	End Rem
	Method AlterColor( D1:Double, D2:Double )
		Red = L_LimitDouble( Red + Rnd( D1, D2 ), 0.0, 1.0 )
		Green = L_LimitDouble( Green + Rnd( D1, D2 ), 0.0, 1.0 )
		Blue = L_LimitDouble( Blue + Rnd( D1, D2 ), 0.0, 1.0 )
	End Method
	
	
	
	Rem
	bbdoc: Sets this color as drawing color.
	about: See also: #ApplyClsColor, #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ResetColor
	End Rem
	Method ApplyColor()
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		SetAlpha( Alpha )
	End Method
	
	
	
	Rem
	bbdoc: Sets the color of visualizer as screen clearing color.
	about: See also: #ApplyColor, #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ResetColor
	End Rem
	Method ApplyClsColor()
		SetClsColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
	End Method
	
	
	
	Rem
	bbdoc: Resets drawing color to solid white.
	about: See also: #SetColorFromHex, #SetColorFromRGB, #AlterColor, #ApplyColor, #ApplyClsColor
	End Rem
	Function ResetColor()
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Function
	
	' ==================== I/O ====================

	Method CopyColorTo( Color:LTColor )
		Color.Red = Red
		Color.Green = Green
		Color.Blue = Blue
		Color.Alpha = Alpha
	End Method
	
	
		
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "red", Red, 1.0 )
		XMLObject.ManageDoubleAttribute( "green", Green, 1.0 )
		XMLObject.ManageDoubleAttribute( "blue", Blue, 1.0 )
		XMLObject.ManageDoubleAttribute( "alpha", Alpha, 1.0 )
	End Method	
End Type