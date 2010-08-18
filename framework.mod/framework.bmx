' 2DLab - 2D application developing environment 
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3

SuperStrict

Framework brl.d3d7max2d
'Import brl.glmax2d
Import brl.random
Import brl.pngloader
Import brl.jpgloader
Import brl.reflection
'Import brl.audio
'Import brl.freeaudioaudio
Import brl.directsoundaudio
Import brl.wavloader
Import brl.retro
'Import maxgui.win32maxgui

SetAudioDriver( "DirectSound" )
'SetGraphicsDriver( GLMax2DDriver() )

SeedRnd( Millisecs() )

Const L_Version:String = "0.1"

Include "include/LTObject.bmx"
Include "include/LTProject.bmx"
Include "include/LTActor.bmx"
Include "include/LTCamera.bmx"
