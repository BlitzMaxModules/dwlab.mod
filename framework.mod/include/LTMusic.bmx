'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMusic Extends LTObject
	Field BMaxChannel:TChannel
	Field MainPart:LTSound
	
	
	
	Method New()
		BMaxChannel = New TChannel
	End Method
	
	
	
	Method Create:LTMusic()
		Return New LTMusic
	End Method
	
	
	
	Method Play( Music:LTSound, Intro:LTSound = Null, Rate:Float = 1.0 )
		BMaxChannel.Stop()
		MainPart = Music
		If Intro Then PlaySound( Intro.BMaxSound, BMaxChannel )
		Update()
	End Method
	
	
	
	Method Update()
		If MainPart And Not BMaxChannel.Playing() Then
			PlaySound( MainPart.BMaxSound, BMaxChannel )
			MainPart = Null
		End If
	End Method
End Type