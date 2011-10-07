'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTColorDepth.bmx"

Global L_ScreenResolutions:TList = New TList

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