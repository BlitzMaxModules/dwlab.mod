'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Incbin "media\fire.png"
Incbin "media\bullet.png"
Incbin "media\pyramid.png"
Incbin "media\brain2.png"
Incbin "media\tree.png"
Incbin "media\explosion.png"
Incbin "media\fire.ogg"
Incbin "media\explosion.ogg"
	
Type TGame Extends LTProject
	Const MinMouseZ:Int = -8
	Const MaxMouseZ:Int = 8
	
	Field World:LTWorld
	Field Level:LTLayer
	Field Player:TPlayer
	Field Target:LTSprite
	Field DZ:Int

	Field Blocks:LTSpriteMap
	Field Bullets:LTSpriteMap
	Field Trees:LTSpriteMap
	Field BulletLayer:LTLayer = New LTLayer
	Field ActingMap:TMap = New TMap
	
	Field Fire:LTVisualizer = LTVisualizer.FromFile( "media\fire.png", 5 )
	Field ChaingunBullet:LTImage = LTImage.FromFile( "media\bullet.png", 8, 11 )
	Field Pyramid:LTImage = LTImage.FromFile( "media\pyramid.png", 2 )
	Field Brain:LTImage = LTImage.FromFile( "media\brain2.png" )
	Field Tree:LTImage = LTImage.FromFile( "media\tree.png", 3 )
	Field Explosion:LTVisualizer = LTVisualizer.FromFile( "media\explosion.png", 8, 5 )
	
	Field FireSounds:LTChannelPack = LTChannelPack.Create( 4 )
	Field ExplosionSounds:LTChannelPack = LTChannelPack.Create( 4 )
	
	Field FireSound:TSound = LoadSound( L_Incbin + "media\fire.ogg" )
	Field ExplosionSound:TSound = LoadSound( L_Incbin + "media\explosion.ogg" )
	
	
	
	Method Init()
		L_InitGraphics( 960, 720, 48.0 )
		HideMouse()
		World = LTWorld.FromFile( "world.lw" )
		LoadAndInitLayer( Level, LTLayer( World.FindShapeWithType( "LTLayer" ) ) )
		Target = LTSprite( Level.FindShape( "Target" ) )
		LTLayer( Game.Level.FindShape( "Trees" ) ).AddLast( Game.Trees )
		LTLayer( Game.Level.FindShape( "Blocks" ) ).AddLast( Game.Blocks )
		LTLayer( Game.Level.FindShape( "Bullets" ) ).AddLast( Game.Bullets )
	End Method
	
	
	
	Method Logic()
		Target.SetMouseCoords()
		
		L_CurrentCamera.ShiftCameraToPoint( ( 2.0 * Player.X + Target.X ) / 3.0, ( 2.0 * Player.Y + Target.Y ) / 3.0 )
		
		If MouseZ() + DZ > MaxMouseZ Then DZ = MaxMouseZ - MouseZ()
		If MouseZ() + DZ < MinMouseZ Then DZ = MinMouseZ - MouseZ()
		Local OldK:Double = L_CurrentCamera.Viewport.Width / 16
		L_CurrentCamera.AlterCameraMagnification( MouseZ() + DZ, OldK, 8.0 )
		
	    L_CurrentCamera.LimitWith( Game.Level.Bounds, True )

		Level.Act()
		BulletLayer.Act()
		
		Local OldActingMap:TMap = ActingMap
		ActingMap = New TMap
		For Local Sprite:LTSprite = Eachin OldActingMap.Keys()
			Sprite.Act()
		Next
		
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Level.Draw()
		ShowDebugInfo()
		Local SX:Double, SY:Double
		'L_CurrentCamera.FieldToScreen( ( 2.0 * Player.X + Target.X ) / 3.0, ( 2.0 * Player.Y + Target.Y ) / 3.0, SX, SY )
		'DrawOval( SX - 2, SY - 2, 5, 5 )
		DrawText( "Move mouse to aim, use WSAD to move, use left mouse button to fire", 0, 704 )
	End Method
End Type