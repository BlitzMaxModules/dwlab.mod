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

Function L_PlaySound:TChannel( Sound:TSound, Volume:Double = 1.0, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = L_PlaySoundAndSetParameters( Sound, Rate, Pan, Depth )
	L_SetSoundVolume( Channel, Volume )
	ResumeChannel( Channel )
End Function

Function L_PlayMusic:TChannel( Sound:TSound, Volume:Double = 1.0, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = L_PlaySoundAndSetParameters( Sound, Rate, Pan, Depth )
	L_SetMusicVolume( Channel, Volume )
	ResumeChannel( Channel )
End Function

Function L_PlaySoundAndSetParameters:TChannel( Sound:TSound, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
	Local Channel:TChannel = CueSound( Sound )
	If Rate <> 1.0 Then Channel.SetRate( Rate )
	If Pan <> 0.0 Then Channel.SetPan( Pan )
	If Depth <> 0.0 Then Channel.SetDepth( Depth )
	Return Channel
End Function

Function L_SetSoundVolume( Channel:TChannel, Volume:Double )
	Channel.SetVolume( Volume * L_CurrentProfile.SoundVolume * L_CurrentProfile.SoundOn )
	L_SoundChannels.Insert( Channel, String( Volume ) )
End Function

Function L_SetMusicVolume( Channel:TChannel, Volume:Double )
	Channel.SetVolume( Volume * L_CurrentProfile.MusicVolume * L_CurrentProfile.MusicOn )
	L_MusicChannels.Insert( Channel, String( Volume ) )
End Function

Function L_RefreshSounds()
	For Local KeyValue:TKeyValue = Eachin L_SoundChannels
		L_SetSoundVolume( TChannel( KeyValue.Key() ), String( KeyValue.Value() ).ToDouble() )
	Next
	
	For Local KeyValue:TKeyValue = Eachin L_MusicChannels
		L_SetMusicVolume( TChannel( KeyValue.Key() ), String( KeyValue.Value() ).ToDouble() )
	Next
End Function