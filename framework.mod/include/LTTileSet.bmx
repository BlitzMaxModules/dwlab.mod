'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTileset Extends LTObject
	Field Categories:TList = New TList
	Field TilesQuantity:Int
	Field TileTypes:Int[]
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "tiles-quantity", TilesQuantity )
		XMLObject.ManageChildList( Categories )
	End Method
End Type



Type LTTileCategory Extends LTObject
	Field Num:Int
	Field TileRules:TList = New TList
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "num", Num )
		XMLObject.ManageChildList( TileRules )
	End Method
End Type



Type LTTileRule Extends LTObject
	Field TileNums:Int[]
	Field TilePositions:TList = New TList
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntArrayAttribute( "tilenums", TileNums )
		XMLObject.ManageChildList( TilePositions )
	End Method
End Type



Type LTTilePos Extends LTObject
	Field DX:Int, DY:Int
	Field TileNum:Int
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "dx", DX )
		XMLObject.ManageIntAttribute( "dy", DY )
		XMLObject.ManageIntAttribute( "tilenum", TileNum )
	End Method
End Type