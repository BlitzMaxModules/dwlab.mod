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
End Type



Type LTTileCategory Extends LTObject
	Field Num:Int
	Field TileRules:TList = New TList
End Type



Type LTTileRule Extends LTObject
	Field TileNums:Int[]
	Field TilePositions:TList = New TList
End Type



Type LTTilePos Extends LTObject
	Field DX:Int, DY:Int
	Field TileNum:Int
End Type