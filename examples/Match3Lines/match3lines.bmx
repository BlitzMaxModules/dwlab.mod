SuperStrict

Framework brl.basic

Import brl.pngloader
Import dwlab.frmwork

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

Global Game:TGame = New TGame
Game.Execute()