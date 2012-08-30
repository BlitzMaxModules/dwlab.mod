'
' Color Lines - Digital Wizard's Lab example
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TRestartButton Extends LTButton
	Method OnButtonDown( ButtonAction:LTButtonAction )
		If ButtonAction = L_LeftMouseButton Then Game.LoadWindow( Menu.World, "LTRestartWindow" )
		L_CurrentProfile.PlaySnd( Menu.ButtonClick )
		Super.OnButtonDown( ButtonAction )
	End Method
End Type