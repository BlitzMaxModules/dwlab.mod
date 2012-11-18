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
		Local FieldValue:Int = Profile.GameField.Value[ X, Y ]
		If FieldValue > Game.TileIsPassable.Length Then Return False
		If Profile.Balls.Value[ X, Y ] = Profile.NoBall And Game.TileIsPassable[ FieldValue ] Then Return True
	End Method
End Type