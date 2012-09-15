'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

SuperStrict

Framework brl.basic

Import brl.freetypefont

Import dwlab.frmwork
Import dwlab.gui
Import dwlab.profiles
Import dwlab.alldrivers

Include "TGame.bmx"
Include "THUD.bmx"
Include "TGameProfile.bmx"
Include "TFieldVisualizer.bmx"
Include "TPathFinder.bmx"
Include "TPopUpBall.bmx"
Include "TTileSelectionHandler.bmx"
Include "TSelected.bmx"
Include "TMoveAlongPath.bmx"
Include "TCheckLines.bmx"
Include "TMoveBall.bmx"
Include "TExplosion.bmx"
Include "TFallIntoPocket.bmx"
Include "TGoal.bmx"
Include "TBall.bmx"
Include "TStats.bmx"
Include "MouseMenu/Menu.bmx"


Rem
Incbin "sound\stop.ogg"
Incbin "sound\rush.ogg"
Incbin "sound\explosion.ogg"
Incbin "sound\select.ogg"
Incbin "sound\swap.ogg"
Incbin "sound\wrong_turn.ogg"
Include "interface_incbin.bmx"
Include "levels_incbin.bmx"
EndRem

Local Time:Int = FileTime( "ColorLines.exe" )
Local TM:Int Ptr = Int Ptr( localtime_( Varptr( Time ) ) )
AppTitle = "World Of Spheres 0.1 of " + L_FirstZeroes( TM[ 3 ], 2 ) + "-" + L_FirstZeroes( TM[ 4 ] + 1, 2 ) + "-" + ..
		( TM[ 5 ] + 1900 ) + " " + L_FirstZeroes( TM[ 2 ], 2 ) + ":" + L_FirstZeroes( TM[ 1 ], 2 )

Global Game:TGame = New TGame
Game.Execute()