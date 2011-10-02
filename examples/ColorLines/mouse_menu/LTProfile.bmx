'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_CurrentProfile:LTProfile
Global L_ScreenWidthGrain:Int = 48
Global L_ScreenHeightGrain:Int = 48
Global L_Languages:TList = New TList
Global L_VideoDrivers:TList = New TList
Global L_AudioDrivers:TList
Global L_ScreenResolutions:TList = New TList

Type LTProfile Extends LTObject
	Field Name:String
	Field Language:String
	Field AudioDriver:String
	Field VideoDriver:String
	Field FullScreen:Int
	Field ScreenWidth:Int
	Field ScreenHeight:Int
	Field ColorDepth:Int
	Field Frequency:Int
	
	Function Init()
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
		
		LTProfile.CreateDefault()
		L_CurrentProfile.Apply( False )
	End Function
	
	Function CreateDefault()
		L_CurrentProfile = New LTProfile
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
	End Function
	
	Function GetLanguage:TMaxGuiLanguage( Name:String )
		For Local Language:TMaxGuiLanguage = Eachin L_Languages
			If Language.GetName() = Name Then Return Language
		Next
		Return TMaxGuiLanguage( L_Languages.First() )
	End Function
	
	Method Apply( Refresh:Int = True, Projects:LTProject[] = Null, NewScreen:Int = True, NewVideoDriver:Int = True, NewAudioDriver:Int = True )
		SetLocalizationLanguage( GetLanguage( Language ) )
		
		If NewVideoDriver Then SetGraphicsDriver( LTVideoDriver.Get( VideoDriver ).Driver )
		If NewAudioDriver Then SetAudioDriver( AudioDriver )
		
		If NewScreen Or NewVideoDriver Then
			Local Width:Int, Height:Int 
			If FullScreen Then
				Width = ScreenWidth
				Height = ScreenHeight
			Else
				Width = DesktopWidth()
				Height = DesktopHeight() - 86
			End If
			Width = Floor( Width / L_ScreenWidthGrain ) * L_ScreenWidthGrain
			Height = Floor( Height / L_ScreenHeightGrain ) * L_ScreenHeightGrain
			Local BlockSize:Int = Min( Floor( Width / L_ScreenWidthGrain ), Floor( Height / L_ScreenHeightGrain ) )
			EndGraphics()
			If FullScreen Then
				L_InitGraphics( ScreenWidth, ScreenHeight, 64.0, ColorDepth, Frequency )
				L_CurrentCamera.Viewport.SetSize( L_ScreenWidthGrain * BlockSize, L_ScreenHeightGrain * BlockSize )
				L_CurrentCamera.Update()
				L_CurrentCamera.SetCameraViewport()
			Else
					L_InitGraphics( L_ScreenWidthGrain * BlockSize, L_ScreenHeightGrain * BlockSize, 64.0, , Frequency )
			End If
		End If
		
		If Refresh Then
			For Local Project:LTProject = Eachin Projects
				If NewVideoDriver Or NewScreen Then Project.InitGraphics()
				If NewAudioDriver Then Project.InitSound()
			Next
		End If
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
	End Method
End Type



Type LTVideoDriver
	Field Name:String
	Field Driver:TMax2DDriver
	
	Function Get:LTVideoDriver( Name:String ="" )
		For Local Driver:LTVideoDriver = Eachin L_VideoDrivers
			If Driver.Name = Name Then Return Driver
		Next
		Return LTVideoDriver( L_VideoDrivers.First() )
	End Function
End Type



Type LTScreenResolution
	Field Width:Int
	Field Height:Int
	Field ColorDepths:TList = New TList
	
	Function Add( Width:Int, Height:Int, Bits:Int, Hertz:Int )
		For Local Resolution:LTScreenResolution = Eachin L_ScreenResolutions
			If Resolution.Width = Width And Resolution.Height = Height Then
				LTColorDepth.Add( Resolution, Bits, Hertz )
				Return
			End If
		Next
		
		Local Resolution:LTScreenResolution = New LTScreenResolution
		Resolution.Width = Width
		Resolution.Height = Height
		L_ScreenResolutions.AddLast( Resolution )
		LTColorDepth.Add( Resolution, Bits, Hertz )
	End Function
	
	Function Get:LTScreenResolution( Width:Int = 0, Height:Int = 0 )
		Local MaxResolution:LTScreenResolution = Null
		For Local Resolution:LTScreenResolution = Eachin L_ScreenResolutions
			If Resolution.Width = L_CurrentProfile.ScreenWidth And Resolution.Height = L_CurrentProfile.ScreenHeight Then Return Resolution
			If Not MaxResolution Then
				MaxResolution = Resolution
			ElseIf Resolution.Width >= MaxResolution.Width And Resolution.Height >= MaxResolution.Height Then
				MaxResolution = Resolution
			End If
		Next
		Return MaxResolution
	End Function
End Type



Type LTColorDepth
	Field Bits:Int
	Field Frequencies:TList = New TList
	
	Function Add( Resolution:LTScreenResolution, Bits:Int, Hertz:Int )
		For Local ColorDepth:LTColorDepth = Eachin Resolution.ColorDepths
			If ColorDepth.Bits = Bits Then
				LTFrequency.Add( ColorDepth, Hertz )
				Return
			End If
		Next
		
		Local ColorDepth:LTColorDepth = New LTColorDepth
		ColorDepth.Bits = Bits
		Resolution.ColorDepths.AddLast( ColorDepth )
		LTFrequency.Add( ColorDepth, Hertz )
	End Function
	
	Function Get:LTColorDepth( Resolution:LTScreenResolution, Bits:Int = 0 )
		Local MaxDepth:LTColorDepth = Null
		For Local Depth:LTColorDepth = Eachin Resolution.ColorDepths
			If Depth.Bits = Bits Then Return Depth
			If Not MaxDepth Then
				MaxDepth = Depth
			ElseIf Depth.Bits > MaxDepth.Bits Then
				MaxDepth = Depth
			End If
		Next
		Return MaxDepth
	End Function
End Type



Type LTFrequency
	Field Hertz:Int
	
	Function Add( ColorDepth:LTColorDepth, Hertz:Int )
		Local Frequency:LTFrequency = New LTFrequency
		Frequency.Hertz = Hertz
		ColorDepth.Frequencies.AddLast( Frequency )
	End Function
	
	Function Get:LTFrequency( ColorDepth:LTColorDepth, Hertz:Int = 0 )
		Local MaxFrequency:LTFrequency = Null
		For Local Frequency:LTFrequency = Eachin ColorDepth.Frequencies
			If Frequency.Hertz = Hertz Then Return Frequency
			If Not MaxFrequency Then
				MaxFrequency = Frequency
			ElseIf Frequency.Hertz > MaxFrequency.Hertz Then
				MaxFrequency = Frequency
			End If
		Next
		Return MaxFrequency
	End Function
End Type