'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_SoundChannels:TMap = New TMap
Global L_MusicChannels:TMap = New TMap
Global L_ChannelsList:TList = New TList

Rem
bbdoc: Sound playing function.
returns: Channel allocated for playing sound.
about: Use it instead of standard to make profile sound volume affect playing sound. Function also regisers the channel of a sound.
Temporary flag defines if channel of sound should be unregistered after stopping or pausing.
If you set Temporary flag to false, you should unregister sound after use manually by calling L_UnregisterSound function.
End Rem
Function L_PlaySound:TChannel( Sound:TSound, Temporary:Int = True, Volume:Double = 1.0, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = L_PlaySoundAndSetParameters( Sound, Rate, Pan, Depth )
	L_SetSoundVolume( Channel, Volume )
	ResumeChannel( Channel )
	If Temporary Then L_ChannelsList.AddLast( Channel )
End Function



Rem
bbdoc: Music playing function.
returns: Channel allocated for playing music.
about: Use it instead of standard sound playing functions to make profile music volume affect playing music. Function also regisers the channel of a music.
End Rem
Function L_PlayMusic:TChannel( Sound:TSound, Temporary:Int = True, Volume:Double = 1.0, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = L_PlaySoundAndSetParameters( Sound, Rate, Pan, Depth )
	L_SetMusicVolume( Channel, Volume )
	ResumeChannel( Channel )
	If Temporary Then L_ChannelsList.AddLast( Channel )
End Function



Function L_PlaySoundAndSetParameters:TChannel( Sound:TSound, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = CueSound( Sound )
	If Rate <> 1.0 Then Channel.SetRate( Rate )
	If Pan <> 0.0 Then Channel.SetPan( Pan )
	If Depth <> 0.0 Then Channel.SetDepth( Depth )
	Return Channel
End Function



Rem
bbdoc: Sound channel volume setting function.
about: This function also registers the channel for setting sound master volume.
End Rem
Function L_SetSoundVolume( Channel:TChannel, Volume:Double )
	Channel.SetVolume( Volume * L_CurrentProfile.SoundVolume * L_CurrentProfile.SoundOn )
	L_SoundChannels.Insert( Channel, String( Volume ) )
End Function



Rem
bbdoc: Music channel volume setting function.
about: This function also registers the channel for setting music master volume.
End Rem
Function L_SetMusicVolume( Channel:TChannel, Volume:Double )
	Channel.SetVolume( Volume * L_CurrentProfile.MusicVolume * L_CurrentProfile.MusicOn )
	L_MusicChannels.Insert( Channel, String( Volume ) )
End Function



Rem
bbdoc: Sound refreshing function.
about: This function sets the volume to all sounds. Call it when sound and music settings of current profile are changed.
End Rem
Function L_RefreshSounds()
	For Local KeyValue:TKeyValue = Eachin L_SoundChannels
		L_SetSoundVolume( TChannel( KeyValue.Key() ), String( KeyValue.Value() ).ToDouble() )
	Next
	
	For Local KeyValue:TKeyValue = Eachin L_MusicChannels
		L_SetMusicVolume( TChannel( KeyValue.Key() ), String( KeyValue.Value() ).ToDouble() )
	Next
End Function


Rem
bbdoc: Cleaning function which unregisters sounds which stopped playing.
about: This function should be called periodically during the program execution (probably in project's Logic() method).
End Rem
Function L_ClearSoundMaps()
	For Local Channel:TChannel = Eachin L_ChannelsList
		If Not Channel.Playing() Then L_UnregisterChannel( Channel )
	Next
End Function



Rem
bbdoc: Cleaning function which unregisters given channel.
End Rem
Function L_UnregisterChannel( Channel:TChannel )
	L_SoundChannels.Remove( Channel )
	L_MusicChannels.Remove( Channel )
End Function