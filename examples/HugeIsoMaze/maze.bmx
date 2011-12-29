'
' Huge isometric maze - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
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

Include "TGame.bmx"
Include "TMazeGenerator.bmx"
Include "TZombie.bmx"
Include "CollisionHandlers.bmx"
Include "PleaseWait.bmx"

Global Game:TGame = New TGame
Game.Execute()