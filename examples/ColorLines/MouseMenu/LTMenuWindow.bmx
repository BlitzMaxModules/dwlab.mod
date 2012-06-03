'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global DestinationY:Double

Type LTMenuWindow Extends LTAudioWindow
	Const Speed:Double = 8.0
	
	Field Panel:LTShape
	Field Arrow:LTSprite
	Field ArrowFrame:Int
	
	Method Init()
		Panel = FindShape( "Panel" )
		Arrow = LTSprite( FindShape( "Arrow" ) )
		ArrowFrame = Arrow.Frame
		SetProfileName()
		Super.Init()
	End Method
	
	Method SetProfileName()
		LTLabel( FindShape( "Profile" ) ).Text = LocalizeString( "{{Profile}}|" + L_CurrentProfile.Name )
	End Method
	
	Method Draw()
		If Y > -Panel.Height Then L_CurrentCamera.Darken( 0.6 * ( Y + Panel.Height ) / Panel.Height )
		Super.Draw()
	End Method
	
	Method OnButtonPress( Gadget:LTGadget, ButtonAction:LTButtonAction )
		If ButtonAction <> L_LeftMouseButton Then Return
		Select Gadget.GetParameter( "action" )
			Case "switch"
				Switch()
			Default
				Super.OnButtonPress( Gadget, ButtonAction )
		End Select
	End Method
	
	Method Act()
		'If AppTerminate() Then Project.LoadWindow( World, "LTExitWindow" )
		SetProfileName()
		
		If DestinationY = Y Then
			Super.Act()
		ElseIf Abs( DestinationY - Y ) < 0.01 Then
			Y = DestinationY
			If DestinationY < 0 Then Project.Locked = False
			Arrow.Frame = ArrowFrame - ( DestinationY < 0 )
		Else
			SetY( DestinationY + ( Y - DestinationY ) * ( 1.0 - Project.PerSecond( Speed ) ) )
		End If
	End Method
	
	Method Switch()
		If Y < 0 Then
			DestinationY = 0
			Project.Locked = True
		Else
			DestinationY = -Panel.Height
		End If
	End Method
End Type