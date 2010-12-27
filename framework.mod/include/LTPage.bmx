Type LTPage Extends LTObject
	Field Name:String
	Field TileMap:LTTileMap
	Field Sprites:LTList = New LTList
	
	
	
	Method Draw()
		If Tilemap Then Tilemap.Draw()
		Sprites.Draw()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "pagename", Name )
		TileMap = LTTileMap( XMLObject.ManageObjectField( "tilemap", TileMap ) )
		Sprites = LTList( XMLObject.ManageObjectField( "sprites", Sprites ) )
	End Method
End Type