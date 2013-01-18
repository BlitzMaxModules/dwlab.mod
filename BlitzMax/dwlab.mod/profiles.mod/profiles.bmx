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
bbdoc: Digital Wizard's Lab framework profiling module
End Rem
Module dwlab.profiles

ModuleInfo "Version: 1.0.1"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: v1.0.1 (14.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Finished music playing engine."
ModuleInfo "History: &nbsp; &nbsp; Sound functions are merged into LTProfile class."
ModuleInfo "History: v1.0.0.1 (14.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in LTScreenResolution.Get()."
ModuleInfo "History: v1.0 (09.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."

Import dwlab.frmwork
Import dwlab.music
Import maxgui.localization
Import maxgui.drivers
Import brl.audio
Import brl.graphics

Include "include\LTProfile.bmx"
Include "include\LTVideoDriver.bmx"
Include "include\LTScreenResolution.bmx"