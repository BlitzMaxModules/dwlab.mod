'
' Heilage: Ogres rivage - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

AppTitle = "Heilage: Ogres rivage v0.2.1"

Global Shared:TSharedGameData = New TSharedGameData

Type TSharedGameData Extends LTProject
	Field Graph:LTGraph = New LTGraph
	Field Player:LTActor = New LTActor
	Field PlayerVisualizer:LTImageVisualizer = New LTImageVisualizer
	Field PlayerPivot:LTActor
	Field Background:LTActor = New LTActor
	Field BackgroundVisualizer:LTImageVisualizer = New LTImageVisualizer
	Field Path:LTPath = New LTPath
	Field Events:TMap = New TMap
	Field Font:LTFont
	
	
	
	Method Init()
		Player.SetVelocity( 2.0 )
		Player.SetSize( 72 / 25, 72 / 25 )
		Player.Shape = L_Rectangle
		
		PlayerVisualizer.Image = LTImage.FromFile( "media/footman.png", 5, 13 )
		PlayerVisualizer.Image.SetHandle( 0.5, 0.7 )
		'PlayerImages.NoScale = 1
		PlayerVisualizer.Rotating = False
		Player.Visualizer = PlayerVisualizer
		
		Background.XSize = 32
		Background.YSize = 24
		BackgroundVisualizer.Image = LTImage.FromFile( "media/world-map.jpg" )
		Background.Visualizer = BackgroundVisualizer
		
		Font = LTFont.FromFile( "media/font.png" )
	End Method
	
	
	
	Method Logic()
		If KeyHit( Key_Space ) And Editor.CurrentPivot Then
			If PlayerPivot Then
				Path = LTPath.Find( PlayerPivot, Editor.CurrentPivot, Graph )
			Else
				Player.JumpToActor( Editor.CurrentPivot )
				PlayerPivot = Editor.CurrentPivot
			End If
		End If
		'Player.Turn( 45 )
		Local AngleFrame:Int = Floor( 0.5 + ( Player.GetAngle() - Floor( Player.GetAngle() / 360 ) * 360 ) / 45 )
		Player.Frame = Int( Mid$( "234321012", AngleFrame + 1, 1 ) )
		
		If AngleFrame >=3 And AngleFrame <= 5 Then
			Player.XSize = -Abs( Player.XSize )
		Else
			Player.XSize = Abs( Player.XSize )
		End If
		
		If PlayerPivot Then
			If Player.IsAtPositionOfActor( PlayerPivot ) And Not Path.Pivots.IsEmpty() Then
				PlayerPivot = LTActor( Path.Pivots.First() )
				Player.DirectToActor( PlayerPivot )
				Path.Pivots.RemoveFirst()
			Else
				Player.MoveTowardsActor( PlayerPivot )
			End If
			If Not Player.IsAtPositionOfActor( PlayerPivot ) Then Player.Frame :+ ( Floor( Editor.ProjectTime * 5 ) Mod 5 ) * 5
		End If
	End Method
	
	
	
	Method Render()
		Background.Draw()
		Player.Draw()		
	End Method
End Type





Type TGlobalMapEvent Extends LTActor
	Field Probability:Float
	Field Caption:String
	
	
	
	Method DrawInfo( Pivot:LTActor )
		Shared.Font.Print( Caption + " ( " + L_TrimFloat( Probability * 100.0 ) + "% )", Pivot.X + 5, Pivot.Y, L_AlignToRight, L_AlignToCenter )
	End Method
	
	
	
	Method Execute()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageFloatAttribute( "probability", Probability )
		XMLObject.ManageStringAttribute( "caption", Caption )
	End Method
End Type