'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Framework brl.basic

Import dwlab.frmwork
Import dwlab.graphicsdrivers
Import dwlab.audiodrivers

Include "LTChannelPack.bmx"
Include "TGame.bmx"
Include "TTiles.bmx"
Include "TPlayer.bmx"
Include "TGameObject.bmx"
Include "world_incbin.bmx"

Global Game:TGame = New TGame
Game.Execute()