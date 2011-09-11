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
?win32
Framework brl.d3d7max2d
?linux
Framework brl.glmax2d
?macos
Framework brl.glmax2d
?

'Import brl.bmploader ' for importing BMPs
'Import brl.jpgloader ' for importing JPGs
Import brl.pngloader ' for importing PNGs
'Import brl.wavloader ' for importing WAVs
Import brl.oggloader ' for importing OGGs

Import dwlab.frmwork' DWLab framework import
Import dwlab.sound' DWLab framework sound import

Include "TGame.bmx"
Include "TMario.bmx"
Include "TTiles.bmx"
Include "CommonBehaviorModels.bmx"
Include "TTrigger.bmx"
Include "TScore.bmx"
Include "HUD.bmx"
Include "TLives.bmx"
Include "TTime.bmx"
Include "TBlock.bmx"
Include "TStart.bmx"
Include "TExit.bmx"
Include "TBonus.bmx"
Include "TEnemy.bmx"
Include "TPole.bmx"

Global Game:TGame = New TGame
Game.Execute()