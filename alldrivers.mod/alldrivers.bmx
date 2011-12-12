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
bbdoc: Set of all available graphics and audio drivers.
about: Allows to load PNGs, JPGs and OGGs.
End Rem
Module dwlab.alldrivers

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

Import dwlab.audiodrivers
Import dwlab.graphicsdrivers

Import brl.freeaudioaudio
Import brl.openalaudio
Import brl.glmax2d
