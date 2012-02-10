'
' Mouse-oriented game menu - Digital Wizard's Lab framework template
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TLevelSelectionWindow Extends LTWindow
	Method Save()
		Local List:TLevelsList = TLevelsList( FindShapeWithType( "TLevelsList" ) )
		If List.SelectedLevel Then
			Game.LoadLevel( TGameProfile( L_CurrentProfile ), LTLayer( List.SelectedLevel ) )
			Project.CloseWindow( Self )
		End If
	End Method
End Type