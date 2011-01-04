'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d

Import brl.directsoundaudio
'Import brl.freeaudioaudio

Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
Import brl.wavloader
Import brl.retro
Import brl.map

'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

Include "../../framework.bmx"

Include "Weapons.bmx"

Init( 800, 600 )

Global Game:LTGame = New LTGame
Game.Execute()

Const MinMouseZ:Int = -8
Const MaxMouseZ:Int = 8

Type LTGame Extends LTProject
	Field Target:LTActor = New LTActor
	Field Player:LTActor = New LTActor
	Field Brain:LTImageVisualizer
	Field Visor:LTImageVisualizer
	Field LeftWeapon:TWeapon
	Field RightWeapon:TWeapon
	
	Field FrameMap:LTIntMap = New LTIntMap
	Field TileSet:LTTileSet = New LTTileSet
	Field HeightMap:LTFloatMap = New LTFloatMap
	Field TileMap:LTTileMap = New LTTileMap
	Field TileMapVisualizer:LTImageVisualizer

	Field ChaingunCannon:LTImage
	Field ChaingunBarrel:LTImage
	Field ChaingunFire:LTImageVisualizer
	Field ChaingunBullet:LTImage
	
	Field Bullets:TList = New TList
	
	Field Scenery:TList = New TList
	Field TreeLayer:LTCollisionMap = New LTCollisionMap
	
	Field DZ:Int
	
	
	
	Method Init()
		L_CurrentCamera.SetCoords( 64.0, 64.0 )
		L_CurrentCamera.SetMagnification( L_ScreenWidth / 16, L_ScreenWidth / 16 )
		HideMouse()
	
		' ============================= Weapons =============================
		
		ChaingunCannon = LTImage.FromFile( "media/chaingun/cannon.png" )
		ChaingunBarrel = LTImage.FromFile( "media/chaingun/barrel##.png" )
		ChaingunFire = LTImageVisualizer.FromFile( "media/chaingun/fire#.png" )
		ChaingunBullet = LTImage.FromFile( "media/chaingun/bullet##.png" )
		
		' ============================= Player =============================
		
		Player.Shape = L_Circle
		Player.SetDiameter( 1.0 )
		Player.SetVelocity( 1.5 )
		Player.SetCoords( 64.0, 64.0 )
		
		Brain = LTImageVisualizer.FromFile( "media/brain.png" )
		Brain.SetColorFromHex( "AACCFF" )
		Brain.SetVisualizerScale( 1.77, 1.77 )
		Brain.AlterColor( -0.2, 0.2 )
		
		Visor = LTImageVisualizer.FromFile( "media/visor.png" )
		Visor.SetColorFromHex( "CCAAFF" )
		Visor.AlterColor( -0.2, 0.2 )
		Visor.SetVisualizerScale( 2.0, 2.0 )
		
		Target.Visualizer = LTImageVisualizer.FromFile( "media/target.png" )
		Target.Visualizer.Scaling = False
		
		LeftWeapon = TChaingun.Create( LeftSide )
		RightWeapon = TChaingun.Create( RightSide )
		
		' ============================= Map =============================
		
		FrameMap.SetResolution( 128, 128 )
		
		HeightMap.SetResolution( 128, 128 )
		HeightMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
		HeightMap.ExtractTo( FrameMap, 0.4, 1.0, 1 )
		
		FrameMap.Stretch( 2, 2 )
		TileSet = LTTileSet.FromFile( "media/simple.lts" )
		FrameMap.EnframeBy( TileSet )
		
		TileMapVisualizer = LTImageVisualizer.FromFile( "media/tileset.png", 5, 4 )
		TileMap.Visualizer = TileMapVisualizer
		TileMap.FrameMap = FrameMap
		TileMap.SetCoords( 64.0, 64.0 )
		TileMap.SetSize( 128.0, 128.0 )
		
		' ============================= Trees =============================
		
		TreeLayer.SetResolution( 64, 64 )
		
		
	End Method
	
	
	
	Method Logic()
		L_CurrentCamera.ShiftCameraToPoint( ( 2.0 * Player.X + Target.X ) / 3.0, ( 2.0 * Player.Y + Target.Y ) / 3.0 )
		
		If MouseZ() + DZ > MaxMouseZ Then DZ = MaxMouseZ - MouseZ()
		If MouseZ() + DZ < MinMouseZ Then DZ = MinMouseZ - MouseZ()
		Local NewD:Float = L_ScreenWidth / 16 * ( 1.1 ^ ( MouseZ() + DZ ) )
		L_CurrentCamera.AlterCameraMagnification( NewD, NewD )
		
		Target.SetMouseCoords()
		If Player.DistanceToActor( Target ) < 1.0 Then 
			Local Angle:Float = Player.DirectionToActor( Target )
			Target.X = Player.X + 1.0 * Cos( Angle )
			Target.Y = Player.Y + 1.0 * Sin( Angle )
		End If
			
		Player.DirectToActor( Target )
		
		Player.MoveUsingWSAD()
		LeftWeapon.Logic()
		RightWeapon.Logic()
		
		If KeyHit( key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMap.Draw()
		For Local Bullet:LTShape = Eachin Bullets
			Bullet.Draw()
		Next
		
		Player.DrawUsingVisualizer( Brain )
		LeftWeapon.Render()
		RightWeapon.Render()
		Player.DrawUsingVisualizer( Visor )
		Target.Draw()
	End Method
End Type