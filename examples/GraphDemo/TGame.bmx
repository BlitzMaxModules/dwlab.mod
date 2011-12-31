'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

AppTitle = "Graph demo"

Incbin "media\font.png"
Incbin "media/font.lfn"
Incbin "media\footman.png"
Incbin "media\world-map.jpg"

L_SetIncbin( True )
Global Game:TGame = New TGame

Type TGame Extends LTProject
	Field Player:LTAngularSprite = New LTAngularSprite
	Field PlayerVisualizer:LTVisualizer = LTVisualizer.FromFile( "media\footman.png", 5, 13 )
	Field Cursor:LTSprite = New LTSprite
	Field PivotVisualizer:LTVisualizer = LTVisualizer.FromHexColor( "FF007F" )
	Field LineVisualizer:LTContourVisualizer = LTContourVisualizer.FromWidthAndHexColor( 0.1, "FF7F00" )
	Field CurrentPivot:LTSprite
	Field CurrentPivotVisualizer:LTVisualizer = LTVisualizer.FromHexColor( "FFBF7F" )
	Field Map:TGameMap = New TGameMap
	Field Background:LTSprite = New LTSprite
	Field Path:TList = New TList
	Field Font:LTBitmapFont = LTBitmapFont.FromFile( "media\font.png", , , , True )
	
	
	
	Method Init()
		L_InitGraphics()
		Map = TGameMap( LoadFromFile( "map.gra", False ) )
		
		Player.Velocity = 2.0
		Player.SetSize( 72.0 / 25.0, 72.0 / 25.0 )
		Player.ShapeType = LTSprite.Rectangle
		
		PlayerVisualizer.DY = -0.2
		PlayerVisualizer.Rotating = False
		Player.Visualizer = PlayerVisualizer
		
		PivotVisualizer.SetVisualizerScales( 1.5 )
		
		Cursor.ShapeType = LTSprite.Circle
		Cursor.SetDiameter( 0.2 )
		
		Background.Width = 32
		Background.Height = 24
		Background.Visualizer = LTVisualizer.FromFile( "media\world-map.jpg" )
		
		CurrentPivotVisualizer.SetVisualizerScale( 2, 2 )
	End Method
	
	
	
	Method Logic()
		Cursor.SetMouseCoords()
		CurrentPivot = Map.FindPivotCollidingWithSprite( Cursor )
		
		If KeyHit( Key_Space ) And CurrentPivot Then
			If Map.PlayerPivot Then
				Path = Map.FindPath( Map.PlayerPivot, CurrentPivot )
			Else
				Player.JumpTo( CurrentPivot )
				Map.PlayerPivot = CurrentPivot
			End If
		End If
		'Player.Turn( 45 )
		Local AngleFrame:Int = Floor( 0.5 + ( Player.Angle - Floor( Player.Angle / 360 ) * 360 ) / 45 )
		Player.Frame = Int( Mid$( "234321012", AngleFrame + 1, 1 ) )
		
		If AngleFrame >=3 And AngleFrame <= 5 Then
			Player.SetFacing( LTSprite.LeftFacing )
		Else
			Player.SetFacing( LTSprite.RightFacing )
		End If
		
		If Map.PlayerPivot Then
			If Player.IsAtPositionOf( Map.PlayerPivot ) And Not Path.IsEmpty() Then
				Map.PlayerPivot = LTSprite( Path.First() )
				Player.DirectTo( Map.PlayerPivot )
				Path.RemoveFirst()
			Else
				Player.MoveTowards( Map.PlayerPivot, Player.Velocity )
			End If
			If Not Player.IsAtPositionOf( Map.PlayerPivot ) Then Player.Frame :+ ( Floor( Time * 5 ) Mod 5 ) * 5
		End If
		
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Background.Draw()
		Map.DrawLinesUsing( LineVisualizer )
		Map.DrawPivotsUsing( PivotVisualizer )
		If CurrentPivot Then CurrentPivot.DrawUsingVisualizer( CurrentPivotVisualizer )
		Player.Draw()
		
		Font.Print( "Press space to move to selected pivot.", -16.0, -12.0, 1.0 )
		Font.Print( "Press Esc to exit.", -16.0, -11.0, 1.0 )
	End Method
End Type