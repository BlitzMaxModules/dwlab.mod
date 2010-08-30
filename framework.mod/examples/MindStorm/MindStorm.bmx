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

Include "Weapons.bmx"

Init( 800, 600 )

Global Game:LTGame = New LTGame
Game.Execute()

Type LTGame Extends LTProject
	Field Target:LTPivot = New LTPivot
	Field Player:LTCircle = New LTCircle
	Field Brain:LTImageVisual
	Field Visor:LTImageVisual
	Field LeftWeapon:TWeapon
	Field RightWeapon:TWeapon
	
	Field TileMap:LTIntMap = New LTIntMap
	Field TileSet:LTTileSet = New LTTileSet
	Field HeightMap:LTFloatMap = New LTFloatMap
	Field TileMapVisual:LTTileMap = New LTTileMap
	Field TileMapRectangle:LTRectangle = New LTRectangle
	Field Pri:LTFilledPrimitive = New LTFilledPrimitive

	Field ChaingunCannon:LTImage
	Field ChaingunBarrel:LTImage
	Field ChaingunFire:LTImageVisual
	Field ChaingunBullet:LTImage
	
	Field Bullets:TList = New TList
	
	
	
	Method Init()
		L_CurrentCamera.SetMagnification( L_ScreenXSize / 16, L_ScreenXSize / 16 )
	
		' ============================= Weapons =============================
		
		ChaingunCannon = LTImage.FromFile( "media/chaingun/cannon.png" )
		ChaingunBarrel = LTImage.FromFile( "media/chaingun/barrel##.png" )
		ChaingunFire = LTImageVisual.FromFile( "media/chaingun/fire#.png" )
		ChaingunBullet = LTImage.FromFile( "media/chaingun/bullet##.png" )
		
		' ============================= Player =============================
		
		Player.SetDiameter( 1.0 )
		Player.SetVelocity( 1.5 )
		
		Brain = LTImageVisual.FromFile( "media/brain.png" )
		Brain.SetColorFromHex( "AACCFF" )
		Brain.SetVisualScale( 1.77, 1.77 )
		Brain.AlterColor( -0.2, 0.2 )
		
		Visor = LTImageVisual.FromFile( "media/visor.png" )
		Visor.SetColorFromHex( "CCAAFF" )
		Visor.AlterColor( -0.2, 0.2 )
		Visor.SetVisualScale( 2.0, 2.0 )
		
		Target.Visual = LTImageVisual.FromFile( "media/target.png" )
		Target.Visual.Scaling = False
		
		LeftWeapon = TChaingun.Create( LeftSide )
		RightWeapon = TChaingun.Create( RightSide )
		
		' ============================= Map =============================
		
		TileMap.SetResolution( 128, 128 )
		
		HeightMap.SetResolution( 128, 128 )
		HeightMap.PerlinNoise( 16, 16, 0.25, 0.5, 4 )
		HeightMap.ExtractTo( TileMap, 0.4, 1.0, 1 )
		
		TileMap.Stretch( 2, 2 )
		TileSet = LTTileSet.FromFile( "media/simple.lts" )
		TileMap.EnframeBy( TileSet )
		
		TileMapVisual.Image = LTImage.FromFile( "media/tileset.png", 5, 4 )
		TileMapVisual.TileNum = TileMap
		TileMapRectangle.SetSize( 128.0, 128.0 )
		TileMapRectangle.Visual = TileMapVisual
		
		Pri.Alpha = 0.75
		'Pri.SetColorFromHex( "000000" )
		
		HideMouse()
	End Method
	
	
	
	Method Logic()
		L_CurrentCamera.ShiftCameraToPoint( 0.5 * ( Player.X + Target.X ), 0.5 * ( Player.Y + Target.Y ) )
		Local NewD:Float = L_ScreenXSize / 16 * ( 1.1 ^ MouseZ() )
		L_CurrentCamera.AlterCameraMagnification( NewD, NewD )
		
		Target.SetMouseCoords()
		Player.DirectToPivot( Target )
		Player.MoveUsingWSAD()
		L_CurrentCamera.JumpToPivot( Player )
		L_CurrentCamera.Update()
		LeftWeapon.Logic()
		RightWeapon.Logic()
		
		If KeyHit( key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		TileMapRectangle.Draw()
		'debugstop
		'TileMapRectangle.DrawUsingVisual( Pri )
		For Local Bullet:LTShape = Eachin Bullets
			'debugstop
			Bullet.Draw()
		Next
		
		Player.DrawUsingVisual( Brain )
		LeftWeapon.Render()
		RightWeapon.Render()
		Player.DrawUsingVisual( Visor )
		Target.Draw()
	End Method
End Type