'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Module dwlab.music

Import brl.linkedlist

Global L_Music:LTMusicHandler = New LTMusicHandler

Type LTMusicHandler
	Global PauseMusicFadingPeriod:Int = 500
	Global NextMusicFadingPeriod:Int = 1000
	Global AllEntries:TList = New TList
	Global Entries:TList = New TList
	Global NextMus:Int
	Global Period:Double
	Global OperationStartTime:Int
	Global Volume:Double = 1.0
	
	Global MusicMode:Int = Stopped
	
	Const Normal:Int = 0
	Const Paused:Int = 1
	Const Fading:Int = 2
	Const Rising:Int = 3
	Const Stopped:Int = 4

	Method Preload( FileName:String, Name:String )
	End Method
	
	Method Add( Name:String, Looped:Int = False, Rate:Double = 1.0 )
	End Method
	
	Method Start()
	End Method
	
	Method StopMusic( FadeOut:Int = False )
		Entries.Clear()
		NextMusic( FadeOut )
	End Method
	
	Method Pause( FadeOut:Int = False )
		If MusicMode = Rising Then
			OperationStartTime =  MilliSecs() * 2 - OperationStartTime
		ElseIf MusicMode = Normal Then
			OperationStartTime = MilliSecs()
		Else
			Return
		End If
		If FadeOut Then
			Period = PauseMusicFadingPeriod
		Else
			Period = 0
		End If
		MusicMode = Fading
		NextMus = False
		OperationStartTime = MilliSecs()
	End Method
	
	Method Resume( FadeIn:Int = False )
		If MusicMode = Fading Then
			OperationStartTime =  MilliSecs() * 2 - OperationStartTime
		ElseIf MusicMode = Normal Then
			OperationStartTime = MilliSecs()	
		ElseIf MusicMode = Rising Then
			Return
		End If
		If FadeIn Then
			Period = PauseMusicFadingPeriod
		Else
			Period = 0
		End If
		MusicMode = Rising
	End Method
	
	Method NextMusic( FadeOut:Int = False, RemoveFirstEntry:Int = True )
		If Entries.IsEmpty() Then Return
		If FadeOut Then
			Period = NextMusicFadingPeriod
		Else
			Period = 0
		End If
		MusicMode = Fading
		If RemoveFirstEntry Then Entries.RemoveFirst()
		NextMus = True
		OperationStartTime = MilliSecs()
	End Method
	
	Method SwitchMusicPlaying( Fade:Int = False )
		Select MusicMode
			Case Normal, Rising
				Pause( Fade )
			Case Paused, Fading
				Resume( Fade )
			Case Stopped
				Start()
		End Select
	End Method
	
	Method Manage()
	End Method
	
	Method SetVolume( Vol:Int )
	End Method
	
	Method GetName:String()
	End Method
End Type



Type LTMusicEntry
	Field Name:String
	Field Looped:Int
	Field Rate:Int
End Type