'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGameProfile Extends LTProfile
	Field GameField:LTTileMap
	Field Balls:LTTileMap
	Field NextBalls:Int[] = New Int[ 3 ]
	
	Method Init()
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Escape ), "Exit to menu" ) )
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Z ), "Boss key" ) )
	End Method
	
	Method Flush()
		Score = 0
		Game.LoadLevel( Self )
	End Method

	Method Load()
		Game.GameField = GameField
		Game.Balls = Balls
		Game.Score = Score
		Game.InitLevel()
	End Method
	
	Method Save()
		GameField = Game.GameField
		Balls = Game.Balls
		Score = Game.Score
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		GameField = LTTileMap( XMLObject.ManageObjectField( "field", GameField ) )
		Balls = LTTileMap( XMLObject.ManageObjectField( "balls", Balls ) )
	End Method
End Type