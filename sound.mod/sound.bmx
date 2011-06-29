
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
bbdoc: Digital Wizard's Lab Framework sound module
End Rem
Module dwlab.sound

ModuleInfo "History: v1.0 (28.06.11) Initial release"

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

?win32
Import brl.directsoundaudio
?linux
Import brl.freeaudioaudio
?macos
Import brl.freeaudioaudio
?

Include "LTChannelPack.bmx"