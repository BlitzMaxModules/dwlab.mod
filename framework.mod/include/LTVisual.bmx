'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTImageVisual.bmx"
Include "LTFilledPrimitive.bmx"
Include "LTEmptyPrimitive.bmx"

Type LTVisual Extends LTObject Abstract
	Field R:Float = 1.0, G:Float = 1.0, B:Float = 1.0
	Field Alpha:Float = 1.0
	Field XScale:Float = 1.0, YScale:Float = 1.0
	Field Scaling:Int = True
	Field Angle:Float
	Field Rotating:Int = True

	' ==================== Parameters ====================
	
	Method SetVisualScale( NewXScale:Float, NewYScale:Float )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	' ==================== Drawing ===================	
	
	Method DrawUsingActor( Actor:LTActor )
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
	End Method
	
	' ==================== Other ====================
	
	Method SetColorFromHex( S:String )
		R = 1.0 * L_HexToInt( S[ 0..2 ] ) / 255.0
		G = 1.0 * L_HexToInt( S[ 2..4 ] ) / 255.0
		B = 1.0 * L_HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
	Method SetColorFromRGB( NewR:Float, NewG:Float, NewB:Float )
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
		R = L_LimitFloat( R + Rnd( D1, D2 ), 0.0, 1.0 )
		G = L_LimitFloat( G + Rnd( D1, D2 ), 0.0, 1.0 )
		B = L_LimitFloat( B + Rnd( D1, D2 ), 0.0, 1.0 )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageFloatAttribute( "r", R, 1.0 )
		XMLObject.ManageFloatAttribute( "g", G, 1.0 )
		XMLObject.ManageFloatAttribute( "b", B, 1.0 )
		XMLObject.ManageFloatAttribute( "alpha", Alpha, 1.0 )
		XMLObject.ManageFloatAttribute( "xscale", XScale, 1.0 )
		XMLObject.ManageFloatAttribute( "yscale", YScale, 1.0 )
		XMLObject.ManageIntAttribute( "scaling", Scaling, 1 )
	End Method
End Type