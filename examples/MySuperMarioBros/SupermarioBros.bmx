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

Framework brl.d3d7max2d ' for DirectX renderer
'Framework brl.glmax2d ‘ for OpenGL renderer

Import brl.directsoundaudio ' for DirectSound audio
'Import brl.freeaudioaudio ‘ for FreeAudio audio

'Import brl.bmploader ' for importing BMPs
'Import brl.jpgloader ' for importing JPGs
Import brl.pngloader ' for importing PNGs
'Import brl.wavloader ' for importing WAVs
Import brl.oggloader ' for importing OGGs

Import dwlab.frmwork' DWLab framework import

Include "TGame.bmx"
Include "TMario.bmx"
Include "TTiles.bmx"
Include "CommonBehaviorModels.bmx"
Include "TGoomba.bmx"
Include "TTrigger.bmx"
Include "TScore.bmx"
Include "HUD.bmx"
Include "TBlock.bmx"
Include "TCoin.bmx"
Include "TMushroom.bmx"
Include "TBricks.bmx"
Include "TStart.bmx"
Include "TExit.bmx"
Include "TBonus.bmx"
Include "TOneUpMushroom.bmx"
Include "TFireFlower.bmx"

Global Game:TGame = New TGame
Game.Execute()