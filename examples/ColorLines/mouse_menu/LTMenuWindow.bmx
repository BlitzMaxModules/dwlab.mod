'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTMenuWindow Extends LTWindow
	Const Acceleration:Double = 0.1
	Const Speed:Double = 0.9
	
	Field StartingY:Double
	Field Panel:LTShape
	Field DestinationY:Double

	
	
	Method Init()
		Panel = FindShape( "Panel" )
		StartingY = Panel.Y
		Super.Init()
	End Method
	
	
	
	Method OnClick( Gadget:LTGadget, Button:Int )
		Select Gadget.GetParameter( "action" ).ToLower()
			Case "continue"
				DestinationY = StartingY - Panel.Height
			Case "menu"
				If Panel.Y < 0 Then DestinationY = StartingY
		End Select
	End Method
	
	
	
	Method Act()
		If DestinationY = Panel.Y Then
		ElseIf Abs( DestinationY - Panel.Y ) < 0.01 Then
			Active = True
			If DestinationY <> StartingY Then Project.Paused = False
		Else
			Move( 0, ( DestinationY - Panel.Y ) * Project.PerSecond( Speed ) )
		End If
	End Method
End Type