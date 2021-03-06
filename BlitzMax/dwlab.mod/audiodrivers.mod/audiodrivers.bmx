'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Rem
bbdoc: Default audio drivers set.
about: Allows to load and play OGGs.
End Rem
Module dwlab.AudioDrivers

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

Import dwlab.frmwork

?win32
Import brl.directsoundaudio
?Not win32
Import brl.freeaudioaudio
?
Import brl.oggloader



Incbin "error1.ogg"
Incbin "error2.ogg"
Incbin "error3.ogg"

Type TErrorSoundPlayer Extends TSoundPlayer
	Method PlayErrorSound()
		LoadSound( "incbin::error" + Rand( 1, 3 ) + ".ogg" ).Play()
	End Method
End Type
L_ErrorSoundPlayer = New TErrorSoundPlayer