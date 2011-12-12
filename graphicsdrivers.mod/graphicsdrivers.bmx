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
bbdoc: Default graphics drivers set.
about: Allows to load and display PNGs and JPGs.
End Rem
Module dwlab.graphicsdrivers

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

?win32
Import brl.d3d9max2d
?Not win32
Import brl.glmax2d
?
Import brl.pngloader
Import brl.jpgloader