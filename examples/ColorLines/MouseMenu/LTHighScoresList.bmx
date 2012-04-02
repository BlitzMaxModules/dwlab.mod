'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTHighScoresList Extends LTListBox
	Field ContourVisualizer:LTContourVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000", 0.5 ) 

	Method Init()
		Super.Init()
		ItemSize = 0.3
		Items = Menu.HighScores
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		Sprite.Visualizer.Alpha = 0.5
		Select Num
			Case 0
				Sprite.Visualizer.SetColorFromHex( "FFD700" )
			Case 1
				Sprite.Visualizer.SetColorFromHex( "C0C0C0" )
			Case 2
				Sprite.Visualizer.SetColorFromHex( "CD7F32" )
			Default
				Sprite.Visualizer.SetColorFromHex( "7F7FFF" )
				Sprite.Visualizer.Alpha = 0.1 + 0.2 * ( Num Mod 2 )
		End Select
		Sprite.Draw()
		If Num = Menu.NewHighScore Then Sprite.DrawUsingVisualizer( ContourVisualizer )
		
		SetColor( 0, 0, 0 )
		Local HighScore:LTHighScore = LTHighScore( Item )
		Sprite.PrintText( ( Num + 1 ) + ".", LTAlign.ToLeft, , 0.25 )
		Sprite.PrintText( HighScore.Name, LTAlign.ToLeft, , 0.6 )
		Sprite.PrintText( HighScore.Score, LTAlign.ToRight, , -0.25 )
		LTVisualizer.ResetColor()
	End Method
End Type



Type LTHighScore Extends LTObject
	Field Score:Int
	Field Name:String
	Field Achievements:TList
	
	Function Create:LTHighScore( Name:String, Score:Int, Achievements:TList = Null )
		Local HighScore:LTHighScore = New LTHighScore
		HighScore.Name = Name
		HighScore.Score = Score
		HighScore.Achievements = Achievements
		Return HighScore
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageIntAttribute( "score", Score )
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageChildList( Achievements )
	End Method
End Type