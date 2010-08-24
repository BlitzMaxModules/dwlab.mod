' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d
Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
'Import brl.audio
'Import brl.freeaudioaudio
Import brl.directsoundaudio
Import brl.wavloader
Import brl.retro
Import brl.map
'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"
Include "Dragging.bmx"

AppTitle = "Heilage: Ogres rivage v0.2"
Init( 1024, 768 )

Type TEditor Extends LTProject
	Field Graph:LTGraph = New LTGraph
	Field Cursor:LTCircle = New LTCircle
	Field LineVisual:LTVisual
	Field PivotVisual:LTVisual
	Field CurrentPivotVisual:LTVisual
	Field CurrentPivot:LTPivot
	Field MovePivot:TMovePivot = New TMovePivot
	Field MakeLine:TMakeLine = New TMakeLine
	Field Player:LTRectangle = New LTRectangle
	Field PlayerVisual:LTImageVisual = New LTImageVisual
	Field PlayerPivot:LTPivot
	Field Background:LTRectangle = New LTRectangle
	Field BackgroundVisual:LTImageVisual = New LTImageVisual
	Field Path:LTPath = New LTPath
	
	
	
	
	Method Init()
		LineVisual = New LTFilledPrimitive
		LineVisual.SetColorFromHex( "FF7FFF" )
		
		PivotVisual = New LTFilledPrimitive
		PivotVisual.VisualScale = 8.0
		PivotVisual.SetColorFromHex( "FF7F00" )
		
		Cursor.Diameter = 0.33
		
		CurrentPivotVisual = New LTFilledPrimitive
		CurrentPivotVisual.VisualScale = 12.0
		CurrentPivotVisual.SetColorFromHex( "FFBF7F" )
		
		Player.Velocity = 2.0
		Player.XSize = 72 / 25
		Player.YSize = 72 / 25
		
		PlayerVisual.Image = LTImage.FromFile( "media/footman.png", 5, 13 )
		PlayerVisual.Image.SetHandle( 0.5, 0.7 )
		'PlayerImages.NoScale = 1
		PlayerVisual.NoRotate = 1
		Player.Visual = PlayerVisual
		
		Background.XSize = 32
		Background.YSize = 24
		BackgroundVisual.Image = LTImage.FromFile( "media/world-map.jpg" )
		Background.Visual = BackgroundVisual
	End Method
	
	
	
	Method Logic()
		If MouseHit( 1 ) And Not CurrentPivot Then
			Local Pivot:LTPivot = New LTPivot
			Pivot.SetMouseCoords()
			Graph.AddPivot( Pivot )
		End If
		
		If KeyHit( Key_F2 ) Then Editor.SaveToFile( "map.gra" )
		If KeyHit( Key_F3 ) Then Editor.LoadFromFile( "map.gra" )
		
		Cursor.SetMouseCoords()
		MovePivot.Execute()
		MakeLine.Execute()
		CurrentPivot = Graph.FindPivotCollidingWith( Cursor )
		
		If KeyHit( Key_Space ) And CurrentPivot Then
			If PlayerPivot Then
				Path = LTPath.Find( PlayerPivot, CurrentPivot, Graph )
			Else
				Player.JumpTo( CurrentPivot )
				PlayerPivot = CurrentPivot
			End If
		End If
		
		If KeyHit( Key_Delete ) And CurrentPivot Then Graph.DeletePivot( CurrentPivot )
		
		'Player.Turn( 45 )
		Local AngleFrame:Int = Floor( 0.5 + ( Player.Angle - Floor( Player.Angle / 360 ) * 360 ) / 45 )
		Player.Frame = Int( Mid$( "234321012", AngleFrame + 1, 1 ) )
		
		If AngleFrame >=3 And AngleFrame <= 5 Then
			Player.XSize = -Abs( Player.XSize )
		Else
			Player.XSize = Abs( Player.XSize )
		End If
		
		If PlayerPivot Then
			If Player.IsAtPositionOf( PlayerPivot ) And Not Path.Pivots.IsEmpty() Then
				PlayerPivot = LTPivot( Path.Pivots.First() )
				Player.DirectTo( PlayerPivot )
				Path.Pivots.RemoveFirst()
			Else
				Player.MoveTowards( PlayerPivot )
			End If
			If Not Player.IsAtPositionOf( PlayerPivot ) Then Player.Frame :+ ( Floor( Editor.ProjectTime * 5 ) Mod 5 ) * 5
		End If
		
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Background.Draw()
		Graph.DrawLinesUsing( LineVisual )
		Graph.DrawPivotsUsing( PivotVisual )
		If CurrentPivot Then CurrentPivot.DrawUsingVisual( CurrentPivotVisual )
		If MakeLine.DraggingState Then MakeLine.Line.DrawUsingVisual( LineVisual )
		Player.Draw()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		Editor.Graph = LTGraph( XMLObject.ManageObjectField( "map", Editor.Graph ) )
		Editor.PlayerPivot = LTPivot( XMLObject.ManageObjectField( "player", Editor.PlayerPivot ) )
	End Method
End Type



Global Editor:TEditor = New TEditor
Editor.Execute()