'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPathFinder Extends LTTileMapPathFinder
	Method Passage:Double( X:Int, Y:Int )
		If Game.Balls.Value[ X, Y ] = Game.NoBall And Game.TileIsPassable[ Game.GameField.Value[ X, Y ] ] Then Return True
	End Method
End Type