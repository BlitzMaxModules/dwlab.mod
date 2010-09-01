'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTExtendedTileMapVisual Extends LTTileMapVisual
	Field RMap:LTFloatMap
	Field GMap:LTFloatMap
	Field BMap:LTFloatMap
	Field AlphaMap:LTFloatMap
	Field RotationMap:LTFloatMap
	
	
	
	Method DrawUsingRectangle( Rectangle:LTRectangle )
		Super.DrawUsingRectangle( Rectangle )
		
		SetRotation( 1.0 )
	End Method
	
	
	
	Method DrawTile( X:Float, Y:Float, TileX:Int, TileY:Int )
			If R Then SetColor( RMap.Value[ TileX, TileY ], GMap.Value[ TileX, TileY ], BMap.Value[ TileX, TileY ] )
			If AlphaMap Then SetAlpha( AlphaMap.Value[ TileX, TileY ] )
			If RotationMap Then SetRotation( RotationMap.Value[ TileX, TileY ] )
			Drawimage( Image.BMaxImage, X, Y, TileMap.Value[ TileX, TileY ] )
	End Method
End Type