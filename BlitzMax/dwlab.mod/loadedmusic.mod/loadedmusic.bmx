'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
Module dwlab.loadedmusic

Import dwlab.music
Import brl.audio

L_Music = New LTLoadedMusicHandler

Type LTLoadedMusicHandler Extends LTMusicHandler
	Field CurrentEntry:LTLoadedMusicEntry
	Field Channel:TChannel = New TChannel

	Method Preload( FileName:String, Name:String )
		Local Entry:LTLoadedMusicEntry = New LTLoadedMusicEntry
		Entry.Sound = LoadSound( FileName )
		Entry.Name = Name
		AllEntries.AddLast( Entry )
	End Method
	
	Method Add( Name:String, Looped:Int = False, Rate:Double = 1.0 )
		For Local Entry:LTLoadedMusicEntry = Eachin AllEntries
			If Entry.Name = Name Then
				Local NewEntry:LTLoadedMusicEntry = New LTLoadedMusicEntry
				NewEntry.Sound = Entry.Sound
				NewEntry.Looped = Looped
				NewEntry.Rate = Rate
				Entries.AddLast( NewEntry )
				Return
			End If
		Next
	End Method
	
	Method Start()
		If Channel Then Channel.Stop()
		If Entries.IsEmpty() Then
			MusicMode = Stopped
		Else
			CurrentEntry = LTLoadedMusicEntry( Entries.First() )
			Channel = CueSound( CurrentEntry.Sound )
			Channel.SetRate( CurrentEntry.Rate )
			Channel.SetVolume( Volume )
			ResumeChannel( Channel )
			MusicMode = Normal
		End If
	End Method
	
	Method StopMusic()
		Channel.Stop()
	End Method
	
	Method Manage()
		Local Vol:Double
		Select MusicMode
			Case Fading
				If OperationStartTime + Period > MilliSecs() Then
					Vol = 1.0:Double * ( OperationStartTime + Period - MilliSecs() ) / Period
					Channel.SetVolume( Vol * Volume )
				Else
					If NextMus Then
						Start()
					Else
						PauseChannel( Channel )
						MusicMode = Paused
					End If
				End If
			Case Rising
				If Not Channel.Playing() Then ResumeChannel( Channel )
				If OperationStartTime + Period > MilliSecs() Then
					Vol = 1.0:Double * ( MilliSecs() - OperationStartTime ) / Period
					Channel.SetVolume( Vol * Volume )
				Else
					Channel.SetVolume( Volume )
					MusicMode = Normal
				End If
			Case Normal
				If Not Channel.Playing() Then NextMusic( False, Not( ForceRepeat Or CurrentEntry.Looped ) )
		End Select
	End Method
	
	Method SetVolume( Vol:Double )
		Volume = Vol
		Channel.SetVolume( Volume )
	End Method
End Type



Type LTLoadedMusicEntry Extends LTMusicEntry
	Field Sound:TSound
End Type