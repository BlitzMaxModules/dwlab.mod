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
	Field TileQuantity:Int
	Field TileType:Int[]
	Field TileRules:TList[]
	
	
	
	Function FromFile:LTTileSet( FileName:String )
		If ExtractExt( FileName ) = "" Then FileName :+ ".lts"
		Local File:TStream = ReadFile( FileName )
		Local Tileset:LTTileset = New LTTileset
		Tileset.TileQuantity = ReadLine( File ).ToInt()
		Tileset.TileType = New Int[ Tileset.TileQuantity ]
		Tileset.TileRules = New TList[ Tileset.TileQuantity ]
		
		Local N:Int = 0
		While Not Eof( File ) And N < Tileset.TileQuantity
			Local Line:String = ReadLine( File )
			
			If Line.Contains( ":" ) Then
				Local Parts:String[] = Line.Split( ":" )
				
				Tileset.TileRules[ N ] = New TList
				Tileset.TileType[ N ] = Parts[ 0 ].ToInt()
				For Local Chunk:String = EachIn Parts[ 1 ].Split( ";" )
					If Line.Contains( "," ) Then
						Local ChunkParts:String[] = Chunk.Split( "," )
						Local Rule:LTTileRule = New LTTileRule
						Rule.DX = ChunkParts[ 0 ].ToInt()
						Rule.DY = ChunkParts[ 1 ].ToInt()
						Rule.TileType = ChunkParts[ 2 ].ToInt()
						Tileset.TileRules[ N ].AddLast( Rule )
					End If
				Next
			End If
			N :+ 1
		Wend
	
		Return Tileset
	End Function
End Type



Type LTTileRule Extends LTObject
	Field DX:Int, DY:Int
	Field TileType:Int
End Type