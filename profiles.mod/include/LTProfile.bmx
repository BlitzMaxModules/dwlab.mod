'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentProfile:LTProfile
Global L_Profiles:TList = New TList
Global L_Languages:TList = New TList
Global L_AudioDrivers:TList

Global L_ScreenWidthGrain:Int = 80
Global L_ScreenHeightGrain:Int = 60
Global L_DesktopAreaWidth:Int = DesktopWidth()
Global L_DesktopAreaHeight:Int = DesktopHeight() - 86

Type LTProfile Extends LTObject
	Field Name:String
	Field Score:Int
	Field Language:String
	Field AudioDriver:String
	Field VideoDriver:String
	Field FullScreen:Int
	Field ScreenWidth:Int
	Field ScreenHeight:Int
	Field ColorDepth:Int
	Field Frequency:Int
	Field Keys:TList = New TList
	Field SoundOn:Int = True
	Field SoundVolume:Double = 1.0
	Field MusicOn:Int = True
	Field MusicVolume:Double = 1.0
	
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
			Select DriverTypeID.Name()
				Case "TD3D7Max2DDriver"
					Driver = D3D7Max2DDriver()
				Case "TD3D9Max2DDriver"
					Driver = D3D9Max2DDriver()
			End Select
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
		
		L_AudioDrivers = TList.FromArray( AudioDrivers() )
	End Function
	
	Function CreateDefault( ProfileTypeID:TTypeID )
		L_CurrentProfile = LTProfile( ProfileTypeID.NewObject() )
		L_CurrentProfile.Name = "{{P_Player}}"
		
		Local TypeID:TTypeId = TTypeId.ForObject( GetGraphicsDriver() )
		For Local Driver:LTVideoDriver = Eachin L_VideoDrivers
			If TTypeID.ForObject( Driver.Driver ) = TypeID Then L_CurrentProfile.VideoDriver = Driver.Name
		Next
		
		Local Resolution:LTScreenResolution = LTScreenResolution.Get()
		L_CurrentProfile.ScreenWidth = Resolution.Width
		L_CurrentProfile.ScreenHeight = Resolution.Height
		Local ColorDepth:LTColorDepth = LTColorDepth.Get( Resolution )
		L_CurrentProfile.ColorDepth = ColorDepth.Bits
		L_CurrentProfile.Frequency = LTFrequency.Get( ColorDepth ).Hertz
		
		?win32
		If AudioDriverExists( "DirectSound" ) Then L_CurrentProfile.AudioDriver = "DirectSound"
		?
		If Not L_CurrentProfile.AudioDriver And AudioDrivers() Then L_CurrentProfile.AudioDriver = AudioDrivers()[ 0 ]
		
		L_CurrentProfile.Init()
		L_CurrentProfile.Flush()
	End Function
	
	Function GetLanguage:TMaxGuiLanguage( Name:String )
		For Local Language:TMaxGuiLanguage = Eachin L_Languages
			If Language.GetName() = Name Then Return Language
		Next
		Return TMaxGuiLanguage( L_Languages.First() )
	End Function
	
	Method Apply( Projects:LTProject[] = Null, NewScreen:Int = True, NewVideoDriver:Int = True, NewAudioDriver:Int = True )
		SetLocalizationLanguage( GetLanguage( Language ) )
		
		If NewVideoDriver Then SetGraphicsDriver( LTVideoDriver.Get( VideoDriver ).Driver ); 
		
		If NewScreen Or NewVideoDriver Then
			NewAudioDriver = True
			Local BlockSize:Int = GetBlockSize()
			EndGraphics()
			If FullScreen Then
				Graphics( ScreenWidth, ScreenHeight, ColorDepth, Frequency )
			Else
				Graphics( L_ScreenWidthGrain * BlockSize, L_ScreenHeightGrain * BlockSize, , Frequency )
			End If
			AutoImageFlags( FILTEREDIMAGE | DYNAMICIMAGE )
			SetBlend( AlphaBlend )
		End If
		
		If NewAudioDriver Then SetAudioDriver( AudioDriver )
		
		If Projects Then
			For Local Project:LTProject = Eachin Projects
				If NewVideoDriver Or NewScreen Then Project.InitGraphics()
				If NewAudioDriver Then Project.InitSound()
			Next
		End If
	End Method
	
	Method GetBlockSize:Double()
		Local Width:Int, Height:Int 
		If FullScreen Then
			Width = ScreenWidth
			Height = ScreenHeight
		Else
			Width = L_DesktopAreaWidth
			Height = L_DesktopAreaHeight
		End If
		Width = Floor( Width / L_ScreenWidthGrain ) * L_ScreenWidthGrain
		Height = Floor( Height / L_ScreenHeightGrain ) * L_ScreenHeightGrain
		Return Min( Floor( Width / L_ScreenWidthGrain ), Floor( Height / L_ScreenHeightGrain ) )
	End Method
	
	Method InitCamera( Camera:LTCamera )
		Local BlockSize:Int = GetBlockSize()
		Local Width:Int = L_ScreenWidthGrain * BlockSize
		Local Height:Int = L_ScreenHeightGrain * BlockSize
		Camera.SetSize( Camera.Width, Camera.Width / Width * Height )
		Camera.Viewport.SetCoords( 0.5 * GraphicsWidth(), 0.5 * GraphicsHeight() )
		Camera.Viewport.SetSize( Width, Height )
		Camera.Update()
	End Method
	
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
	
	Method Init()
	End Method
	
	Method Flush()
	End Method
	
	Method Load()
	End Method
	
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