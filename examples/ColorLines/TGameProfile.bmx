'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global BossKey:LTButtonAction
Global ExitToMenu:LTButtonAction

Type TGameProfile Extends LTProfile
	Const BallsPerTurn:Int = 3
	
	Field GameField:LTTileMap
	Field Balls:LTTileMap
	Field NextBalls:Int[] = New Int[ BallsPerTurn ]
	
	Method Init()
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Z ), "Boss key" ) )
		Keys.AddLast( LTButtonAction.Create( LTKeyboardKey.Create( Key_Escape ), "Exit to menu" ) )
	End Method
	
	Method Reset()
		Score = 0
		Game.LoadLevel( Self )
	End Method

	Method Load()
		Game.GameField = GameField
		Game.Balls = Balls
		Game.Score = Score
		BossKey = LTButtonAction.Find( Keys, "Boss key" )
		ExitToMenu = LTButtonAction.Find( Keys, "Exit to menu" )
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
		XMLObject.ManageIntArrayAttribute( "nextballs", NextBalls )
		If NextBalls[ 0 ] = 0 Then Game.FillNextBalls( Self )
	End Method
End Type