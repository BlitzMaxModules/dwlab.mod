'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

include "LTSprite.bmx"
include "LTSpriteType.bmx"

Type LTWorld Extends LTObject
	Field Tilemap:LTTileMap
	Field SpriteTypes:TList = New TList
	Field Sprites:LTList = New LTList
	
	
	
	Method Draw()
		If Tilemap Then Tilemap.Draw()
		Sprites.Draw()
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Tilemap = LTTileMap( XMLObject.ManageObjectField( "tilemap", Tilemap ) )
		XMLObject.ManageListField( "sprite-types", SpriteTypes )
		Sprites = LTList( XMLObject.ManageObjectField( "sprites", Sprites ) )
	End Method
End Type