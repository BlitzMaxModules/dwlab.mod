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
	Global Volume:Double
	
	Global MusicMode:Int = Normal
	
	Const Normal:Int = 0
	Const Paused:Int = 1
	Const Fading:Int = 2
	Const Rising:Int = 3
	Const Stopped:Int = 4

	Method Preload( FileName:String, Name:String )
	End Method
	
	Method Add( Name:String, Looped:Int, Rate:Double )
	End Method
	
	Method Start( NextEntry:Int = False )
	End Method
	
	Method StopMusic( FadeOut:Int = False )
		Entries.Clear()
		Pause( FadeOut )
	End Method
	
	Method Pause( FadeOut:Int = False )
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
		MusicMode = Rising
		OperationStartTime = MilliSecs()
	End Method
	
	Method NextMusic( FadeOut:Int = False )
		If FadeOut Then
			Period = PauseMusicFadingPeriod
		Else
			Period = 0
		End If
		NextMus = True
		OperationStartTime = MilliSecs()
	End Method
	
	Method SwitchMusicPlaying( Fade:Int = False )
		Select MusicMode
			Case Normal
				Pause( Fade )
			Case Paused
				Resume( Fade )
			Case Stopped
				Start()
		End Select
	End Method
	
	Method PrevTrack( FadeOut:Int = False, Looped:Int = False, Rate:Double = 1.0 )
		If MusicMode <> Normal Then Return
		Local Link:TLink = GetEntryLink()
		If Link = AllEntries.FirstLink() Then
			Add( LTMusicEntry( AllEntries.Last() ).Name, Looped, Rate )
		Else
			Add( LTMusicEntry( Link.PrevLink().Value() ).Name, Looped, Rate )
		End If
		NextMusic( FadeOut )
	End Method
	
	Method NextTrack( FadeOut:Int = False, Looped:Int = False, Rate:Double = 1.0 )
		If MusicMode <> Normal Then Return
		Local Link:TLink = GetEntryLink()
		If Link = AllEntries.LastLink() Then
			Add( LTMusicEntry( AllEntries.First() ).Name, Looped, Rate )
		Else
			Add( LTMusicEntry( Link.NextLink().Value() ).Name, Looped, Rate )
		End If
		NextMusic( FadeOut )
	End Method
	
	Method Manage()
	End Method
	
	Method GetEntryLink:TLink()
	End Method
End Type



Type LTMusicEntry
	Field Link:TLink
	Field Name:String
	Field Looped:Int
	Field Rate:Int
End Type