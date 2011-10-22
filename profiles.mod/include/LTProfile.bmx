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

Global L_ProjectWindow:TGadget 
Global L_CameraWidth:Double = 16.0

Global L_Profiles:TList = New TList
Global L_Languages:TList = New TList
Global L_AudioDrivers:TList = New TList

Rem
bbdoc: Head class for profiles.
End Rem
Type LTProfile Extends LTObject
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
	bbdoc: Name of the audio driver.
	End Rem
	Field AudioDriver:String
	
	Rem
	bbdoc: Name of the video driver.
	End Rem
	Field VideoDriver:String
	
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
		
		For Local DriverTypeID:TTypeId = Eachin TTypeID.ForName( "TMax2DDriver" ).DerivedTypes()
			Local Driver:TMax2DDriver = Null
			Local DriverName:String = ""
			?win32
			Select DriverTypeID.Name()
				Case "TD3D7Max2DDriver"
					Driver = D3D7Max2DDriver()
				Case "TD3D9Max2DDriver"
					Driver = D3D9Max2DDriver()
			End Select
			?
			Local DriverObject:Object = DriverTypeID.NewObject()
			For Local TheMethod:TMethod = Eachin DriverTypeID.EnumMethods()
				Local Name:String = TheMethod.Name().ToLower()
				If Name = "create" Then Driver = TMax2DDriver( TheMethod.Invoke( DriverObject, Null ) )
				If Name = "tostring" Then DriverName = String( TheMethod.Invoke( DriverObject, Null ) )
			Next
			If Driver Then
				Local VideoDriver:LTVideoDriver = New LTVideoDriver
				VideoDriver.Driver = Driver
				VideoDriver.Name = DriverName
				L_VideoDrivers.AddLast( VideoDriver )
			End If
		Next
		
		For Local Driver:String = Eachin AudioDrivers()
			L_AudioDrivers.AddLast( Driver )
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
		
		Local TypeID:TTypeId = TTypeId.ForObject( GetGraphicsDriver() )
		For Local Driver:LTVideoDriver = Eachin L_VideoDrivers
			If TTypeID.ForObject( Driver.Driver ) = TypeID Then Profile.VideoDriver = Driver.Name
		Next
		
		Local Resolution:LTScreenResolution = LTScreenResolution.Get()
		Profile.ScreenWidth = Resolution.Width
		Profile.ScreenHeight = Resolution.Height
		Local ColorDepth:LTColorDepth = LTColorDepth.Get( Resolution )
		Profile.ColorDepth = ColorDepth.Bits
		Profile.Frequency = LTFrequency.Get( ColorDepth ).Hertz
		
		?win32
		If AudioDriverExists( "DirectSound" ) Then Profile.AudioDriver = "DirectSound"
		?
		If Not Profile.AudioDriver And AudioDrivers() Then Profile.AudioDriver = AudioDrivers()[ 0 ]
		
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
	Method Apply( Projects:LTProject[] = Null, NewScreen:Int = True, NewVideoDriver:Int = True, NewAudioDriver:Int = True, NewLanguage:Int = True )
		If NewLanguage Then SetLocalizationLanguage( GetLanguage( Language ) )
		
		If NewVideoDriver Then SetGraphicsDriver( LTVideoDriver.Get( VideoDriver ).Driver )
		
		If NewScreen Or NewVideoDriver Then
			If L_ProjectWindow Then
				DisablePolledInput()
				FreeGadget( L_ProjectWindow )
				L_ProjectWindow = Null
			Else
				EndGraphics()
			End If
			If FullScreen Then
				Graphics( ScreenWidth, ScreenHeight, ColorDepth, Frequency )
			Else
				L_ProjectWindow = CreateWindow( AppTitle, 0, 0, 640, 480, Null, Window_TItleBar | Window_Resizable )
				MaximizeWindow( L_ProjectWindow )
				SetMinWindowSize( L_ProjectWindow, GadgetWidth( L_ProjectWindow ), GadgetHeight( L_ProjectWindow ) )
				SetMaxWindowSize( L_ProjectWindow, GadgetWidth( L_ProjectWindow ), GadgetHeight( L_ProjectWindow ) )
				
				Local Canvas:TGadget = CreateCanvas( 0, 0, ClientWidth( L_ProjectWindow ), ClientHeight( L_ProjectWindow ), L_ProjectWindow )
				SetGraphics( CanvasGraphics( Canvas ) )
				EnablePolledInput( Canvas )
				ActivateGadget( Canvas )
			End If
			AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
			SetBlend( AlphaBlend )
		End If
		
		If NewAudioDriver Then
			For Local Channel:TChannel = Eachin L_ChannelsList
				Channel.Stop()
			Next
			SetAudioDriver( AudioDriver )
			L_SoundChannels.Clear()
			L_MusicChannels.Clear()
			L_ChannelsList.Clear()
		End If
		
		If Projects Then
			For Local Project:LTProject = Eachin Projects
				If NewVideoDriver Or NewScreen Then Project.InitGraphics()
				If NewScreen Or NewLanguage Then Project.ReloadWindows()
				If NewAudioDriver Then Project.InitSound()
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Initializes given camera according to profile's resolution.
	about: Fixes camera height and sets viewport to corresponding shape according screen grain.
	End Rem
	Method InitCamera( Camera:LTCamera )
		Camera.SetSize( Camera.Width, Camera.Width / GraphicsWidth() * GraphicsHeight() )
		Camera.Viewport.SetCoords( 0.5 * GraphicsWidth(), 0.5 * GraphicsHeight() )
		Camera.Viewport.SetSize( GraphicsWidth(), GraphicsHeight() )
		Camera.Update()
	End Method
	
	
	
	Rem
	bbdoc: Clones the profile
	returns: Profile which is exact copy of given.
	End Rem
	Method Clone:LTProfile()
		Local Profile:LTProfile = New Self
		Profile.Name = Name
		Profile.Language = Language
		Profile.AudioDriver = AudioDriver
		Profile.VideoDriver = VideoDriver
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
	
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageIntAttribute( "score", Score )
		XMLObject.ManageStringAttribute( "language", Language )
		XMLObject.ManageStringAttribute( "audio", AudioDriver )
		XMLObject.ManageStringAttribute( "video", VideoDriver )
		XMLObject.ManageIntAttribute( "fullscreen", FullScreen )
		XMLObject.ManageIntAttribute( "width", ScreenWidth )
		XMLObject.ManageIntAttribute( "height", ScreenHeight )
		XMLObject.ManageIntAttribute( "depth", ColorDepth )
		XMLObject.ManageIntAttribute( "frequency", Frequency )
		XMLObject.ManageChildList( Keys )
		XMLObject.ManageIntAttribute( "sound_on", SoundOn, 1 )
		XMLObject.ManageDoubleAttribute( "sound_volume", SoundVolume, 1.0 )
		XMLObject.ManageIntAttribute( "music_on", MusicOn, 1 )
		XMLObject.ManageDoubleAttribute( "music_volume", MusicVolume, 1.0 )
	End Method
End Type