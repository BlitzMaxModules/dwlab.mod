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
bbdoc: Support for Box2D physics
End Rem
Module dwlab.physics2d

ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"

ModuleInfo "History: v1.0 (16.07.12)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."

Import dwlab.frmwork
Import bah.box2d

Include "include\LTBox2DPhysics.bmx"
Include "include\LTBox2DSprite.bmx"
Include "include\LTBox2DTileMap.bmx"
Include "include\LTBox2DSpriteGroup.bmx"