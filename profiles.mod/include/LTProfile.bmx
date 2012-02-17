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
	
	Field MinGrainSize:Int = 8
	Field GrainXQuantity:Int = 64
	Field MinGrainYQuantity:Int = 36
	Field MaxGrainYQuantity:Int = 48
	
	
	
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
				Case "TD3D7Max2DDriver", "TD3D9Max2DDriver"
					Driver = TMax2DDriver( DriverTypeID.NewObject() )
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
	
	
	
	Method ChangeViewportResolution( Width:Int, Height:Int )
		debugstop
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
	
	
	
	Method SetAsCurrent()		
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageStringAttribute( "name", Name )
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
		XMLObject.ManageIntAttribute( "x_resolution", L_XResolution )
		XMLObject.ManageIntAttribute( "y_resolution", L_YResolution )
	End Method
End Type