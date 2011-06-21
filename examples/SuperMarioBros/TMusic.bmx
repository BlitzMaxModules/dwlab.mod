'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TMusic Extends LTVectorSprite
	Field Intro:TSound
	Field Music:TSound
	
	
	
	Method Init()
		Intro = LoadSound( "media\Music" + Name + "intro.ogg" )
		Music  = LoadSound( "media\Music" + Name + ".ogg" )
	End Method
	
	
	
	Method Act()
		If Not Game.MusicChannel.Playing() Then Game.MusicChannel = Music.Play()
	End Method
	
	
	
	Method Start()
		Game.MusicChannel.Stop()
		If Intro Then Game.MusicChannel = Intro.Play()
	End Method
End Type