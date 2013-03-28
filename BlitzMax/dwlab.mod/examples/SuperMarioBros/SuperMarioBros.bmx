'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

' Setting framework
Framework brl.basic

Import brl.pngloader ' for loading PNGs
Import brl.oggloader ' for loading OGGs

Import dwlab.frmwork 'DWLab framework import
Import dwlab.loadedmusic 'DWLab framework music and sound support

Import dwlab.graphicsdrivers 'loading graphics drivers
Import dwlab.audiodrivers 'loading audio drivers

Include "TGame.bmx"
Include "TMario.bmx"
Include "TTiles.bmx"
Include "TGoomba.bmx"
Include "TTrigger.bmx"
Include "TScore.bmx"
Include "CommonBehaviorModels.bmx"

Global Game:TGame = New TGame
Game.Execute()

Type TKoopaTroopa Extends LTSprite
End Type

Type TExit Extends LTSprite
End Type

Type TPole Extends LTSprite
End Type

Type TFlag Extends LTSprite
End Type

Type TStart Extends LTSprite
End Type

Type TMusic Extends LTSprite
End Type