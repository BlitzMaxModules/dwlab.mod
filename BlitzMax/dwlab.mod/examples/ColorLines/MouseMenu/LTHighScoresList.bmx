'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTHighScoresList Extends LTMenuListBox
	Global HighScoresList:LTLayer
	
	Field ContourVisualizer:LTContourVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF0000", 0.5 ) 
	Field TopColor1:LTColor = LTColor.FromHex( "FFFFFF" )
	Field TopColor2:LTColor = LTColor.FromHex( "FFFFFF" )
	Field TopColor3:LTColor = LTColor.FromHex( "FFFFFF" )

	Method Init()
		Super.Init()
		If HighScoresList Then Items = HighScoresList.Children
		If ParameterExists( "top_color_1" ) Then TopColor1 = LTColor.FromHex( GetParameter( "top_color_1" ) )
		If ParameterExists( "top_color_2" ) Then TopColor2 = LTColor.FromHex( GetParameter( "top_color_2" ) )
		If ParameterExists( "top_color_3" ) Then TopColor3 = LTColor.FromHex( GetParameter( "top_color_3" ) )
	End Method
	
	Method DrawItem( Item:Object, Num:Int, Sprite:LTSprite )
		Sprite.Visualizer.Alpha = 0.5
		SetItemColor( Num, Sprite, False, False )
		Select Num
			Case 0
				TopColor1.CopyColorTo( Sprite.Visualizer )
			Case 1
				TopColor2.CopyColorTo( Sprite.Visualizer )
			Case 2
				TopColor3.CopyColorTo( Sprite.Visualizer )
		End Select
		Sprite.Draw()
		If Num = Menu.NewHighScore Then Sprite.DrawUsingVisualizer( ContourVisualizer )
		
		SetColor( 0, 0, 0 )
		Local HighScore:LTHighScore = LTHighScore( Item )
		Sprite.PrintText( ( Num + 1 ) + ".", TextSize, LTAlign.ToLeft, , 0.25 )
		Sprite.PrintText( HighScore.Name, TextSize, LTAlign.ToLeft, , 0.6 )
		Sprite.PrintText( HighScore.Score, TextSize, LTAlign.ToRight, , 0.25 )
		LTVisualizer.ResetColor()
	End Method
End Type



Type LTHighScore Extends LTObject
	Field Score:Int
	Field Name:String
	Field Achievements:TList
	
	Function Create:LTHighScore( Name:String, Score:Int, Achievements:TList = Null )
		Local HighScore:LTHighScore = New LTHighScore
		HighScore.Name = LocalizeString( Name )
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