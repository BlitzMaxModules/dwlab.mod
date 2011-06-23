'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGame Extends LTProject
	Field World:LTWorld
	Field Level:LTLayer
	Field Player:TPlayer
	Field Target:LTSprite
	
	Field Blocks:LTCollisionMap
	Field Bullets:LTCollisionMap
	Field Trees:LTCollisionMap
	Field ActingList:TList = New TList
	
	Field Fire:LTImageVisualizer = LTImageVisualizer.FromFile( "media\fire.png", 5 )
	Field ChaingunBullet:LTImage = LTImage.FromFile( "media\bullet.png", 8, 11 )
	Field Pyramid:LTImage = LTImage.FromFile( "media\pyramid.png", 2 )
	Field Brain:LTImage = LTImage.FromFile( "media\brain2.png" )
	Field Tree:LTImage = LTImage.FromFile( "media\tree.png", 3 )
	
	
	
	Method Init()
		InitGraphics( 960, 720, 48.0 )
		World = LTWorld.FromFile( "world.lw" )
		LoadAndInitLayer( Level, LTLayer( World.FindShape( "LTLayer" ) ) )
		Target = LTSprite( Level.FindShape( "Target" ) )
	End Method
	
	
	
	Method Logic()
		Target.SetMouseCoords()
		Level.Act()
		Local OldActingList:TList = ActingList
		ActingList = New TList
		For Local Sprite:LTSprite = Eachin OldActingList
			Sprite.Act()
		Next
		
		If KeyHit( Key_Escape ) Then End
	End Method
	
	
	
	Method Render()
		Level.Draw()
	End Method
End Type