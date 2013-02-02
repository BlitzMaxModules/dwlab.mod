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
bbdoc: Current profile.
End Rem
Global L_CurrentProfile:LTProfile

Global L_ProjectWindow:TGadget, L_ProjectCanvas:TGadget
Global L_XResolution:Int, L_YResolution:Int
Global L_ViewportCenterX:Int, L_ViewportCenterY:Int

Global L_Profiles:TList = New TList
Global L_Languages:TList = New TList
Global L_AudioDrivers:TList = New TList

Rem
bbdoc: Head class for profiles.
End Rem
Type LTProfile Extends LTObject	
	Field LevelName:String
	Field LevelTime:Double
	
	Global SoundChannels:TMap = New TMap
	Global ChannelsList:TList = New TList
	Global RelativeMusicVolume:Double = 1.0
	
	Rem
	bbdoc: Name of the profile.
	End Rem
	Field Name:String
	
	Rem
	bbdoc: Quantity of points earned by the player.
	End Rem
	Field Score:Int
	
	Rem
	bbdoc: Name of MaxGUI language.
	End Rem
	Field Language:String
	
	Rem
	bbdoc: Full screen flag (false means windowed mode).
	End Rem
	Field FullScreen:Int
	
	Rem
	bbdoc: Width of screen resolution.
	End Rem
	Field ScreenWidth:Int
	
	Rem
	bbdoc: Height of screen resolution.
	End Rem
	Field ScreenHeight:Int
	
	Rem
	bbdoc: Screen color depth.
	End Rem
	Field ColorDepth:Int
	
	Rem
	bbdoc: Display refreshing frequency.
	End Rem
	Field Frequency:Int
	
	Rem
	bbdoc: List of changeable keys (button actions).
	End Rem
	Field Keys:TList = New TList
	
	Rem
	bbdoc: Sound flag.
	about: True means sound is on, False means off.
	End Rem
	Field SoundOn:Int = True
	
	Rem
	bbdoc: Sound volume ( 0.0 - 1.0 ).
	End Rem
	Field SoundVolume:Double = 1.0
	
	Rem
	bbdoc: Music flag.
	about: True means sound is on, False means off.
	End Rem
	Field MusicOn:Int = True
	
	Rem
	bbdoc: Music volume ( 0.0 - 1.0 ).
	End Rem
	Field MusicVolume:Double = 1.0
	
	Field MusicRepeat:Int = True
	Field MusicName:String
	Field PlayList:String[]
	Field TrackNum:Int

	Field MinGrainSize:Int = 8
	Field GrainXQuantity:Int = 64
	Field MinGrainYQuantity:Int = 36
	Field MaxGrainYQuantity:Int = 48
	
	Field FirstLockedLevel:String
	
	
	
	Rem
	bbdoc: Profile system initialization function.
	about: Fills lists of available graphic modes, graphic and audio drivers.
	End Rem
	Function InitSystem()
		For Local Mode:TGraphicsMode = Eachin GraphicsModes()
			If Mode.Width >= 640 And Mode.Width > Mode.Height Then 
				LTScreenResolution.Add( Mode.Width, Mode.Height, Mode.Depth, Mode.Hertz )
				'DebugLog Mode.Width + ", " + Mode.Height + ", " + Mode.Depth + ", " + Mode.Hertz
			End If
		Next
	End Function
	
	
	
	Rem
	bbdoc: Default profile creation function.
	returns: New default profile.
	about: Creates profile, sets its parameters to default values and initializes profile.
	End Rem
	Function CreateDefault:LTProfile( ProfileTypeID:TTypeID )
		Local Profile:LTProfile = LTProfile( ProfileTypeID.NewObject() )
		Profile.Name = "{{P_Player}}"
		
		Local Resolution:LTScreenResolution = LTScreenResolution.Get()
		Profile.ScreenWidth = Resolution.Width
		Profile.ScreenHeight = Resolution.Height
		Local ColorDepth:LTColorDepth = LTColorDepth.Get( Resolution )
		Profile.ColorDepth = ColorDepth.Bits
		Profile.Frequency = LTFrequency.Get( ColorDepth ).Hertz
				
		Profile.Init()
		Profile.Reset()
		Return Profile
	End Function
	
	
	
	Rem
	bbdoc: Finds language with given name.
	returns: Language with given name from languages list.
	End Rem
	Function GetLanguage:TMaxGuiLanguage( Name:String )
		For Local Language:TMaxGuiLanguage = Eachin L_Languages
			If Language.GetName() = Name Then Return Language
		Next
		Return TMaxGuiLanguage( L_Languages.First() )
	End Function
	
	
	
	Rem
	bbdoc: Applies profile.
	about: You can specify an array of projects which should been initialized after changing drivers or screen resolution.
	End Rem
	Method Apply( Projects:LTProject[] = Null, NewScreen:Int = True, NewLanguage:Int = True )
		If NewLanguage Then SetLocalizationLanguage( GetLanguage( Language ) )
		
		If NewScreen Then
			If FullScreen Then
				If L_ProjectWindow Then
					DisablePolledInput()
					FreeGadget( L_ProjectWindow )
					L_ProjectWindow = Null
				Else
					EndGraphics()
				End If
				ChangeViewportResolution( ScreenWidth, ScreenHeight )
				Graphics( ScreenWidth, ScreenHeight, ColorDepth, Frequency )
				L_ViewportCenterX = 0.5 * ScreenWidth
				L_ViewportCenterY = 0.5 * ScreenHeight
			Else
				If L_ProjectWindow Then
					ChangeViewportResolution( ClientWidth( L_ProjectWindow ), ClientHeight( L_ProjectWindow ) )
					SetGadgetShape( L_ProjectWindow, GadgetX( L_ProjectWindow ), GadgetY( L_ProjectWindow ), L_XResolution, L_YResolution )
				Else
					EndGraphics()
					Local MaxXResolution:Int = ClientWidth( Desktop() ) - 8
					Local MaxYResolution:Int = ClientHeight( Desktop() ) - 34
					If L_XResolution < MinGrainSize * GrainXQuantity Or L_YResolution < MinGrainSize * MinGrainYQuantity Or ..
							L_XResolution > MaxXResolution Or L_YResolution > MaxYResolution Then
						ChangeViewportResolution( MaxXResolution, MaxYResolution )
					End If
					L_ProjectWindow = CreateWindow( AppTitle, 0.5 * ( ClientWidth( Desktop() ) - L_XResolution - 4 ), ..
							0.5 * ( ClientHeight( Desktop() ) - L_YResolution - 13 ), L_XResolution, L_YResolution, Null, ..
							Window_TItleBar | Window_Resizable | Window_ClientCoords )
					L_ProjectCanvas = CreateCanvas( 0, 0, ClientWidth( L_ProjectWindow ), ClientHeight( L_ProjectWindow ), L_ProjectWindow )
					SetGadgetLayout( L_ProjectCanvas, Edge_Aligned, Edge_Aligned, Edge_Aligned, Edge_Aligned )
				End If
				SetGraphics( CanvasGraphics( L_ProjectCanvas ) )
				EnablePolledInput( L_ProjectCanvas )
				ActivateGadget( L_ProjectCanvas )
				L_ViewportCenterX = 0.5 * L_XResolution
				L_ViewportCenterY = 0.5 * L_YResolution
			End If
			AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
			SetBlend( AlphaBlend )
		End If
		
		If Projects Then
			For Local Project:LTProject = Eachin Projects
				If NewScreen Then Project.InitGraphics()
				If NewScreen Or NewLanguage Then Project.ReloadWindows()
			Next
		End If
		
		UpdateMusicVolume()
	End Method
	
	
	
	Method ChangeViewportResolution( Width:Int, Height:Int )
		Local Grain:Int = Floor( Width / 64.0 )
		If Height < MinGrainYQuantity * Grain Then
			Grain = Floor( 1.0 * Height / MinGrainYQuantity )
			L_YResolution = Grain * MinGrainYQuantity
		ElseIf Height > MaxGrainYQuantity * Grain Then
			Grain = Floor( 1.0 * Height / MaxGrainYQuantity )
			L_YResolution = Grain * MaxGrainYQuantity
		Else
			L_YResolution = Height
		End If
		If Grain < MinGrainSize Then
			L_XResolution = MinGrainSize * GrainXQuantity
			L_YResolution = MinGrainSize * MinGrainYQuantity
		Else
			L_XResolution = Grain * GrainXQuantity
		End If
	End Method
	
	
	
	Rem
	bbdoc: Initializes given camera according to profile's resolution.
	about: Fixes camera height and sets viewport to corresponding shape according screen grain.
	End Rem
	Method InitCamera( Camera:LTCamera )
		Camera.SetSize( Camera.Width, Camera.Width / L_XResolution * L_YResolution )
		Camera.Viewport.SetCoords( L_ViewportCenterX, L_ViewportCenterY )
		Camera.Viewport.SetSize( L_XResolution, L_YResolution )
		Camera.Update()
	End Method
	
	
	
	Rem
	bbdoc: Sound playing function.
	returns: Channel allocated for playing sound.
	about: Use it instead of standard to make profile sound volume affect playing sound. Function also regisers the channel of a sound.
	Temporary flag defines if channel of sound should be unregistered after stopping or pausing.
	If you set Temporary flag to false, you should unregister sound after use manually by calling UnregisterSound function.
	End Rem
	Method PlaySnd:TChannel( Sound:TSound, Temporary:Int = True, Volume:Double = 1.0, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
		If Not SoundOn Then Return Null
		Local Channel:TChannel = CueSound( Sound )
		SetChannelParameters( Channel, Rate, Pan, Depth )
		SetRelativeSoundVolume( Channel, Volume )
		ResumeChannel( Channel )
		If Temporary Then ChannelsList.AddLast( Channel )
	End Method
	
	
	
	Function SetChannelParameters:TChannel( Channel:TChannel, Rate:Double = 1.0, Pan:Double = 0.0, Depth:Double = 0.0 )
		If Rate <> 1.0 Then Channel.SetRate( Rate )
		If Pan <> 0.0 Then Channel.SetPan( Pan )
		If Depth <> 0.0 Then Channel.SetDepth( Depth )
		Return Channel
	End Function
	
	
	
	Rem
	bbdoc: Sound master volume setting function.
	about: This function also registers the channel for setting sound master volume.
	End Rem
	Method SetSoundVolume( Volume:Double )
		SoundVolume = Volume
		UpdateSoundVolume()
	End Method
	
	
	
	Rem
	bbdoc: Relative sound channel volume setting function.
	about: This function also registers the channel for setting sound master volume.
	End Rem
	Method SetRelativeSoundVolume( Channel:TChannel, Volume:Double )
		Channel.SetVolume( Volume * SoundVolume * SoundOn )
		SoundChannels.Insert( Channel, String( Volume ) )
	End Method
	
	
	
	Method UpdateSoundVolume()
		For Local KeyValue:TKeyValue = Eachin SoundChannels
			TChannel( KeyValue.Key() ).SetVolume( String( KeyValue.Value() ).ToDouble() * SoundVolume * SoundOn )
		Next
	End Method
	
	
	
	Rem
	bbdoc: Music master volume setting function.
	End Rem
	Method SetMusicVolume( Volume:Double )
		MusicVolume = Volume
		UpdateMusicVolume()
	End Method
	
	
		
	Rem
	bbdoc: Music relative volume setting function.
	about: This function also registers the channel for setting music master volume.
	End Rem
	Method SetRelativeMusicVolume( Volume:Double )
		RelativeMusicVolume = Volume
		UpdateMusicVolume()
	End Method
	
	
	
	Method UpdateMusicVolume()
		DebugLog RelativeMusicVolume
		DebugLog MusicVolume
		DebugLog MusicOn
		DebugLog RelativeMusicVolume * MusicVolume * MusicOn
		L_Music.SetVolume( RelativeMusicVolume * MusicVolume * MusicOn )
	End Method
	
	
	
	Method StartTrack()
		L_Music.Entries.Clear()
		L_Music.Add( PlayList[ TrackNum ], MusicRepeat )
		L_Music.Start()
	End Method
	
	
	
	Method NextTrack()
		TrackNum :+ 1
		If TrackNum >= PlayList.Length Then TrackNum = 0
		L_Music.Entries.Clear()
		L_Music.Add( PlayList[ TrackNum ], MusicRepeat )
		L_Music.NextMusic( True, False )
	End Method
	
	
	
	Method PrevTrack()
		TrackNum :- 1
		If TrackNum < 0  Then TrackNum = PlayList.Length - 1
		L_Music.Entries.Clear()
		L_Music.Add( PlayList[ TrackNum ], MusicRepeat )
		L_Music.NextMusic( True, False )
	End Method
	
	
	
	Rem
	bbdoc: Cleaning function which unregisters given channel.
	End Rem
	Function UnregisterChannel( Channel:TChannel )
		SoundChannels.Remove( Channel )
	End Function
	
	
	
	Method ManageSounds()
		For Local Channel:TChannel = Eachin ChannelsList
			If Not Channel.Playing() Then UnregisterChannel( Channel )
		Next
		
		L_Music.Manage()
		If L_Music.Entries.IsEmpty() Then NextTrack()
	End Method
	
	
	
	Method LoadLevel( Level:LTLayer )
	End Method
	
	
	Rem
	bbdoc: Clones the profile
	returns: Profile which is exact copy of given.
	End Rem
	Method Clone:LTProfile()
		Local Profile:LTProfile = New Self
		Profile.Name = Name
		Profile.Language = Language
		Profile.FullScreen = FullScreen
		Profile.ScreenWidth = ScreenWidth
		Profile.ScreenHeight = ScreenHeight
		Profile.ColorDepth = ColorDepth
		Profile.Frequency = Frequency
		Return Profile
	End Method
	
	
	
	Rem
	bbdoc: Profile initialization method.
	about: Fill it with code which should be executed at profile's creation.
	End Rem
	Method Init()
	End Method
	
	
	
	Rem
	bbdoc: Profile resetting method.
	about: Fill it with code which should be executed at profile's creation and after game over.
	End Rem
	Method Reset()
	End Method
	
	
	
	Rem
	bbdoc: Profile loading method.
	about: Will be executed at start and after switching to this profile.
	Fill it with code which transfers data from the profile to the game objects.
	End Rem
	Method Load()
	End Method
	
	
	
	Rem
	bbdoc: Profile saving method.
	about: Will be executed before switching profiles and before exit.
	Fill it with code which transfers data from the game objects to the profile.
	End Rem
	Method Save()
	End Method
	
	
	
	Method SetAsCurrent()		
	End Method
	
	
	
	Method AddHighScore( LevelIsCompleted:Int )
	End Method
	
	
	
	Method AddKeys( Items:TList )
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageStringAttribute( "language", Language )
		XMLObject.ManageIntAttribute( "fullscreen", FullScreen )
		XMLObject.ManageIntAttribute( "width", ScreenWidth )
		XMLObject.ManageIntAttribute( "height", ScreenHeight )
		XMLObject.ManageIntAttribute( "depth", ColorDepth )
		XMLObject.ManageIntAttribute( "frequency", Frequency )
		XMLObject.ManageChildList( Keys )
		XMLObject.ManageIntAttribute( "sound-on", SoundOn, 1 )
		XMLObject.ManageDoubleAttribute( "sound-volume", SoundVolume, 1.0 )
		XMLObject.ManageIntAttribute( "music-on", MusicOn, 1 )
		XMLObject.ManageDoubleAttribute( "music-volume", MusicVolume, 1.0 )
		XMLObject.ManageIntAttribute( "repeat", MusicRepeat, True )
		XMLObject.ManageStringAttribute( "music", MusicName )
		XMLObject.ManageIntAttribute( "x-resolution", L_XResolution )
		XMLObject.ManageIntAttribute( "y-resolution", L_YResolution )
		XMLObject.ManageStringAttribute( "first-locked-level", FirstLockedLevel )
		XMLObject.ManageStringAttribute( "level", LevelName )
	End Method
End Type