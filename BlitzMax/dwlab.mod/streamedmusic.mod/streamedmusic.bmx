'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Module dwlab.streamedmusic

Import dwlab.music
Import maxmod2.maxmod2

L_Music = New LTStreamedMusicHandler

Type LTStreamedMusicHandler Extends LTMusicHandler
	Field CurrentEntry:LTStreamedMusicEntry
	Global Channel:TChannel = New TChannel

	Method Preload( FileName:String, Name:String )
		Local Entry:LTStreamedMusicEntry = New LTStreamedMusicEntry
		Entry.FileName = FileName
		Entry.Name = Name
		AllEntries.AddLast( Entry )
	End Method
	
	Method Add( Name:String, Looped:Int = False, Rate:Double = 1.0 )
		For Local Entry:LTStreamedMusicEntry = Eachin AllEntries
			If Entry.Name = Name Then
				Local NewEntry:LTStreamedMusicEntry = New LTStreamedMusicEntry
				NewEntry.FileName = Entry.FileName
				NewEntry.Looped = Looped
				NewEntry.Rate = Rate
				Entries.AddLast( NewEntry )
				Return
			End If
		Next
	End Method
	
	Method StartMusic( NextEntry:Int = False )
		If Channel Then Channel.Stop()
		If NextEntry And Not Entries.IsEmpty() Then Entries.RemoveFirst()
		If Entries.IsEmpty() Then
			MusicMode = Stopped
		Else
			CurrentEntry = LTStreamedMusicEntry( Entries.First() )
			Channel = CueMusic( CurrentEntry.FileName )
			Channel.SetRate( CurrentEntry.Rate )
			Channel.SetVolume( Volume )
			ResumeChannel( Channel )
			MusicMode = Normal
		End If
	End Method
	
	Method Manage()
		Local Vol:Double
		Select MusicMode
			Case Fading
				If OperationStartTime + Period > 0.001 * MilliSecs() And MusicChannel Then
					Vol = 1.0:Double * ( OperationStartTime + Period - MilliSecs() ) / Period
					Channel.SetVolume( Vol * Volume )
				Else
					If NextMus Then
						Start( True )
					Else
						PauseChannel( Channel )
						MusicMode = Paused
					End If
				End If
			Case Rising
				If OperationStartTime + PauseMusicFadingPeriod > MilliSecs() Then
					Vol = 1.0:Double * ( MilliSecs() - OperationStartTime ) / PauseMusicFadingPeriod
					Channel.SetVolume( Vol * Volume )
				Else
					MusicMode = Normal
				End If
			Case Normal
				If Not Channel.Playing() Then Start( Not CurrentEntry.Looped )
		End Select
	End Method
	
	Method SetVolume( Vol:Int )
		Volume = Vol
		Channel.SetVolume( Volume )
	End Method
	
	Method GetName:String()
		Return CurrentEntry.Name
	End Method
End Type



Type LTStreamedMusicEntry Extends LTMusicEntry
	Field FileName:String
End Type