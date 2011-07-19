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

Global Game:TGame = New TGame

Type TGame Extends LTProject
	Field Player:LTAngularSprite = New LTAngularSprite
	Field PlayerVisualizer:LTVisualizer = LTVisualizer.FromFile( "media/footman.png", 5, 13 )
	Field Cursor:LTSprite = New LTSprite
	Field PivotVisualizer:LTVisualizer = New LTVisualizer
	Field LineVisualizer:LTEmptyPrimitive = New LTEmptyPrimitive
	Field CurrentPivot:LTSprite
	Field CurrentPivotVisualizer:LTVisualizer = New LTVisualizer
	Field Map:TGameMap = New TGameMap
	Field Background:LTSprite = New LTSprite
	Field Path:LTPath = New LTPath
	Field Font:LTBitmapFont = LTBitmapFont.FromFile( "media/font.png", , , , True )
	
	
	
	Method Init()
		L_InitGraphics( , , 25.0 )
		Map = TGameMap( LoadFromFile( "map.gra" ) )
		
		Player.Velocity = 2.0
		Player.SetSize( 72.0 / 25.0, 72.0 / 25.0 )
		Player.ShapeType = LTSprite.Rectangle
		
		PlayerVisualizer.DY = -0.2
		PlayerVisualizer.Rotating = False
		Player.Visualizer = PlayerVisualizer
		
		Cursor.ShapeType = LTSprite.Circle
		Cursor.SetDiameter( 0.2 )
		
		PivotVisualizer.SetVisualizerScale( 0.25, 0.25 )
		PivotVisualizer.SetColorFromHex( "FF7F00" )
		
		LineVisualizer.Scaling = False
		LineVisualizer.SetColorFromHex( "FF7F00" )
		
		Background.Width = 32
		Background.Height = 24
		Background.Visualizer = LTVisualizer.FromFile( "media/world-map.jpg" )
		
		CurrentPivotVisualizer.SetVisualizerScale( 0.35, 0.35 )
		CurrentPivotVisualizer.SetColorFromHex( "FFBF7F" )
	End Method
	
	
	
	Method Logic()
		Cursor.SetMouseCoords()
		CurrentPivot = Map.FindPivotCollidingWith( Cursor )
		
		If KeyHit( Key_Space ) And CurrentPivot Then
			If Map.PlayerPivot Then
				Path = LTPath.Find( Map.PlayerPivot, CurrentPivot, Map )
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
			If Player.IsAtPositionOf( Map.PlayerPivot ) And Not Path.Pivots.IsEmpty() Then
				Map.PlayerPivot = LTSprite( Path.Pivots.First() )
				Player.DirectTo( Map.PlayerPivot )
				Path.Pivots.RemoveFirst()
			Else
				Player.MoveTowards( Map.PlayerPivot )
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