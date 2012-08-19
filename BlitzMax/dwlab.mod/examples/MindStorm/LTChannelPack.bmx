'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Channel pack provides ability to initialize several channels for playing separated set of sounds.
EndRem
Type LTChannelPack
	Field Channel:TChannel[]
	Field ChannelsQuantity:Int
	
	
	
	Rem
	bbdoc: Creates new channel pack with givwen channels quantity.
	returns: New channels pack
	EndRem
	Function Create:LTChannelPack( ChannelsQuantity:Int )
		Local ChannelPack:LTChannelPack = New LTChannelPack
		ChannelPack.Channel = New TChannel[ ChannelsQuantity ]
		ChannelPack.ChannelsQuantity = ChannelsQuantity
		For Local N:Int = 0 Until ChannelsQuantity
			ChannelPack.Channel[ N ] = New TChannel
		Next
		Return ChannelPack
	End Function
	
	
	
	Rem
	bbdoc: Plays a sound using channel pack.
	about: You can specify volume and rate of the sound. If channel pack has no free channels, then sound will not be played.
	EndRem
	Method Play( Sound:TSound, Volume:Double = -1.0, Rate:Double = 1.0 )
		For Local N:Int = 0 Until ChannelsQuantity
			If Not Channel[ N ].Playing() Then
				Channel[ N ] = CueSound( Sound )
				If Volume >= 0.0 Then SetChannelVolume( Channel[ N ], Volume )
				If Rate <> 1.0 Then SetChannelRate( Channel[ N ], Rate )
				ResumeChannel( Channel[ N ] )
				Exit
			End If
		Next
	End Method
End Type