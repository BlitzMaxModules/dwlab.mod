SuperStrict

Framework brl.basic

Import brl.pngloader
Import brl.oggloader
Import dwlab.frmwork
Import dwlab.sound

Include "TGame.bmx"
Include "TVisualizer.bmx"
Include "TPopUpBall.bmx"
Include "TCursor.bmx"
Include "TSelected.bmx"
Include "LTTileMapPathFinder.bmx"
Include "TMoveAlongPath.bmx"
Include "TCheckLines.bmx"
Include "TMoveBall.bmx"
Include "TExplosion.bmx"
Include "HUD.bmx"
Include "TIntro.bmx"
Include "LTRasterFrameVisualizer.bmx"
Include "TLevel.bmx"

Incbin "font.png"
Incbin "font.lfn"
Incbin "stop.ogg"
Incbin "rush.ogg"
Incbin "explosion.ogg"
Incbin "select.ogg"
Incbin "swap.ogg"
Include "levels_incbin.bmx"

Global Game:TGame = New TGame
Game.Execute()