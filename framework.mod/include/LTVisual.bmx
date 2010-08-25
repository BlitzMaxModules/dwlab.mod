'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTImage.bmx"
Include "LTFilledPrimitive.bmx"
Include "LTEmptyPrimitive.bmx"

Type LTVisual Extends LTObject Abstract
	Field R:Float = 1.0, G:Float = 1.0, B:Float = 1.0
	Field Alpha:Float = 1.0
	Field VisualScale:Float = 1.0
	Field NoScale:Int
	
	
	
	Method DrawUsingPivot( Pivot:LTPivot )
	End Method
	
	
	
	Method DrawUsingCircle( Circle:LTCircle )
	End Method
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
	End Method
	
	
	
	Method SetColorFromHex( S:String )
		R = 1.0 * L_HexToInt( S[ 0..2 ] ) / 255.0
		G = 1.0 * L_HexToInt( S[ 2..4 ] ) / 255.0
		B = 1.0 * L_HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
	Method SetColor( NewR:Float, NewG:Float, NewB:Float )
		?debug
		L_Assert( NewR >= 0.0 And NewR <= 1.0, "Red component must be between 0.0 and 1.0 inclusive" )
		L_Assert( NewG >= 0.0 And NewG <= 1.0, "Green component must be between 0.0 and 1.0 inclusive" )
		L_Assert( NewB >= 0.0 And NewB <= 1.0, "Blue component must be between 0.0 and 1.0 inclusive" )
		?
		
		R = NewR
		G = NewG
		B = NewB
	End Method
	
	
	
	Method AlterColor( D1:Float, D2:Float )
		R = L_Limit( R + Rnd( D1, D2 ), 0.0, 1.0 )
		G = L_Limit( G + Rnd( D1, D2 ), 0.0, 1.0 )
		B = L_Limit( B + Rnd( D1, D2 ), 0.0, 1.0 )
	End Method
End Type